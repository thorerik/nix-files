{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        ## Both disabled since they are now obtained as flatpaks
        # slack
        # discord
    ];
}