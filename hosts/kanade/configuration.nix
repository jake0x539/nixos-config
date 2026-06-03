{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./auto-replaygain.nix
  ];

  networking.hostName = "kanade";
  networking.networkmanager.enable = true;
  services.logind.lidSwitch = "ignore";

  fileSystems."/".options = ["noatime" "discard"];
  boot.tmp.useTmpfs = true;
  services.journald.extraConfig = "SystemMaxUse=100M";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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
    openFirewall = false;
  };

  users.users.jellyfin.extraGroups = ["render" "video"];

  nix.settings.trusted-users = ["root" "@wheel"];
  nix.settings.experimental-features = ["nix-command" "flakes"];

  environment.systemPackages = with pkgs; [
    vim
    ghostty
  ];

  users.users.admin = {
    isNormalUser = true;
    description = "Server Administrator";
    extraGroups = ["networkmanager" "wheel"];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILhqkjdzopZ+U4Y3vDGwWRbhx1k32uc9fZO/Ygk9TUWJ ayumu-nixos"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2j0mrtSdzhjsqLf11CXJLqnP66/x3iz6fOvNxWw3jN kageaki@Chadamasa"
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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO2j0mrtSdzhjsqLf11CXJLqnP66/x3iz6fOvNxWw3jN kageaki@Chadamasa"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/media 0755 root root"
    "d /srv/media/music 0775 sftpuser sftponly"
    "d /srv/media/movies 0775 sftpuser sftponly"
  ];

  system.stateVersion = "26.05";
}
