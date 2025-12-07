{ pkgs, ... }:

{
  services.swaync = {
    enable = true;

    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "user";
      control-center-margin-top = 10;
      control-center-margin-bottom = 10;
      control-center-margin-right = 10;
      control-center-margin-left = 10;
      notification-2fa-action = true;
      notification-inline-replies = true;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;

      widgets = [
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];

      widget-config = {
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };

    style = ''
    * {
      all: unset;
      font-size: 13px;
      font-family: "BlexMono Nerd Font";
      transition: 200ms;
    }

    trough highlight {
      background: #000000;
    }

    scale {
      margin: 0 7px;
    }

    scale trough {
      margin: 0rem 1rem;
      min-height: 8px;
      min-width: 70px;
      border-radius: 12px;
    }

    trough slider {
      margin: -10px;
      border-radius: 12px;
      box-shadow: 0 0 2px rgba(0, 0, 0, 0.15);
      transition: all 0.2s ease;
      background-color: #000000;
    }

    trough slider:hover {
      box-shadow: 0 0 4px rgba(0, 0, 0, 0.3);
    }

    trough {
      background-color: #cccccc;
    }

    /* notifications */
    .notification-background {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      border-radius: 12px;
      margin: 18px;
      background: #e6e6e6;
      color: #000000;
      padding: 0;
      border: 1px solid #666666;
    }

    .notification-background .notification {
      padding: 7px;
      border-radius: 12px;
    }

    .notification-background .notification.critical {
      box-shadow: inset 0 0 7px 0 #666666;
    }

    .notification .notification-content {
      margin: 7px;
    }

    .notification .notification-content overlay {
      /* icons */
      margin: 4px;
    }

    .notification-content .summary {
      color: #000000;
      font-weight: 600;
    }

    .notification-content .time {
      color: #666666;
    }

    .notification-content .body {
      color: #333333;
    }

    .notification > *:last-child > * {
      min-height: 3.4em;
    }

    .notification-background .close-button {
      margin: 7px;
      padding: 4px;
      border-radius: 50%;
      color: #ffffff;
      background-color: #666666;
      min-width: 24px;
      min-height: 24px;
    }

    .notification-background .close-button:hover {
      background-color: #000000;
    }

    .notification-background .close-button:active {
      background-color: #333333;
    }

    .notification .notification-action {
      border-radius: 30px;
      color: #000000;
      border: 1px solid #666666;
      margin: 4px;
      padding: 8px 16px;
      font-size: 0.2rem; /* controls the button size not text size*/
    }

    .notification .notification-action {
      background-color: #cccccc;
    }

    .notification .notification-action:hover {
      background-color: #ffffff;
      border-color: #000000;
    }

    .notification .notification-action:active {
      background-color: #999999;
    }

    .notification.critical progress {
      background-color: #666666;
    }

    .notification.low progress,
    .notification.normal progress {
      background-color: #000000;
    }

    .notification progress,
    .notification trough,
    .notification progressbar {
      border-radius: 12.6px;
      padding: 3px 0;
    }

    /* control center */
    .control-center {
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
      border-radius: 12px;
      background-color: #e6e6e6;
      color: #000000;
      padding: 14px;
      border: 1px solid #666666;
    }

    .control-center .notification-background {
      border-radius: 8px;
      border: 1px solid #cccccc;
      margin: 4px 10px;
    }

    .control-center .notification-background .notification {
      border-radius: 8px;
    }

    .control-center .notification-background .notification.low {
      opacity: 0.8;
    }

    .control-center .widget-title > label {
      color: #000000;
      font-size: 1.3em;
      font-weight: 600;
    }

    .control-center .widget-title button {
      border-radius: 30px;
      color: #000000;
      background-color: #cccccc;
      border: 1px solid #666666;
      padding: 8px 20px;
      margin-left: 8px;
      transition: all 0.2s ease;
    }

    .control-center .widget-title button:hover {
      background-color: #ffffff;
      border-color: #000000;
      box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
    }

    .control-center .widget-title button:active {
      background-color: #999999;
      transform: scale(0.98);
    }

    .control-center .widget-title {
      margin-bottom: 8px;
      padding-bottom: 8px;
    }

    .control-center .notification-group {
      margin-top: 10px;
      padding: 4px 0;
    }

    .control-center .notification-group:focus .notification-background {
      background-color: #ffffff;
    }

    scrollbar slider {
      margin: -3px;
      opacity: 0.8;
    }

    scrollbar trough {
      margin: 2px 0;
    }

    /* dnd */
    .widget-dnd {
      margin: 12px 0;
      padding: 12px 20px;
      border-radius: 30px;
      font-size: 1.3rem;
      color: #000000;
      background: #cccccc;
      border: 1px solid #666666;
    }

    .widget-dnd > switch {
      font-size: initial;
      border-radius: 30px;
      background: #999999;
      box-shadow: none;
      min-width: 64px;
      min-height: 32px;
    }

    .widget-dnd > switch:checked {
      background: #333333;
    }

    .widget-dnd > switch slider {
      background: #ffffff;
      border-radius: 50%;
      min-width: 28px;
      min-height: 28px;
    }

    /* mpris */
    .widget-mpris-player {
      background: #cccccc;
      border-radius: 12px;
      color: #000000;
      border: 1px solid #666666;
      margin: 8px 0;
    }

    .mpris-overlay {
      background-color: #cccccc;
      opacity: 0.9;
      padding: 15px 10px;
    }

    .widget-mpris-album-art {
      -gtk-icon-size: 100px;
      border-radius: 12px;
      margin: 0 10px;
    }

    .widget-mpris-title {
      font-size: 1.2rem;
      color: #000000;
      font-weight: 600;
    }

    .widget-mpris-subtitle {
      font-size: 1rem;
      color: #333333;
    }

    .widget-mpris button {
      border-radius: 30px;
      color: #000000;
      margin: 0 5px;
      padding: 6px 12px;
    }

    .widget-mpris button image {
      -gtk-icon-size: 1.8rem;
    }

    .widget-mpris button:hover {
      background-color: #ffffff;
    }

    .widget-mpris button:active {
      background-color: #999999;
    }

    .widget-mpris button:disabled {
      opacity: 0.5;
    }

    .widget-menubar > box > .menu-button-bar > button > label {
      font-size: 3rem;
      padding: 0.5rem 2rem;
    }

    .widget-menubar > box > .menu-button-bar > :last-child {
      color: #d20f39;
    }

    .power-buttons button:hover,
    .powermode-buttons button:hover,
    .screenshot-buttons button:hover {
      background: #ccd0da;
    }

    .control-center .widget-label > label {
      color: #4c4f69;
      font-size: 2rem;
    }

    .widget-buttons-grid {
      padding-top: 1rem;
    }

    .widget-buttons-grid > flowbox > flowboxchild > button label {
      font-size: 2.5rem;
    }

    .widget-volume {
      padding: 1rem 0;
    }

    .widget-volume label {
      color: #209fb5;
      padding: 0 1rem;
    }

    .widget-volume trough highlight {
      background: #209fb5;
    }

    .widget-backlight trough highlight {
      background: #df8e1d;
    }

    .widget-backlight label {
      font-size: 1.5rem;
      color: #df8e1d;
    }

    .widget-backlight .KB {
      padding-bottom: 1rem;
    }

    .image {
      padding-right: 0.5rem;
    }
    '';
  };
}
