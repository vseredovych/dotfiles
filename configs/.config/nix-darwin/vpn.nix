# Work VPN — AnyConnect gateway via openconnect, split-tunneled with vpn-slice.
#
# Connection details (gateway, DNS, domains, routes) are private and live outside
# this repo in ~/.config/work-vpn/config — see the template printed by `work-vpn`
# when that file is missing.
#
# Usage:  work-vpn            (connects to $SERVER from the config)
#         work-vpn <host>     (connects to another gateway)
# Ctrl+C disconnects; vpn-slice removes its routes, /etc/hosts entries and /etc/resolver files.
{ pkgs, ... }:

let
  # openconnect runs as root; open the SSO login page in the user's own browser session.
  browser = pkgs.writeShellScript "work-vpn-browser" ''
    exec /usr/bin/sudo -u "''${SUDO_USER:-$USER}" /usr/bin/open "$1"
  '';

  # Called by openconnect on connect/disconnect: <dns,...> <domain,...> <route>...
  sliceScript = pkgs.writeShellScript "work-vpn-slice" ''
    export INTERNAL_IP4_DNS="''${1//,/ }"
    domains="$2"
    shift 2
    exec ${pkgs.vpn-slice}/bin/vpn-slice --domains-vpn-dns "$domains" "$@"
  '';

  work-vpn = pkgs.writeShellScriptBin "work-vpn" ''
    config="''${XDG_CONFIG_HOME:-$HOME/.config}/work-vpn/config"
    if [[ ! -r "$config" ]]; then
      cat >&2 <<EOF
    Missing $config. Create it (chmod 600) with:

      SERVER=vpn.example.com
      AUTHGROUP=GROUP-NAME
      DNS="10.0.0.53 10.0.1.53"
      DOMAINS="corp.example.com example.internal"
      ROUTES="10.0.0.0/16 192.0.2.0/24"
    EOF
      exit 1
    fi
    source "$config"

    server="''${1:-$SERVER}"
    for v in "$server" "$DNS" "$DOMAINS" "$ROUTES"; do
      if [[ -z "$v" || "$v" =~ [^A-Za-z0-9./:\ -] ]]; then
        echo "work-vpn: invalid or empty value in $config: '$v'" >&2
        exit 1
      fi
    done

    exec /usr/bin/sudo ${pkgs.openconnect}/bin/openconnect \
      --protocol=anyconnect \
      --useragent=AnyConnect \
      ''${AUTHGROUP:+--authgroup="$AUTHGROUP"} \
      --external-browser=${browser} \
      --script="${sliceScript} ''${DNS// /,} ''${DOMAINS// /,} $ROUTES" \
      "$server"
  '';
in
{
  environment.systemPackages = [
    pkgs.openconnect
    pkgs.vpn-slice
    work-vpn
  ];
}
