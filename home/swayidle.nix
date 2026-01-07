{ pkgs, ... }:

{
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
      }
      {
        timeout = 600;
        command = "niri msg action power-off-monitors";
      }
    ];
    events = {
      before-sleep = "${pkgs.swaylock}/bin/swaylock -f -c 000000";
    };
  };
}
