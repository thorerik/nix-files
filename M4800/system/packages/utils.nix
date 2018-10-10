{ config, pkgs, ... }:
{
    environment.systemPackages = with pkgs; [
        gist
        aspell
        aspellDicts.en
        remmina
        inkscape
        darktable
        cifs-utils
        kitty
        hyper
        kate
        terraform
        vagrant
        vscode
        pwgen
        neofetch
        sddm-kcm
    ];
}
