{ config, pkgs, ... }:
{
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
        gnome3.dconf
        binutils
        file
        pciutils
        glxinfo
        bat
    ];
}