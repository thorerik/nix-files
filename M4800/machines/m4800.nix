{
  imports = [
    ../system/packages/intel
    ../system/packages/basic.nix
    ../system/packages/browsers.nix
    ../system/packages/communication.nix
    ../system/packages/dev.nix
    ../system/packages/entertainment.nix
    ../system/packages/styles.nix
    ../system/packages/utils.nix
    ../system/packages/work.nix
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
    ];
    networkmanager.enable = true;
    firewall.enable = true;
  };

  services = {
    printing.enable = true;
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

  virtualisation = {
    libvirtd.enable = true;
    virtualbox.host.enable = true;
  };
}