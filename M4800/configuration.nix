# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  #boot.loader.grub.enable = false;
  #boot.loader.grub.version = 2;
  #boot.loader.grub.device = "nodev";
  #boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/disk/by-uuid/b9af358e-410d-477f-8b4c-174de163700d";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    #nvidiaOptimus.disable = true;
  };

  networking.hostName = "thor-nixos"; # Define your hostname.
  networking.extraHosts = ''
    127.0.0.1 thor-nixos
  '';

  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.networkmanager.useDnsmasq = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    #consoleKeyMap = "en";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    sudo
    tmux
    git
    weechat
    spotify
    gist
    firefox
    google-chrome
    opera
    discord
    slack
    openconnect
    openssl
    noto-fonts
    noto-fonts-emoji
    steam
    aspell
    neovim
    python3
    python36Packages.pip
    python36Packages.neovim
    remmina
    jetbrains.phpstorm
    php
    php71Packages.phpcbf
    php71Packages.phpcs
    php71Packages.composer
    jetbrains.datagrip
  ];

  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.bash.enableCompletion = true;
  programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    xkbOptions = "ctrl:nocaps";
    layout = "no";

    videoDrivers = [ "intel" "vesa" ];

  };
  # services.xserver.xkbOptions = "eurosign:e";

  fonts.enableCoreFonts = true;
  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.thor = {
    isNormalUser = true;
    home = "/home/thor";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "vboxusers" ];
  };

  virtualisation.docker.enable = true;
  #virtualisation.virtualbox.host.enable = true;
  #nixpkgs.config.virtualbox.enableExtensionPack = true;

  hardware.bumblebee.enable = true;
  hardware.bumblebee.connectDisplay = true;

  users.defaultUserShell = "/run/current-system/sw/bin/zsh";
  programs.zsh.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
