{
  config,
  pkgs,
  ...
}: {
  networking.hostName = "kanade"; #

  fileSystems."/".options = ["noatime" "discard"];
  boot.tmp.useTmpfs = true;
  services.journald.extraConfig = "SystemMaxUse=100M";

  nix = {
    settings.auto-optimise-store = true;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  zramSwap.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libvdpau-va-gl
    ];
  };

  services.navidrome = {
    enable = true;
    settings = {
      Address = "0.0.0.0";
      Port = 4533;
      MusicFolder = "/srv/media/music";
    };
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = ["render" "video"];

  users.users.admin = {
    isNormalUser = true;
    description = "Server Administrator";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhqkjdzopZ+U4Y3vDGwWRbhx1k32uc9fZO/Ygk9TUWJ ayumu-nixos"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false; # Strongly recommended to use SSH keys
    };

    extraConfig = ''
      Match Group sftponly
        ChrootDirectory /srv/media
        ForceCommand internal-sftp
        AllowTcpForwarding no
        X11Forwarding no
        PermitTunnel no
        AllowAgentForwarding no
    '';
  };

  services.tailscale.enable = true;
  networking.firewall.allowedUDPPorts = [config.services.tailscale.port];

  users.groups.sftponly = {};
  users.users.sftpuser = {
    isNormalUser = true;
    group = "sftponly";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhqkjdzopZ+U4Y3vDGwWRbhx1k32uc9fZO/Ygk9TUWJ ayumu-nixos"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/media 0755 root root"
    "d /srv/media/music 0775 sftpuser sftponly"
    "d /srv/media/movies 0775 sftpuser sftponly"
  ];

  system.stateVersion = "26.05";
}
