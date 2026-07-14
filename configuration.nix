{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # 1. Bootloader Configuration (Required EFI enabled in VirtualBox)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Hostname & Time Zone
  networking.hostName = "nixos";
  time.timeZone = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  # Use the latest Linux Kernel Packages
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 3. VirtualBox Network Configuration
  # VirtualBox uses a virtual wired connection (NAT or Bridged).
  # NetworkManager automatically configures this; no Wi-Fi profiles are needed.
  networking.networkmanager.enable = true;

  # 4. VirtualBox Guest Integration
  # Enables shared clipboard, seamless display resizing, and pointer integration.
  virtualisation.virtualbox.guest.enable = true;

  # 5. Sound Configuration (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # 6. Graphics Drivers for VirtualBox Guest
  hardware.graphics.enable = true;

  # 7. Enable SSH
  services.openssh.enable = true;

  # 8. Enable Experimental Flakes Support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 9. Enable SDDM with Wayland & Auto-login directly to Hyprland-UWSM
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "tony";
    };
    defaultSession = "hyprland-uwsm";
  };

  # 10. Enable Hyprland with UWSM
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # 11. Enable Fish Shell System-Wide
  programs.fish.enable = true;

  # 12. User Account (Create user "tony" with Fish shell configured as default)
  users.users.tony = {
    isNormalUser = true;
    description = "Tony";
    shell = pkgs.fish; # Sets Fish as default login shell
    extraGroups = [ "networkmanager" "wheel" "video" "render" ]; 
    packages = with pkgs; [ tree ];
  };

  # 13. System Packages
  environment.systemPackages = with pkgs; [
    neovim
    wget
    foot
    waybar
    kitty
  ];

  # NixOS state version
  system.stateVersion = "26.05"; 
}
