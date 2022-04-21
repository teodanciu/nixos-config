{ pkgs, lib, ...}:

{

  imports = [
    (import ./haskell.nix)
  ];

  home.username = "teo";
  home.packages = with pkgs; [
    alsaUtils
    arandr
    cachix
    direnv
    dunst
    exa
    exfat
    fd
    feh
    flameshot
    fzf
    glxinfo
    gnupg
    htop
    inetutils
    ispell
    killall
    lsof
    mosh
    networkmanager
    networkmanagerapplet
    pavucontrol
    pinentry
    qalculate-gtk
    rofi
    silver-searcher
    sublime
    tmate
    tree
    udiskie
    unzip
    vimHugeX
    wget
    xclip
    zip

    clang
    git-cola
    gitg
    gnumake
    jq
    niv
    nixpkgs-fmt
    shellcheck

    firefox
    google-chrome
    logseq
    okular
    zoom-us
  ];

  home.sessionVariables = {
    EDITOR = "${pkgs.vim}/bin/vim";
    TERMINAL = "${pkgs.alacritty}/bin/alacritty";
  };
  home.keyboard.layout = "us";

  xsession = {
    enable = true;
    # Used in configuration.nix
    scriptPath = ".hm-xsession";

    pointerCursor = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = 28;
    };

    windowManager.i3 = {
      enable = true;

      # Copied from https://github.com/srid/nix-config/blob/705a70c094da53aa50cf560179b973529617eb31/nix/home/i3.nix
      config =
        let modifier = "Mod4";
        in
        {
          inherit modifier;
          menu =
            "${pkgs.rofi}/bin/rofi -only-match -show-icons -combi-modi window#drun -show combi -modi combi#window#run -font 'Fira Code 25'";

          terminal = "${pkgs.alacritty}/bin/alacritty";

          # Bars are directly handled by Polybar
          bars = [ ];

          keybindings = lib.mkOptionDefault
            {
              "XF86AudioMute" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
              "XF86AudioRaiseVolume" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
              "XF86AudioLowerVolume" =
                "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
              "XF86MonBrightnessUp" =
                "exec --no-startup-id ${pkgs.light}/bin/light -A 5";
              "XF86MonBrightnessDown" =
                "exec --no-startup-id ${pkgs.light}/bin/light -U 5";
              "Print" = "exec --no-startup-id ${pkgs.flameshot}/bin/flameshot gui";
              "${modifier}+Shift+p" =
                "exec --no-startup-id ${pkgs.dunst}/bin/dunstctl close";
              "${modifier}+Return" = "exec ${pkgs.alacritty}/bin/alacritty";
            };
        };
    };
  };

  xresources.properties = {
    "Xft.dpi" = 180;
  };

  programs = {
    home-manager.enable = true;
    alacritty.enable = true;
    bash = {
      enable = true;
      historyFileSize = 1000000;
      historyIgnore = ["ls" "cd"];
      bashrcExtra = ''
        function ghciwith () {
          nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [$*])" --run ghci
        }

        function ghci9with () {
          nix-shell -p "haskell.packages.ghc921.ghcWithPackages (pkgs: with pkgs; [$*])" --run ghci
        }
      '';
    };
    broot.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      package = pkgs.gitAndTools.gitFull;
      userEmail = "teodora.danciu@tweag.io";
      userName = "teodanciu";

      ignores = [
        ".direnv"
      ];
      lfs.enable = true;
      extraConfig = {
        rerere.enabled = true;
      };
    };
    gpg.enable = true;

    rofi = {
      enable = true;
      location = "center";
      theme = "Arc-Dark";
    };
    vscode = {
      enable = true;
      package = pkgs.vscode-fhs;
    };

  };

  services = {
    blueman-applet.enable = true;
    dunst.enable = true;
    flameshot.enable = true;

    gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    network-manager-applet.enable = true;

    polybar = {
      enable = true;
      config = ./polybar-config.ini;
      # See https://github.com/NixOS/nixpkgs/blob/nixos-20.09/pkgs/applications/misc/polybar/default.nix for available supports
      package = pkgs.polybar.override {
        alsaSupport = true;
        pulseSupport = true;
        i3GapsSupport = true;
        nlSupport = true;
      };
      # You can find logs using
      # systemctl --user status polybar.service
      script = ''
        polybar -l info top &
      '';
    };
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.arc-theme;
      name = "Arc-Dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
  };

}
