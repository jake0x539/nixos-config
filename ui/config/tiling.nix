{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    gnomeExtensions.tiling-shell
  ];

  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = lib.mkAfter [
        "tilingshell@ferrarodomenico.com"
      ];
    };

    "org/gnome/shell/extensions/tiling-shell" = {
      inner-gaps = lib.hm.gvariant.mkUint32 0;
      outer-gaps = lib.hm.gvariant.mkUint32 0;
      quarter-tiling-threshold = lib.hm.gvariant.mkUint32 20;
      top-edge-maximize = true;
      window-use-custom-border-color = false;

      # The UUID-based list of active layouts
      selected-layouts = [["10545843" "10545843"] ["10545843" "10545843"]];

      # Custom layout
      layouts-json = builtins.toJSON [
        {
          id = "Layout 1";
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.22;
              height = 0.5;
              groups = [1 2];
            }
            {
              x = 0;
              y = 0.5;
              width = 0.22;
              height = 0.5;
              groups = [1 2];
            }
            {
              x = 0.22;
              y = 0;
              width = 0.56;
              height = 1;
              groups = [2 3];
            }
            {
              x = 0.78;
              y = 0;
              width = 0.22;
              height = 0.5;
              groups = [3 4];
            }
            {
              x = 0.78;
              y = 0.5;
              width = 0.22;
              height = 0.5;
              groups = [3 4];
            }
          ];
        }
        {
          id = "Layout 2";
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.22;
              height = 1;
              groups = [1];
            }
            {
              x = 0.22;
              y = 0;
              width = 0.56;
              height = 1;
              groups = [1 2];
            }
            {
              x = 0.78;
              y = 0;
              width = 0.22;
              height = 1;
              groups = [2];
            }
          ];
        }
        {
          id = "Layout 3";
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.33;
              height = 1;
              groups = [1];
            }
            {
              x = 0.33;
              y = 0;
              width = 0.67;
              height = 1;
              groups = [1];
            }
          ];
        }
        {
          id = "Layout 4";
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.67;
              height = 1;
              groups = [1];
            }
            {
              x = 0.67;
              y = 0;
              width = 0.33;
              height = 1;
              groups = [1];
            }
          ];
        }
        {
          id = "10545843"; # Default windows-style tiling
          tiles = [
            {
              x = 0;
              y = 0;
              width = 0.5;
              height = 1;
              groups = [1];
            }
            {
              x = 0.5;
              y = 0;
              width = 0.5;
              height = 1;
              groups = [1];
            }
          ];
        }
      ];
    };
  };
}
