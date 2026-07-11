{ config, pkgs, ... }: {
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "26.50";

  programs.home-manager.enable = true;

  # Bash auto-start Hyprland via UWSM
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use hyprland btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  # Basic user space environment tools required by Hyprland
  home.packages = with pkgs; [
    foot
    kitty
    waybar
    hyprpaper
  ];
}
