{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    ulauncher
  ];

  systemd.user.services.ulauncher = {
    Unit = {
      Description = "Ulauncher Application Launcher";
      Documentation = "https://ulauncher.io/";
      # ensure it starts after the graphical session is ready
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.ulauncher}/bin/ulauncher --hide-window";
      Restart = "always";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
