# Work VPN: AnyConnect gateway via openconnect-sso (github:vseredovych/openconnect-sso),
# split-tunneled with vpn-slice, with a menu bar toggle.
#
# Connection details (gateway, DNS, domains, routes) are private and live outside this
# repo in ~/.config/work-vpn/config.
#
# Usage:  work-vpn [up [host]] | down | status | log      (or the lock icon in the menu bar)
{ ... }:

{
  programs.openconnect-sso = {
    enable = true;
    splitTunnel = {
      enable = true;
      name = "work-vpn";
      allowLegacyTls = true; # the gateway only offers TLS_RSA / CBC-SHA1 ciphers
    };
    menubar = {
      enable = true;
      title = "Work VPN";
    };
  };
}
