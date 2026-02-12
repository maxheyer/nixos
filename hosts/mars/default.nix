{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/default.nix
    ];

  networking.hostName = "mars";

  boot.kernelPackages = pkgs.lib.mkForce pkgs.linuxPackages_zen;
  boot.tmp.useTmpfs = true;
  services.fstrim.enable = true;

  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.keyboard.qmk.enable = true;

  powerManagement.cpuFreqGovernor = "performance";

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Experimental = true;
        FastConnectable = true;
      };
      Policy = {
        AutoEnable = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  hardware.nvidia = {
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
  };

  programs.steam.enable = true;

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
  };

  environment.systemPackages = with pkgs; [
    discord-ptb
    (pkgs.ollama.override { 
      acceleration = "cuda";
    })
  ];
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  services.udev.extraRules = ''
    ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/scheduler}="none"
  '';

  services.snapper = {
    snapshotInterval = "hourly";
    cleanupInterval = "1d";

    configs.home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = [ "max" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_MIN_AGE = 1800;
      TIMELINE_LIMIT_HOURLY = 24;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 4;
      TIMELINE_LIMIT_MONTHLY = 3;
      TIMELINE_LIMIT_YEARLY = 0;
    };
  };

  services.restic.backups.maxHome = {
    user = "max";
    initialize = true;

    repository = "s3:https://s3-eu-west-1.wunder.run/mars-backup";
    environmentFile = "/home/max/.config/restic/env";
    passwordFile    = "/home/max/.config/restic/password";

    paths = [
      "/home/max"
    ];

    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      RandomizedDelaySec = "30m";
    };

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    extraBackupArgs = [
      "--exclude-caches"
      "--exclude=**/.cache"
      "--exclude=**/.local/share/Trash"
      "--exclude=**/.local/share/Steam"
      "--exclude=**/.local/share/containers/"
      "--exclude=**/.local/share/bottles/bottles/"
      "--exclude=**/Faugus"
      "--exclude=**/.npm"
      "--exclude=**/.cargo"
      "--exclude=**/.direnv"
      "--exclude=**/.venv"
      "--exclude=**/node_modules"
      "--exclude=**/vendor"
      "--exclude=**/target"
      "--tag=home"
    ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
