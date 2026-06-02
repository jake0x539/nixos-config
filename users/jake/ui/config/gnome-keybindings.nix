{...}: {
  dconf.settings = {
    "org/gnome/desktop/wm/keybindings" = {
      activate-window-menu = [];
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher/"
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty/"
      ];
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ulauncher" = {
      name = "Ulauncher";
      command = "ulauncher-toggle";
      binding = "<Alt>space";
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ghostty" = {
      name = "Ghostty";
      command = "ghostty";
      binding = "<Super>t";
    };
  };
}
