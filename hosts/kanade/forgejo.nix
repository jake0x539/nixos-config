{
  config,
  pkgs,
  ...
}: {
  services.forgejo = {
    enable = true;
    database.type = "sqlite3";

    lfs.enable = true;
    settings = {
      server = {
        HTTP_ADDR = "0.0.0.0";
        HTTP_PORT = 3000;
        ROOT_URL = "http://kanade:3000/";
      };

      cron = {ENABLED = true;};
      repository = {ENABLE_TIMETRACKING = false;};

      service = {
        # Manually confirm new registrations
        DISABLE_REGISTRATION = false;
        REGISTER_MANUAL_CONFIRM = true;
        ALLOW_ONLY_EXTERNAL_REGISTRATION = false;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [3000];
}
