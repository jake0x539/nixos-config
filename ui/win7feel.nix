{
  config,
  pkgs,
  lib,
  osConfig,
  ...
}: {
  imports = [
    # ./config/tiling.nix
    ./extra/ulauncher.nix
    ./extra/nemo.nix
    ./extra/gnome-specific.nix
    ./config/gnome-keybindings.nix
  ];

  home.packages = with pkgs; [
    gnomeExtensions.dash-to-panel
    # gnomeExtensions.arcmenu

    gnomeExtensions.blur-my-shell
    # gnomeExtensions.user-themes
    gnomeExtensions.just-perfection
    gnomeExtensions.appindicator

    papirus-icon-theme
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "dash-to-panel@jderose9.github.com"
        # "arcmenu@arcmenu.com"
        "blur-my-shell@aunetx"
        # "user-theme@gnome-shell-extensions.gcampax.github.com"
        "just-perfection-desktop@just-perfection"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };

    "org/gnome/shell/extensions/dash-to-panel" = {
      panel-position = "TOP";
      panel-size = 32;
      taskbar-locked = true;

      # Transparency / Glass look
      transparency-mode = "FIXED";
      background-opacity = 0.4; # High transparency for blur to shine through

      # Taskbar behavior
      group-apps = true;
      show-apps-icon-side = "left";
      active-indicator-style = "DASH";
      # active-indicator-color-focused = "#5294e2"; # Classic Win7 Blue
      hot-keys-action = 0;
    };

    "org/gnome/shell/extensions/arcmenu" = {
      arc-menu-icon = 47;
      button-padding = -1;
      custom-menu-button-icon-size = 36.0;
      distro-icon = 22;
      menu-button-icon = "Distro_Icon";
      menu-button-position-offset = 2;
      prefs-visible-page = 0;
    };

    # AERO GLASS: Blur effect
    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.75;
      sigma = 40; # Higher sigma = "frostier" glass
    };

    "org/gnome/shell/extensions/blur-my-shell/panel" = {
      blur = true;
      pipeline = "pipeline_default";
    };

    # BUTTONS: Back to the Right side
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "appmenu:minimize,maximize,close";
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Papirus-Dark";
      gtk-application-prefer-dark-theme = true;
    };

    # "org/gnome/shell/extensions/user-theme" = {
    #   name = "WhiteSur-Dark";
    # };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };
}
