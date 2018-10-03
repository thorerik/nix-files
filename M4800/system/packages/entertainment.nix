{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        spotify
        steam
        minecraft
        neofetch
        mixxx
        clementine
    ];
}