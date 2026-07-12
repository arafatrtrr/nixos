{ config, pkgs, ... }: {
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Required Git Configuration
  programs.git.enable = true;

  # Bash configuration & auto-start Hyprland via UWSM (Loop-proof)
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };

  # User-space packages
  home.packages = with pkgs; [
    hyprpaper
  ];
}
