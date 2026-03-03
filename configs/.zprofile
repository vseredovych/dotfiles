# Only auto-launch if on tty1 and not already in a graphical session
if [[ -z $DISPLAY ]] && [[ $(tty) == /dev/tty1 ]]; then
  # Optional delay to let system settle
  # sleep 1

  # Then launch Hyprland
  # exec Hyprland
  exec Hyprland > ~/.hyperland.log 2>&1
fi
