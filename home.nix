{ config, pkgs, ... }: {
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Required Git Configuration
  programs.git.enable = true;

  # Bash configuration & auto-start Hyprland via UWSM
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    profileExtra = ''
      if [ -z "$WAYLAND_DISPLAY" ] && [ "$XDG_VTNR" = 1 ]; then
        exec uwsm start -S hyprland-uwsm.desktop
      fi
    '';
  };

  # User-space packages (e.g. wallpaper utility)
  home.packages = with pkgs; [
    hyprpaper
  ];
}
