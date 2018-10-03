{ lib, pkgs, ... }: # config, 
with lib;

let secrets = import ../secrets.nix;
in
{
  users = {
    extraUsers.thor = {
      isNormalUser = true;
      home = "/home/thor";
      uid = 1000;
      extraGroups = [ 
        "wheel"
        "networkmanager"
        "docker"
        "fuse"
        "vboxusers"
        "libvirtd"
        "audio"
      ];
      shell = pkgs.zsh;
    };
  };
}