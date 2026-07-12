{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # 1. Bootloader Configuration (Crucial for dual-booting)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Hostname & Time Zone
  networking.hostName = "nixos";
  time.timeZone = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  # Use the latest Linux Kernel Packages for best Arc GPU support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 3. Wi-Fi Configuration (Auto-connect to Nomi-5G)
  networking.networkmanager.enable = true;
  networking.networkmanager.ensureProfiles.profiles = {
    "Nomi-5G" = {
      connection = {
        id = "Nomi-5G";
        type = "wifi";
      };
      wifi = {
        ssid = "Nomi-5G";
        mode = "infrastructure";
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "244466666";
      };
      ipv4 = {
        method = "auto";
      };
    };
  };

  # 4. Bluetooth Configuration
  hardware.bluetooth.enable = true;
  services.blueman.enable = true; 

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

  # 6. Intel Arc A750 Graphics Drivers
  # DG2 Arc cards are natively driven by 'i915'. We use 'modesetting' as the video driver for Wayland stability.
  boot.initrd.kernelModules = [ "i915" ];
  boot.kernelModules = [ "i915" ];
  services.xserver.videoDrivers = [ "modesetting" ];

  # Parameter to enable performance / GuC support for Intel Arc cards
  boot.kernelParams = [ "i915.enable_guc=3" ]; 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # VA-API (iHD) for video acceleration
      vpl-gpu-rt           # oneVPL (QSV) runtime for newer GPUs
      intel-compute-runtime # OpenCL compute runtime for Intel GPUs
    ];
  };

  # 7. Enable SSH
  services.openssh.enable = true;

  # 8. Enable Experimental Flakes Support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 9. Enable Hyprland with UWSM
  programs.firefox.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # 10. User Account (Create user "tony")
  users.users.tony = {
    isNormalUser = true;
    description = "Tony";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ]; 
    packages = with pkgs; [ tree ];
  };

  # 11. Getty Autologin (TTY1 autologin directly to Hyprland)
  services.getty.autologinUser = "tony";

  # 12. System Packages
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
