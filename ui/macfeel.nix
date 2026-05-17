{
  config,
  osConfig,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./config/tiling.nix
    ./extra/ulauncher.nix
    ./extra/nemo.nix
    ./extra/gnome-specific.nix
    ./config/gnome-keybindings.nix
  ];

  home.packages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnomeExtensions.blur-my-shell
    gnomeExtensions.user-themes
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator

    whitesur-gtk-theme
    whitesur-icon-theme
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;

      enabled-extensions = [
        "dash-to-dock@micxgx.gmail.com"
        "blur-my-shell@aunetx"
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-dock" = {
      dock-position = "BOTTOM";
      dock-fixed = false;
      dash-max-icon-size = 64;
      custom-theme-shrink = true;
      transparency-mode = "FIXED";
      background-opacity = 0.0;

      click-action = "minimize-or-previews";
      scroll-action = "cycle-windows";

      extend-height = false;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.85;
      sigma = 30; # Blur amount
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      pipeline = "pipeline_default";
    };

    "org/gnome/desktop/wm/preferences" = {
      button-layout = ":minimize,maximize,close";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "WhiteSur-Dark";
      icon-theme = "WhiteSur";
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "WhiteSur-Dark";
    };
  };
}
