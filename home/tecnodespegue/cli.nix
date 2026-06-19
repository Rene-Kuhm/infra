{ config, lib, pkgs, ... }:

{
  # Home packages (CLI tools)
  # NOTE: keep this list disjoint from modules/base/default.nix to avoid collisions.
  # System packages (in environment.systemPackages) cover: git, jq, ripgrep, fd,
  # bat, mtr, unzip, p7zip, zstd, neovim, etc.
  home.packages = with pkgs; [
    # Modern CLI replacements
    fzf
    yq-go
    eza
    zoxide
    starship
    btop
    duf
    procs
    fdupes

    # Terminal
    alacritty
    kitty
    wezterm

    # Editor
    helix

    # Version control
    lazygit
    gh
    tig

    # Network
    bandwhich
    speedtest-cli
    dog
    httpie

    # Search/navigation
    broot

    # Build tools
    gnumake
    gcc
    pkg-config
    cmake
  ];

  # Zsh configuration (default shell is set via users.users.<name>.shell in modules/base/users.nix)
  programs.zsh = {
    enable = true;

    # Use prezto or p10k
    initContent = ''
      # Completion
      autoload -U compinit && compinit
      zstyle ':completion:*' menu select

      # History
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_SPACE
      setopt SHARE_HISTORY

      # Aliases
      alias ll='eza -la --git'
      alias ls='eza'
      alias cat='bat'
      alias grep='rg'
      alias find='fd'
      alias cd='z'

      # Git shortcuts
      alias g='git'
      alias gs='git status'
      alias gp='git push'
      alias gpl='git pull'
      alias gc='git commit'
      alias gd='git diff'

      # Nix
      alias nrs='sudo nixos-rebuild switch'
      alias nrt='sudo nixos-rebuild test'
      alias nb='nix build'
      alias ns='nix shell'
      alias nfu='nix flake update'
      alias nfc='nix flake check'

      # FZF
      eval "$(fzf --zsh)"
    '';

    # Plugins
    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "zsh-autosuggestions";
        src = pkgs.zsh-autosuggestions;
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.zsh-syntax-highlighting;
      }
    ];

    # History file
    history = {
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
    };

    # Environment
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      PAGER = "less -R";
      MANPAGER = "bat";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = "$all$character";
    };
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Rene-Kuhm";
    userEmail = "rene-kuhm@users.noreply.github.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      core.autocrlf = false;
      alias.st = "status";
      alias.co = "checkout";
      alias.br = "branch";
      alias.lg = "log --oneline --graph --decorate --all";
    };
  };

  # Direnv for per-project environments
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}