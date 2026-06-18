{ config, lib, pkgs, ... }:

{
  # Zellij: modern terminal multiplexer
  programs.zellij = {
    enable = true;
    settings = {
      theme = "tokyo-night";
      default_mode = "normal";
      mouse_mode = true;
      pane_frames = true;

      keybinds = {
        normal = {
          bind "Ctrl g" "GoToTab 1";
          bind "Ctrl h" "GoToTab 2";
        };
      };

      ui = {
        pane_margins = {
          horizontal = 1;
          vertical = 1;
        };
      };
    };
  };
}