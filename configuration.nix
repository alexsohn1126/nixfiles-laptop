# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      # Include home manager
      <home-manager/nixos>
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # Bluetooth gui
  services.blueman.enable = true;

  # Droidcam setup
  boot.kernelModules = [
    "v4l2loopback"
  ];

  boot.extraModulePackages = [
    pkgs.linuxPackages.v4l2loopback
  ];

  security.polkit.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Timezone setup to fix windows time bug thing
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";
  i18n.inputMethod = {
    enabled = "kime";
    kime.iconColor = "White";
  };

  # Autodetect usb shit
  services.devmon.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # picom
  services.picom.enable = true;

  # X11
  services.xserver = {
    enable = true;

    layout = "us";
    xkbVariant = "";
    dpi = 128;

    desktopManager = {
      xterm.enable = false;
    };

    displayManager = {
      defaultSession = "none+i3";
      # setupCommands = "${pkgs.xorg.xrandr}/bin/xrandr --output DP-4 --auto --primary --mode 1920x1080 --rate 239.73 --output DP-0 --auto";
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu
        i3status
        i3lock
      ];
    };
  };

  # Audio setup
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Mullvad setup
  services.mullvad-vpn.enable = true;
  services.mullvad-vpn.package = pkgs.mullvad-vpn;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.alexs = {
    isNormalUser = true;
    description = "Alex Sohn";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [];
  };

  # Fish shell
  programs.fish.enable = true;
  users.users.alexs.shell = pkgs.fish;

  # allow myself to trusted users
  nix.trustedUsers = ["root" "alexs"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  
  # Enable Experimental shit
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow dynamic linked executables (for vscode)
  # programs.nix-ld.enable = true;
  # programs.nix-ld.package = pkgs.nix-ld-rs;

  # thunarr
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [ thunar-volman ];

  # qt theme
  qt = {
    enable = true;
    style = "adwaita-dark";
  };

  # steam
  programs.steam = {
    enable = true;
  };

  # enable ssh agent
  programs.ssh.startAgent = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    firefox
    kitty
    xclip
    maim
    git
    unzip
    dunst
    brightnessctl
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
