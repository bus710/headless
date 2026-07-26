{ config, pkgs, ... }:
{
  home.username = "bus710";
  home.homeDirectory = "/home/bus710";
  home.stateVersion = "25.11"; # Please read the comment before changing.
  home.packages = [
  ];
  home.file = {
  };
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
      ll = "ls -l";
      ud = "sudo nixos-rebuild switch";
      uh = "home-manager switch";
      nv = "nvim";
      c = "clear";
      tm = "tmux";
      nvc = "cd ~/.config/nvim";
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "zsh-completions";
        src = pkgs.zsh-completions;
      }
      {
        name = "fzf-tab";
        src = pkgs.zsh-fzf-tab;
      }
      {
        name = "forgit";
        src = pkgs.zsh-forgit;
      }
    ];
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "dotenv" ];
    };
    initContent = ''
      ##################################
      # Theme (powerlevel10k)
      ##################################
      if [[ -f ~/.p10k.zsh ]]; then
        source ~/.p10k.zsh
      fi
    '';
  };

  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    prefix = "C-a";
    clock24 = true;
    keyMode = "vi";
    mouse = true;
    historyLimit = 50000;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      vim-tmux-navigator
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-powerline true
          set -g @dracula-plugins "git"
          set -g @dracula-show-weather false
          set -g @dracula-show-flags false
          set -g @dracula-show-left-icon session
        '';
      }
    ];
    extraConfig = ''
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      set -g mouse on
      set -g set-clipboard off
      set -sg escape-time 1
      set -g base-index 1
      setw -g pane-base-index 1
      set -g focus-events on
      setw -g mode-keys vi
      setw -g automatic-rename off
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      set -g status-position top
      set -g status-interval 5
      setw -g window-status-separator ""
    '';
  };
}
