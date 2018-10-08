{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        # spotify # Obtained as flatpak
        steam
        minecraft
        neofetch
        mixxx
        clementineUnfree
    ];
}