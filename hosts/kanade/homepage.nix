{
  config,
  pkgs,
  ...
}: {
  networking.firewall.allowedTCPPorts = [ 8082 ];

  services.homepage-dashboard = {
    enable = true;
    listenPort = 8082;

    allowedHosts = "kanade,localhost";

    services = [
      {
        media = [
          {
            "Jellyfin" = {
              icon = "jellyfin.png";
              href = "http://kanade:8096";
              description = "Movies";
            };
          }
          {
            "Navidrome" = {
              icon = "navidrome.png";
              href = "http://kanade:4533";
              description = "Music";
            };
          }
        ];
      }
    ];

    bookmarks = [
      {
        "Development" = [
          {
            "NixOS Search" = [
              { abbr = "NS"; href = "https://search.nixos.org/packages"; icon = "nixos.png"; }
            ];
          }
          {
            "Home Manager Option Search" = [
              { abbr = "HMS"; href = "https://home-manager-options.extranix.com/?query=&release=master"; icon = "nixos.png"; }
            ];
          }
        ];
      }
    ];
  };
}
