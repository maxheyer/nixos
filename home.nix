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
      ];

    home.username = "max";
    home.homeDirectory = "/home/max";

    home.stateVersion = "24.11"; 

    home.sessionVariables = {
      EDITOR = "nvim";
      KUBE_EDITOR = "nvim";
    };

    home.file = {
      ".config/niri/config.kdl".source = ./configs/niri/config.kdl;
      ".gitconfig".source = ./configs/.gitconfig;
      ".config/fuzzel".source = ./configs/fuzzel;
      ".config/ghostty".source = ./configs/ghostty;
      ".config/nvim".source = ./configs/nvim;
      ".config/waybar".source = ./configs/waybar;
    };

    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark"; 
        package = pkgs.papirus-icon-theme;
      };

      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };

    qt = {
      enable = true;
      platformTheme.name = "gtk";
      style.name = "adwaita-dark";
    };

    home.pointerCursor = {
      gtk.enable = true;
      x11.enable = true;

      name = "material-cursors";
      package = pkgs.material-cursors;
      size = 24;
    };

    home.sessionVariables = {
      XCURSOR_THEME = "material-cursors";
      XCURSOR_SIZE = "24";
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target ="graphical-session.target";
      };
    };

    home.packages = with pkgs; [
      fuzzel
      swww
      wl-clipboard
      lm_sensors
      mpv
      ffmpeg
      v4l-utils
      libnotify
      glib

      nodejs
      tree-sitter
      gcc
      gnumake
      xwayland-satellite
      appimage-run

      adwaita-icon-theme
      hicolor-icon-theme
      font-awesome

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

      # apps
      ghostty
      pavucontrol
      slack
      freelens-bin
      logseq
      networkmanagerapplet
    ];

    fonts.fontconfig.enable = true;

    programs.home-manager.enable = true;

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
        ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
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

    xdg.desktopEntries.gamescope = {
      name = "Gamescope";
      genericName = "Gaming Platform";
      comment = "Application for managing and playing games on Steam";

      exec = "gamescope -e -- steam %U";

      icon = "steam";
      terminal = false;
      categories = [ "Network" "FileTransfer" "Game" ];
      mimeType = [ "x-scheme-handler/steam" "x-scheme-handler/steamlink" ];
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
