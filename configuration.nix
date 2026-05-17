# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  nixpkgs-unstable,
  inputs,
  lib,
  osConfig,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use Lix as package manager
  nix.package = pkgs.lixPackageSets.lix_2_95.lix;

  nixpkgs.overlays = [
    (final: prev: {
      mutter = prev.mutter.overrideAttrs (old: {
        patches =
          (old.patches or [])
          ++ [
            ./mutter-scroll-speed.patch
          ];
      });
      inherit
        (prev.lixPackageSets.lix_2_95)
        nixpkgs-review
        nix-eval-jobs
        nix-fast-build
        colmena
        ;
    })
  ];


  nix.settings.experimental-features = ["nix-command" "flakes"];

  nix.settings = {
    extra-substituters = [
      "https://jake0x539.cachix.org"
      "https://nix-community.cachix.org"
      "https://cache.garnix.io"
      "https://attic.xuyh0120.win/lantian"
      "https://noctalia.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "jake0x539.cachix.org-1:WqPqua70tU6xqb+e91lc35VeTkF2ANdC9ZaPtmqCM9o="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];
    trusted-users = ["root" "@wheel" "jake"];
  };

  nixpkgs.config.cudaSupport = true;
  boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-x86_64-v3;
  boot.kernelModules = [ "ntsync" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.loader.limine = {
    enable = true;
    secureBoot.enable = true;
    maxGenerations = 5;

    extraEntries = ''
      /Windows 11
      protocol: efi
      path: guid(d828aae7-429c-4781-8616-bc7937fb7411):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Helsinki";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.xwayland.enable = true;

  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Japanese support
  fonts.packages = with pkgs; [
    noto-fonts
    ubuntu-classic
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
  ];

  fonts.fontconfig.defaultFonts = {
    serif = ["Noto Serif CJK JP" "Noto Serif"];
    sansSerif = ["Noto Sans CJK JP" "Noto Sans"];
    monospace = ["Noto Sans Mono CJK JP" "Noto Sans Mono"];
  };

  environment.sessionVariables = {
    QT_IM_MODULE = lib.mkForce null;
    GTK_IM_MODULE = lib.mkForce null;
  };

  i18n.inputMethod = lib.mkForce {
    enable = true;
    type = "ibus";
    ibus.engines = with pkgs.ibus-engines; [
      mozc-ut
    ];
  };

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

  programs.nix-ld.enable = true;

  services.xserver.enable = true;

  # Flatpaks
  services.flatpak.enable = true;

  # Finnish support
  services.xserver.xkb = lib.mkForce {
    layout = "us_fi";
    extraLayouts.us_fi = {
      description = "English (US) IntFi by Jake";
      languages = ["eng" "fin"];
      symbolsFile = pkgs.writeText "us" ''
        xkb_symbols "intfi" {
            include "us(basic)"
            name[Group1]= "English (US, Finnish)";

            key <AD01> {[ q, Q, adiaeresis, Adiaeresis ]};
            key <AD02> {[ w, W, aring, Aring ]};
            key <AD10> {[ p, P, odiaeresis, Odiaeresis ]};

            include "eurosign(e)"
            include "level3(ralt_switch)"
        };
      '';
    };
  };

  # fstrim, swap
  services.fstrim.enable = true;
  fileSystems."/".options = ["noatime"];

  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 100;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
      priority = 0;
    }
  ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 30;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = ["*"];
        settings = {
          main = {
            escape = "grave";
            grave = "escape";
          };
        };
      };
    };
  };

  environment.variables = {
    LV2_PATH = "/run/current-system/sw/lib/lv2";
    VST3_PATH = "/run/current-system/sw/lib/vst3";
  };

  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "memlock";
      type = "-"; # "-" means both soft and hard limits
      value = "unlimited";
    }
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "99";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "soft";
      value = "524288";
    }
    {
      domain = "@audio";
      item = "nofile";
      type = "hard";
      value = "1048576";
    }
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  programs.fish.enable = true;
  users.users.jake = {
    isNormalUser = true;
    description = "Jake";
    extraGroups = ["networkmanager" "wheel" "audio"];
    shell = pkgs.fish;
  };

  home-manager.users.jake = import ./home.nix;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    hicolor-icon-theme
    brave
    neovim
    discord
    ghostty
    zed-editor-fhs
    nixd
    alejandra
    git
    sbctl
    github-cli
    btop
    xwayland-satellite
    dejavu_fonts
    imwheel
    distrobox
    distrobox-tui
  ];

  services.xserver.videoDrivers = ["nvidia"];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  nix.settings.auto-optimise-store = true;

  fileSystems."/mnt/arch-data" = {
    device = "/dev/disk/by-uuid/0c4d398b-2d60-4323-a375-609115019ac1";
    fsType = "ext4";
    options = ["defaults" "nofail" "user" "rw"];
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  system.stateVersion = "25.11";
}
