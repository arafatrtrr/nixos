{ config, pkgs, ... }: {
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Required Git Configuration
  programs.git.enable = true;

  # Bash configuration (Completely safe from loops)
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo i use nixos, btw";
    };
  };

  # User-space packages
  home.packages = with pkgs; [
    hyprpaper
  ];
}
