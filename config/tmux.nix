{ pkgs, ... }:
let
  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "main";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "master";
      sha256 = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
  };
in
{
  enable = true;
  aggressiveResize = true; # temp
  baseIndex = 1;
  disableConfirmationPrompt = true;
  keyMode = "vi";
  secureSocket = true; # temp
  shell = "${pkgs.zsh}/bin/zsh";
  prefix = "C-s";
  plugins = with pkgs.tmuxPlugins; [
    resurrect
    tokyo-night
    yank
    sensible
    vim-tmux-navigator
    continuum
  ];

  extraConfig = ''
    # Keybinds
    unbind r
    bind r source-file ~/.config/tmux/tmux.conf
    bind '"' split-window -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"
    bind c new-window -c "#{pane_current_path}"
    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
    bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    bind-key -n M-j previous-window
    bind-key -n M-k next-window
    bind-key -n M-h previous-window
    bind-key -n M-l next-window
    bind-key -n 'C-h' 'select-pane -L'
    bind-key -n 'C-j' 'select-pane -D'
    bind-key -n 'C-k' 'select-pane -U'
    bind-key -n 'C-l' 'select-pane -R'
    bind-key -n C-l send-keys 'C-l'

    # Theme Settings
    set -g @tokyo-night-tmux_window_id_style hsquare
    set -g @tokyo-night-tmux_show_datetime 1
    set -g @tokyo-night-tmux_date_format DMY
    set -g @tokyo-night-tmux_time_format 24H
    set -g @tokyo-night-tmux_show_battery_widget 1
    set -g @tokyo-night-tmux_battery_name "BAT0"
    set -g @tokyo-night-tmux_battery_low_threshold 25
    set -g @tokyo-night-tmux_show_path 0
    set -g @tokyo-night-tmux_show_git 1

    run-shell ${tokyo-night}/share/tmux-plugins/tokyo-night/tokyo-night.tmux

    # Settings
    set-option -g @resurrect-strategy-nvim 'session'
    set-option -sa terminal-overrides ',xterm*:Tc'
    set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
    set -as terminal-overrides ',*:Setulc=\E[58::2::::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    set -g default-terminal "tmux"
    set -g @resurrect-capture-pane-contents 'on'
    set -g @continuum-restore 'on'
    set-option -g status-position top

    # Old Catppuccin Settings
    # set-option -g @catppuccin_flavour 'macchiato'
    # set -g @catppuccin_window_left_separator ""
    # set -g @catppuccin_window_right_separator " "
    # set -g @catppuccin_window_middle_separator " █"
    # set -g @catppuccin_window_number_position "right"
    # set -g @catppuccin_window_default_fill "number"
    # set -g @catppuccin_window_default_text "#W"
    # set -g @catppuccin_window_current_fill "number"
    # set -g @catppuccin_window_current_text "#W"
    # set -g @catppuccin_status_modules_right "host session date_time"
    # set -g @catppuccin_status_left_separator  " "
    # set -g @catppuccin_status_right_separator ""
    # set -g @catppuccin_status_fill "icon"
    # set -g @catppuccin_status_connect_separator "no"
    # set -g @catppuccin_directory_text "#{pane_current_path}"
  '';
}
