{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        libsForQt5.qtstyleplugin-kvantum 
        arc-icon-theme
    ];
}
    