{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    rsgain
  ];

  # Target -14 LUFS
  environment.etc."rsgain/presets/loud.ini".text = ''
      [Global]
      TargetLoudness=-14
    '';

  systemd.services.auto-replaygain = {
    description = "Automatically calculate and apply ReplayGain tags to new music";
    script = ''
      # Run easy mode with custom loudness preset
      ${pkgs.rsgain}/bin/rsgain easy -p /etc/rsgain/presets/loud.ini /srv/media/music
    '';

    serviceConfig = {
      Type = "oneshot";
      # Run as sftpuser to guarantee it doesn't break ftp permissions
      User = "sftpuser";
    };
  };

  systemd.timers.auto-replaygain = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      # Run automatically every night at 3:00 AM
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
    };
  };
}
