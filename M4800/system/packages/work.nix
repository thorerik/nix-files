{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        openconnect
        openssl
    ];
}