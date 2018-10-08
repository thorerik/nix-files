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

        gitkraken
    ];
}