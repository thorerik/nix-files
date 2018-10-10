{ config, pkgs, lib, ... }:

{
  services = {
    haveged.enable = true;
    thermald.enable = true;

    flatpak = { 
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-kde
      ];
    };

    acpid.enable = true;

    ntp.enable = false; # NTP is handled by chrony

    chrony = {
      enable = true;
      servers = ["0.no.pool.ntp.org" "1.no.pool.ntp.org"];
    };

    nscd.enable = false;

    udisks2.enable = true;

    dbus.packages = [ ];

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
      displayManager.sddm = {
        enable = true;
        autoNumlock = true;
        #theme = "plasma-chili";
      };
      
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

    journald.extraConfig = ''
      Storage=persistent
    '';
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "no-latin1";
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
    };
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

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
    firejail = {
      enable = true;
      wrappedBinaries = {
        firefox = "${lib.getBin pkgs.firefox}/bin/firefox";
      };
    };
  };

  virtualisation = {
    docker.enable = true;
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
  system = {
    stateVersion = "18.09";
    autoUpgrade = {
      enable = true;
      dates = "02:00";
      channel = "https://nixos.org/channels/nixos-18.09";
    };
  };
}