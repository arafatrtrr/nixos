{ config, pkgs, ... }:

{
  imports = [ ];

  # 1. GRUB Bootloader Configuration (UEFI & Dual-Boot)
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true; # Automatically detects Windows partition
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  # 2. Modern Kernel & Graphics Fixes (For Intel Arc A750 GPU)
  boot.kernelPackages = pkgs.linuxPackages_latest; # Use the latest Linux kernel
  boot.initrd.kernelModules = [ "i915" ];          # Load graphics driver early
  boot.kernelModules = [ "i915" ];
  boot.kernelParams = [ "i915.enable_guc=3" ];      # Required for Arc cards
  services.xserver.videoDrivers = [ "modesetting" ]; # Recommend driver for Wayland/modern Intel

  # 3. Hostname & Time Zone
  networking.hostName = "hyprland-btw";
  time.timeZone = "Asia/Dhaka";
  i18n.defaultLocale = "en_US.UTF-8";

  # 4. Wi-Fi Configuration (Auto-connect to Nomi-5G)
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

  # 5. Bluetooth Configuration
  hardware.bluetooth.enable = true;
  services.blueman.enable = true; 

  # 6. Sound Configuration (PipeWire)
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # 7. Hardware Acceleration Packages
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver   # Hardware accelerated video decoding
      vpl-gpu-rt           # Intel video processing library runtime (QSV)
      intel-compute-runtime # OpenCL compute runtime for Intel Arc/Xe
    ];
  };

  # 8. Enable Experimental Flakes Support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # 9. Enable Hyprland with UWSM
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # 10. User Account (Create user "tony")
  users.users.tony = {
    isNormalUser = true;
    description = "Tony";
    extraGroups = [ "networkmanager" "wheel" "video" "render" ]; 
    packages = with pkgs; [ ];
  };

  # 11. Getty Autologin
  # Temporarily commented out to prevent display crash loops on startup.
  # services.getty.autologinUser = "tony";

  # 12. SSH Configuration
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.openssh.settings.PasswordAuthentication = true;

  # 13. Essential System Packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Allow proprietary/unfree packages and non-free firmware (Required for Intel Arc)
  nixpkgs.config.allowUnfree = true;
  hardware.enableRedistributableFirmware = true;

  # State version
  system.stateVersion = "26.05"; 
}
