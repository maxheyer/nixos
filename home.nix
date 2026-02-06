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
        ./home/swayidle.nix
        ./home/lsp.nix
      ];

    home.username = "max";
    home.homeDirectory = "/home/max";

    home.stateVersion = "24.11";

    home.file = {
      ".gitconfig".source = ./configs/.gitconfig;
      ".gitconfig-enum".source = ./configs/.gitconfig-enum;
    };

    xdg.configFile = {
      "niri/config.kdl".source = ./configs/niri/config.kdl;
      "fuzzel".source = ./configs/fuzzel;
      "ghostty".source = ./configs/ghostty;
      "nvim".source = ./configs/nvim;
      "waybar".source = ./configs/waybar;
    };

    xdg.dataFile."applications/org.freecad.FreeCAD.desktop".text = ''
      [Desktop Entry]
      Hidden=true
    '';

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "text/html" = "firefox.desktop";
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "x-scheme-handler/about" = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      };
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
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };

      gtk3.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
        gtk-icon-theme-name = "Adwaita";
      };
      gtk4.extraConfig = {
        gtk-application-prefer-dark-theme = 1;
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
      GTK_THEME = "Adwaita-dark";
      NIXOS_OZONE_WL = "1";
      BROWSER = "firefox";
      GDK_PIXBUF_MODULE_FILE = "${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache";
    };

    home.sessionPath = [ "$HOME/.krew/bin" "$HOME/.local/bin" ];

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
      zenity
      imagemagick
      wtype

      nodejs
      bun
      tree-sitter
      gcc
      gnumake
      xwayland-satellite
      appimage-run

      adwaita-icon-theme
      papirus-icon-theme
      hicolor-icon-theme
      gsettings-desktop-schemas
      gtk3
      librsvg
      font-awesome
      nerd-fonts.blex-mono
      dconf
      freerdp

      # cli
      go
      cargo
      pkg-config
      rustc
      pulumi
      pulumiPackages.pulumi-go
      btop
      ripgrep
      fzf
      vim
      lazygit
      fd
      unzip
      kubectl
      kubelogin-oidc
      krew
      argocd
      bluetui
      fastfetch
      claude-code
      yubikey-manager
      yubioath-flutter
      kubernetes-helm
      jq
      yq-go
      colmena
      inetutils
      dig
      talosctl
      jwt-cli
      podman-compose
      s5cmd
      kubecm
      net-tools
      restic
      cilium-cli
      glow
      zola
      ethtool
      envsubst

      # apps
      nautilus
      ghostty
      pavucontrol
      slack
      freelens-bin
      logseq
      networkmanagerapplet
      kdePackages.kdeconnect-kde
      onlyoffice-desktopeditors
      faugus-launcher
      wayvnc
      rpi-imager
      qpwgraph
      spotify
      spotify-player
      orca-slicer
      freecad
      openscad-unstable
      blender
      winboat
    ];

    fonts.fontconfig.enable = true;

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        gtk-theme = "Adwaita-dark";
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

    xdg.desktopEntries.sunsama = {
      name = "Sunsama";
      genericName = "Sunsama";
      exec = "${pkgs.appimage-run}/bin/appimage-run ./Applications/sunsama.AppImage";
      terminal = false;
      categories = [ "Utility" ];
    };

    xdg.desktopEntries.handy = {
      name = "Handy";
      genericName = "Handy";
      exec = "env LD_PRELOAD=/lib64/libwayland-client.so.0 ${pkgs.appimage-run}/bin/appimage-run /home/max/Applications/Handy.AppImage";
      icon = "${./icons/handy.png}";
      terminal = false;
      categories = [ "Utility" ];
    };

    xdg.desktopEntries.freecad = {
      name = "FreeCAD";
      genericName = "CAD Application";
      comment = "Feature based Parametric Modeler";
      exec = "env QT_QPA_PLATFORM=xcb ${pkgs.freecad}/bin/freecad %F";
      icon = "org.freecad.FreeCAD";
      terminal = false;
      categories = [ "Graphics" "Science" "Engineering" ];
      mimeType = [ "application/x-extension-fcstd" ];
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

    services.gnome-keyring = {
      enable = true;
      components = [ "secrets" "ssh" ];
    };
}
