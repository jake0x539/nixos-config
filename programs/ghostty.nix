{...}: {
  programs.ghostty = {
    enable = true;
    settings = {
      font-family = "MesloLGL Nerd Font Mono";
      font-size = 14;
      theme = "Catppuccin Frappe";
      window-width = 128;
      window-height = 36;
      background-opacity = 0.9;
    };
  };
}
