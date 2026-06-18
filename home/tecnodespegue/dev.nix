{ config, lib, pkgs, ... }:

{
  # Developer tools
  home.packages = with pkgs; [
    # Languages
    nodejs_22
    python312
    go
    rustup
    lua
    ruby

    # Containers
    docker
    docker-compose
    lazydocker

    # K8s (when RAM allows)
    kubectl
    k9s
    helm
    kubectx
    stern
  ];

  # Neovim with LazyVim
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    # LazyVim setup
    plugins = [
      # LazyVim itself
      {
        type = "lua";
        name = "lazyvim";
        src = pkgs.fetchFromGitHub {
          owner = "LazyVim";
          repo = "lazyvim";
          rev = "stable";
          sha256 = "0000000000000000000000000000000000000000000000=";
        };
      }
    ];

    extraLuaConfig = ''
      -- LazyVim will be configured via ~/.config/nvim/lazyvim.json
      require("lazy").setup({
        spec = {
          { "LazyVim/LazyVim", import = "lazyvim.plugins" },
          { import = "lazyvim.plugins.examples.coding" },
        },
        defaults = { lazy = false, version = "*" },
      })
    '';
  };

  # Tmux
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    baseIndex = 1;
    extraConfig = ''
      # Prefix
      set -g prefix C-a
      unbind C-b
      bind C-a send-prefix

      # Mouse
      set -g mouse on

      # Vim bindings
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # True color
      set -g default-terminal "screen-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"

      # Reload config
      bind r source-file ~/.tmux.conf
    '';
  };

  # Alacritty terminal
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        dimensions = {
          columns = 100;
          lines = 30;
        };
        padding = {
          x = 8;
          y = 8;
        };
      };
      font = {
        normal = {
          family = "JetBrains Mono";
          style = "Regular";
        };
        size = 11.0;
      };
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
        # Tokyo Night theme
        normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#9ece6a";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#7dcfff";
          white = "#a9b1d6";
        };
      };
    };
  };
}