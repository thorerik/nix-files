# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include secrets I don't want to share with the world
      ./secrets.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd.luks.devices = [
      {
        name = "root";
        device = "/dev/disk/by-uuid/b9af358e-410d-477f-8b4c-174de163700d";
        preLVM = true;
        allowDiscards = true;
      }
    ];
  };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    bluetooth.enable = true;
  };

  networking = {
    hostName = "thor-nixos"; # Define your hostname.
    extraHosts = ''
      127.0.0.1 thor-nixos
    '';

    wireless.enable = false;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true; # We're using NetworkManager instead, it'll handle wpa_supplicant for us
    networkmanager.useDnsmasq = false;
    firewall.enable = true;
  };

  services = {
    xserver = {
      enable = true;
      layout = "no";
      videoDrivers = [ "nvidia" ];
      
      # Touchpad
      libinput.enable = true;

      # KDE
      displayManager.sddm.enable = true;
      displayManager.sddm.autoNumlock = true;
      desktopManager.plasma5.enable = true;
    };

    mopidy = {
      enable = true;
      extensionPackages = with pkgs; [
        mopidy-spotify
      ];
    };

    printing.enable = true;

    journald.extraConfig = ''
      Storage=persistent
    '';
    dnsmasq = {
      enable = true;
      servers = [
        "1.1.1.1"
        "1.0.0.1"
        "9.9.9.9"
      ];
      extraConfig = ''
        bind-interfaces
        listen-address=127.0.0.1
        local=/docker/127.0.0.2
        address=/test/192.168.10.10
      '';
    };
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
    };
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
    emojione
    steam
    aspell
    aspellDicts.en
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
    gitkraken
    vscode
    virtmanager-qt
    virtmanager
    virtviewer
    spice
    #spice-gtk
    #spice-protocol
    libosinfo
    htop
    neofetch
    mixxx
    
    binutils
    file
    pciutils
    glxinfo

    #libsForQt5.qtstyleplugin-kvantum 
    arc-icon-theme
    kate

    microcodeIntel

    terraform
    vagrant
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;

  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  fonts.enableCoreFonts = true;

  users = {
    extraUsers.thor = {
      isNormalUser = true;
      home = "/home/thor";
      uid = 1000;
      extraGroups = [ "wheel" "networkmanager" "docker" "fuse" "vboxusers" "libvirtd" "audio" ];
    };
    defaultUserShell = "/run/current-system/sw/bin/zsh";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
