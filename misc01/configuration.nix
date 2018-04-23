# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  hardware.cpu.intel.updateMicrocode = true;

  networking = {
    interfaces = {
      eno1 = {
        ipAddress = "10.0.0.22";
      };
    };
    useDHCP = false;
    defaultGateway = "10.0.0.1";
    domain = "av62.local";
    hostName = "misc01";
    hostId = "a3d74f28";
  };

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  environment.systemPackages = with pkgs; [
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
    binutils
    file
    pciutils
  ];

  programs = {
    bash.enableCompletion = true;
    zsh.enable = true;
  };

  virtualisation = {
    docker.enable = true;
  };

  services = {
    openssh = {
      enable = true;
      passwordAuthentication = false;
    };

    acpid.enable = true;
    haveged.enable = true;
    ntp.enable = false; # NTP is handled by chrony

    chrony = {
      enable = true;
      servers = ["0.no.pool.ntp.org" "1.no.pool.ntp.org"];
    };

    locate = {
      enable = true;
      interval = "11:10";
    };

    journald.extraConfig = ''
      Storage=persistent
    '';

    dnsmasq = {
      enable = true;
      servers = [
        "10.0.0.2"
      ];
      extraConfig = ''
        bind-interfaces
        listen-address=127.0.0.1
        local=/docker/127.0.0.2
      '';
    };
  };

  security = {
    sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 80 443 ];

  users.extraUsers.thor = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" ];
  };

  filesystems = {
    "/mnt/nfs" = {
      device = "10.0.0.2:/volume1/data";
      fsType = "nfs";
      options = ["x-systemd.automount,noauto,x-systemd.device-timeout=10,timeo=14,x-systemd.idle-timeout=1min"];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?

}
