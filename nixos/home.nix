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
    autosuggestion.enable = false;
    syntaxHighlighting.enable = false;
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
    ];
    initContent = ''
	##################################
	# Zinit
	##################################

	if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
	  mkdir -p "$HOME/.local/share/zinit"
	  git clone https://github.com/zdharma-continuum/zinit.git \
	    "$HOME/.local/share/zinit/zinit.git"
	fi

	source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

	##################################
	# Plugins
	##################################

	zinit light zsh-users/zsh-autosuggestions
	zinit light zsh-users/zsh-syntax-highlighting
	zinit light zsh-users/zsh-completions

	zinit light Aloxaf/fzf-tab
	zinit light wfxr/forgit

	zinit snippet OMZ::plugins/git/git.plugin.zsh
	zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh
	zinit snippet OMZ::plugins/dotenv/dotenv.plugin.zsh

	if command -v kubectl >/dev/null 2>&1; then
	  source <(kubectl completion zsh)
	fi

	##################################
	# Theme (pure)
	##################################

	# Source the powerlevel10k configuration file
	if [[ -f ~/.p10k.zsh ]]; then
	  source ~/.p10k.zsh
	fi

	export TERM=screen-256color
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
