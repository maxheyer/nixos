{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../common/default.nix
    ];

  networking.hostName = "mars";


  nixpkgs.config.allowUnfree = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  services.scx = {
    enable = true;
    scheduler = "scx_rusty"; 
  };

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

services.hardware.openrgb.enable = true;

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
    modesetting.enable = true;
    nvidiaSettings = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
  };

  services.open-webui = {
    enable = true;
    environment = {
      OLLAMA_API_BASE_URL = "http://127.0.0.1:11434";
    };
  };

  environment.systemPackages = with pkgs; [
    discord-ptb
  ];
}
