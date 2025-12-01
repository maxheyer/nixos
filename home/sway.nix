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
          button-text = "Delete all";
        };
        dnd = {
          text = "Nicht stören";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };

    style = ''
      .control-center {
        background: #1e1e2e; /* Catppuccin Base */
        border: 2px solid #cba6f7; /* Mauve Border */
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0,0,0,0.5);
      }

      .notification {
        border-radius: 12px;
        margin: 6px 12px;
        box-shadow: 0 2px 4px rgba(0,0,0,0.2);
      }

      .notification-content {
        background: #181825; /* Mantle */
        padding: 10px;
        border-radius: 12px;
        border: 1px solid #313244;
      }

      .widget-title {
        color: #cdd6f4;
        background: #1e1e2e;
        border-bottom: 1px solid #313244;
      }

      .widget-title > button {
        background: #313244;
        color: #cdd6f4;
        border: none;
        border-radius: 8px;
      }

      .widget-dnd {
        background: #1e1e2e;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
      }
      
      .widget-dnd > switch {
        border-radius: 12px;
        background: #313244;
      }
      
      .widget-dnd > switch:checked {
        background: #cba6f7;
      }

      .widget-mpris {
        background: #181825;
        padding: 8px;
        margin: 8px;
        border-radius: 12px;
        color: #cdd6f4;
      }
    '';
  };
}
