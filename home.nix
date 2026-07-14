{ config, pkgs, ... }: {
  home.username = "tony";
  home.homeDirectory = "/home/tony";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  # Required Git Configuration
  programs.git.enable = true;

  # Configure Kitty Terminal natively
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
    };
  };

  # Configure Fish Shell natively
  programs.fish = {
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
