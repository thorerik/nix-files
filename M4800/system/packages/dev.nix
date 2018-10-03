{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        jetbrains.phpstorm
        php
        php72Packages.phpcbf
        php72Packages.phpcs
        php72Packages.composer

        # dba
        jetbrains.datagrip

        # java/scala
        jetbrains.idea-ultimate
        sbt

        (gitkraken.overrideAttrs (oldAttrs: rec {
            version = "4.0.5";
            src = fetchurl {
                url = "https://release.axocdn.com/linux/GitKraken-v${version}.deb";
                sha256 = "15wxcahlnz2k3331wqv30d5gq38fqh178hv87xky9b9vyh8qpcvz";
            };
        }))
    ];
}