{
  config,
  pkgs,
  inputs,
  ...
}: let
  unstable = inputs.nixpkgs-unstable.legacyPackages.${pkgs.system};
in {
  home.username = "jake";
  home.homeDirectory = "/home/jake";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    telegram-desktop
    ffmpeg
    yt-dlp
    deluge-gtk
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg
    nerd-fonts.commit-mono
    nerd-fonts.ubuntu
    pinta
    github-desktop
  ];

  # Fish user config stays in home.nix because I want to easily be editing my shell aliases
  programs.fish = {
    enable = true;
    interactiveShellInit = "
    fish_add_path /etc/profiles/per-user/jake/bin
    fish_add_path ~/.nix-profile/bin
    set -g fish_greeting ''
    ";

    shellAliases = {
      sysbuild = "sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-config/ #nixos";
      sysupgrade = "sudo nix flake update --flake ${config.home.homeDirectory}/nixos-config/ && sudo nixos-rebuild switch --flake ${config.home.homeDirectory}/nixos-config/ #nixos";
      cleanup = "sudo nix-collect-garbage -d";
    };
  };

  services.easyeffects.enable = false;

  imports = [
    ./ui/win7feel.nix
    ./programs/ghostty.nix
    ./programs/obs.nix
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = ["brave-browser.desktop"];
      "x-scheme-handler/http" = ["brave-browser.desktop"];
      "x-scheme-handler/https" = ["brave-browser.desktop"];
      "x-scheme-handler/about" = ["brave-browser.desktop"];
      "x-scheme-handler/unknown" = ["brave-browser.desktop"];
    };
  };

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
