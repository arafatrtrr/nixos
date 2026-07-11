{ config, pkgs, ... }:

{
  imports = [ ];

  # 1. GRUB Bootloader Configuration (UEFI & Dual-Boot)
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true; # Finds Windows partition automatically
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # Load display modules early (prevent black screen on Intel Arc GPU)
  boot.initrd.kernelModules = [ "xe" "i915" ];
  boot.kernelModules = [ "xe" "i915" ];

  # 2. Hostname & Time Zone
  networking.hostName = "hyprland-btw";
  time.timeZone = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

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
  boot.kernelParams = [ "i915.enable_guc=3" ]; 
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Hardware accelerated video decoding
      vpl-gpu-rt           # Intel video processing library runtime (QSV)
      intel-compute-runtime # OpenCL compute runtime for Intel Arc/Xe
    ];
  };

  # 7. Enable Experimental Flakes Support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 8. Enable Hyprland with UWSM
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # 9. User Account (Create user "tony")
  users.users.tony = {
    isNormalUser = true;
    description = "Tony";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ]; 
    packages = with pkgs; [ ];
  };

  # 10. Getty Autologin (TTY1 autologin directly to Hyprland)
  services.getty.autologinUser = "tony";

  # Essential System Packages (Required for git setup)
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # NixOS state version
  system.stateVersion = "26.05"; 
}
