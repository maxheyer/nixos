{ config, pkgs, ... }:

  let

  k8s-switch-script = pkgs.writeShellScript "k8s-switch" ''
    CTX=$(${pkgs.kubectl}/bin/kubectl config get-contexts -o name | ${pkgs.fuzzel}/bin/fuzzel -d -p "K8s > ")

    if [ -n "$CTX" ]; then
      if ${pkgs.kubectl}/bin/kubectl config use-context "$CTX"; then
        ${pkgs.libnotify}/bin/notify-send "Kubernetes" "Switched to: $CTX" -i kubernetes
      else
        ${pkgs.libnotify}/bin/notify-send -u critical "Kubernetes" "Failed to switch context!"
      fi
    fi
  '';

  in
  {
    imports =
      [
        ./home/fish.nix
        ./home/sway.nix
        ./home/lsp.nix
      ];

    home.username = "max";
    home.homeDirectory = "/home/max";

    home.stateVersion = "24.11"; 

    home.file = {
      ".gitconfig".source = ./configs/.gitconfig;
    };

    xdg.configFile = {
      "niri/config.kdl".source = ./configs/niri/config.kdl;
      "fuzzel".source = ./configs/fuzzel;
      "ghostty".source = ./configs/ghostty;
      "nvim".source = ./configs/nvim;
      "waybar".source = ./configs/waybar;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      cursorTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };

      theme = {
        name = "Adwaita";
        package = pkgs.gnome-themes-extra;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 0;
        gtk-icon-theme-name = "Adwaita";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 0;
        gtk-icon-theme-name = "Adwaita";
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita";
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    home.sessionVariables = {
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "24";
      EDITOR = "nvim";
      KUBE_EDITOR = "nvim";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      GTK_THEME = "Adwaita";
      NIXOS_OZONE_WL = "1";
    };

    programs.swaylock.enable = true;

    programs.yazi.enable = true;

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target ="graphical-session.target";
      };
      settings = {};
      style = "";
    };

    home.packages = with pkgs; [
      fuzzel
      swww
      wl-clipboard
      lm_sensors
      mpv
      ffmpeg
      libnotify
      glib
      libappindicator
      zenity

      nodejs
      tree-sitter
      gcc
      gnumake
      xwayland-satellite
      appimage-run

      adwaita-icon-theme
      papirus-icon-theme
      hicolor-icon-theme
      font-awesome
      nerd-fonts.blex-mono
      dconf

      # cli
      btop
      ripgrep
      fzf
      vim
      lazygit
      fd
      unzip
      kubectl
      bluetui
      fastfetch
      claude-code
      gemini-cli
      yubikey-manager
      kubernetes-helm
      jq
      colmena
      inetutils

      # apps
      ghostty
      pavucontrol
      slack
      freelens-bin
      logseq
      networkmanagerapplet
      onlyoffice-desktopeditors
      faugus-launcher
    ];

    fonts.fontconfig.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-light";
        gtk-theme = "Adwaita";
      };
    };

    programs.home-manager.enable = true;

    programs.obs-studio.enable = true;

    programs.thunderbird = {
      enable = true;

      profiles."default" = {
        isDefault = true;
        settings = {
          "mail.spam.manualMark" = true;
        };
        accountsOrder = [
          "gmail"
        ];
      };
    };

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

    systemd.user.services.xwayland-satellite = {
      Unit = {
        Description = "XWayland Satellite (X11 Support for Niri)";
        BindsTo = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite :1";
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.swww = {
      Unit = {
        Description = "Wayland Wallpaper Daemon";
        # Startet erst, wenn die grafische Oberfläche (Niri) bereit ist
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        # Der eigentliche Daemon Befehl
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        # Startet den Dienst neu, falls er abstürzt
        Restart = "on-failure";
      };

      Install = {
        # Bindet den Dienst an den Start der Grafik-Session
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.desktopEntries.k8sCtx = {
      name = "k8s Context";
      genericName = "Kubernetes Switcher";
      comment = "Switch kubectl context using fuzzel";
      exec = "${k8s-switch-script}";
      icon = "${./icons/kubernetes.png}";
      terminal = false;
      categories = [ "Utility" "Development" ];
    };

    xdg.desktopEntries.cider = {
      name = "Cider";
      genericName = "Music";
      exec = "${pkgs.appimage-run}/bin/appimage-run ./Applications/cider.AppImage";
      terminal = false;
      categories = [ "Music" ];
    };

    systemd.user.services.nm-applet = {
      Unit = {
        Description = "Network Manager Applet";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  }
