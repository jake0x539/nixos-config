{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  home.packages = with pkgs; [
    nemo-with-extensions
    file-roller
    nemo-fileroller
  ];

  xdg.mimeApps.defaultApplications = {
    "inode/directory" = ["nemo.desktop"];
    "application/x-gnome-saved-search" = ["nemo.desktop"];

    "application/zip" = ["org.gnome.FileRoller.desktop"];
    "application/x-zip-compressed" = ["org.gnome.FileRoller.desktop"];
    "application/x-tar" = ["org.gnome.FileRoller.desktop"];
    "application/x-gzip" = ["org.gnome.FileRoller.desktop"];
    "application/x-bzip2" = ["org.gnome.FileRoller.desktop"];
  };

  dconf.settings = lib.mkIf osConfig.services.desktopManager.gnome.enable {
    # Disable Nautilus from handling the desktop (letting GNOME Shell do it)
    "org/gnome/desktop/background" = {
      show-desktop-icons = false;
    };

    # Ensure Nemo doesn't try to draw the desktop/icons itself
    "org/nemo/desktop" = {
      show-desktop-icons = false;
    };

    "org/nemo/preferences" = {
      show-location-widget = true;
      show-status-bar = true;
      confirm-move-to-trash = true;
      terminal-app = "ghostty";
    };

    "org/cinnamon/desktop/default-applications/terminal" = {
      exec = "ghostty";
      exec-arg = "--working-directory";
    };

    "org/gnome/desktop/default-applications/terminal" = {
      exec = "ghostty";
    };
  };

  home.file.".local/share/nemo/actions/ghostty.nemo_action".text = ''
    [Nemo Action]
    Active=true
    Name=Open in Ghostty
    Comment=Open Ghostty in the current directory
    Exec=ghostty --working-directory=%P
    Icon-Name=com.mitchellh.ghostty
    Selection=any
    Extensions=dir;none;
    Quote=double
  '';
}
