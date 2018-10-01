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

  fileSystems = {
    "/" = {
      options = [ "noatime" "nodiratime" "discard" ];
    };
  };


  hardware = {
    opengl.driSupport32Bit = true;
    pulseaudio.enable = true;
    pulseaudio.support32Bit = true;
    bluetooth.enable = true;
    cpu.intel.updateMicrocode = true;
  };

  networking = {
    hostName = "thor-nixos"; # Define your hostname.
    hostId = "b42b595e"; # cksum /etc/machine-id | while read c rest; do printf "%x" $c; done
    extraHosts = ''
      127.0.0.1 thor-nixos
    '';
    search = [
      # searchpaths
    ];
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    haveged.enable = true;
    thermald.enable = true;

    acpid.enable = true;

    ntp.enable = false; # NTP is handled by chrony

    chrony = {
      enable = true;
      servers = ["0.no.pool.ntp.org" "1.no.pool.ntp.org"];
    };

    nscd.enable = false;

    udisks2.enable = true;

    dbus.packages = [ pkgs.gnome3.gconf ];

    redshift = {
      enable = true;
      latitude = "59";
      longitude = "10";
      brightness = {
        day = "1.0";
        night = "0.7";
      };
      temperature = {
        day = 5700;
        night = 3500;
      };
    };

    xserver = {
      enable = true;
      layout = "no";
      videoDrivers = [ "nvidia" ];

      startDbusSession = true;
      
      # Touchpad
      libinput.enable = true;

      # KDE
      displayManager.sddm.enable = true;
      displayManager.sddm.autoNumlock = true;
      desktopManager.plasma5.enable = true;
    };

    mopidy = {
      enable = false;
      extensionPackages = with pkgs; [
        mopidy-spotify # broken due to spotify :<
      ];
    };

    clamav = {
      daemon = {
        enable = true;
      };
      updater = {
        enable = true;
      };
    };

    locate = {
      enable = true;
      interval = "11:10";
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
    # basic system
    wget
    vim
    tmux
    git
    unzip
    pwgen
    httpie
    neovim
    python3
    python36Packages.pip
    python36Packages.neovim
    terminator
    patchelf
    htop
    gnome3.dconf
    binutils
    file
    pciutils
    glxinfo
    microcodeIntel

    # browsers
    firefox
    google-chrome
    opera

    # entertainment
    spotify
    steam
    minecraft
    neofetch
    mixxx
    clementine

    # utils
    gist
    aspell
    aspellDicts.en
    remmina
    inkscape
    darktable
    cifs-utils
    kitty
    hyper

    # communication
    slack

    # vpn
    openconnect
    openssl
    
    # php development
    jetbrains.phpstorm
    php
    php71Packages.phpcbf
    php71Packages.phpcs
    php71Packages.composer

    # dba
    jetbrains.datagrip

    # java/scala
    jetbrains.idea-ultimate
    sbt

    # misc development tools
    gitkraken
    kate
    terraform
    vagrant
    vscode
    ## Vscode deps
    libunwind
    lttng-ust
    openssl
    libuuid
    kerberos
    icu
    zlib
    libsecret
    desktop-file-utils

    # vm
    virtmanager-qt
    virtmanager
    virtviewer
    spice
    libosinfo
    
    # pretty
    libsForQt5.qtstyleplugin-kvantum 
    arc-icon-theme
  ];

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  nix = {
    gc = {
      automatic = true;
      dates = "03:15";
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    virtualbox.enableExtensionPack = true;
  };

  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

  virtualisation = {
    libvirtd.enable = true;
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  fonts = {
    enableCoreFonts = true;
    enableDefaultFonts = true;
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-emoji
      emojione
      fira-code
      fira-code-symbols
      dejavu_fonts
    ];
  };

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
