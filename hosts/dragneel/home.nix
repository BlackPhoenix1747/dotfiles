{
  pkgs,
  username,
  host,
  inputs,
  ...
}:
let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  # Home Manager Settings
  home.username = "${username}";
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";

  # Import Program Configurations
  imports = [
    ../../config/emoji.nix
    ../../config/hyprland.nix
    ../../config/neovim.nix
    ../../config/rofi/rofi.nix
    ../../config/rofi/config-emoji.nix
    ../../config/rofi/config-long.nix
    ../../config/swaync.nix
    ../../config/waybar.nix
    ../../config/wlogout.nix
    ../../config/starship/starship.nix
    ../../config/nushell.nix
    inputs.jerry.homeManagerModules.default
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nyaa.homeManagerModule
  ];

  # Place Files Inside Home Directory
  home.file."Pictures/Wallpapers" = {
    source = ../../config/wallpapers;
    recursive = true;
  };
  home.file.".config/fastfetch" = {
    source = ../../config/fastfetch;
    recursive = true;
  };
  home.file.".config/awesome" = {
    source = ../../config/awesome;
    recursive = true;
  };
  home.file.".config/ghostty" = {
    source = ../../config/ghostty;
    recursive = true;
  };
  home.file.".config/i3" = {
    source = ../../config/i3;
    recursive = true;
  };
  home.file.".config/jerry" = {
    source = ../../config/jerry;
    recursive = true;
  };
  home.file.".config/anup" = {
    source = ../../config/anup;
    recursive = true;
  };
  home.file.".config/emacs" = {
    source = ../../config/emacs;
    recursive = true;
  };
  home.file.".config/wlogout/icons" = {
    source = ../../config/wlogout;
    recursive = true;
  };
  home.file.".face.icon".source = ../../config/face.jpg;
  home.file.".config/face.jpg".source = ../../config/face.jpg;
  home.file.".config/swappy/config".text = ''
    [Default]
    save_dir=/home/${username}/Pictures/Screenshots
    save_filename_format=swappy-%Y%m%d-%H%M%S.png
    show_panel=false
    line_size=5
    text_size=20
    text_font=Ubuntu
    paint_mode=brush
    early_exit=true
    fill_shape=false
  '';
  # Install & Configure Git
  programs.git = {
    enable = true;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      color = {
        ui = "auto";
      };
      pull = {
        rebase = false;
      };
    };
  };
  i18n.inputMethod.enabled = "fcitx5";
  i18n.inputMethod.fcitx5.addons = with pkgs; [
    fcitx5-configtool
    fcitx5-mozc
  ];
  # Create XDG Dirs
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;
    };
  };

  xsession = {
    windowManager = {
      awesome = {
        enable = true;
        package = pkgs.awesomeGit;
      };
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
  };

  # Styling Options
  stylix.targets = {
    waybar.enable = false;
    rofi.enable = false;
    hyprland.enable = false;
    kde.enable = false;
    spicetify.enable = false;
    neovim.enable = false;
    tmux.enable = false;
    vesktop.enable = false;
  };
  gtk = {
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };
  qt = {
    enable = true;
    style.name = "adwaita-dark";
    platformTheme.name = "gtk3";
  };

  # Scripts
  home.packages = [
    inputs.jerry.packages.${pkgs.system}.default
    (import ../../scripts/emopicker9000.nix { inherit pkgs; })
    (import ../../scripts/pdf-viewer.nix { inherit pkgs; })
    (import ../../scripts/task-waybar.nix { inherit pkgs; })
    (import ../../scripts/battery.nix { inherit pkgs; })
    (import ../../scripts/proj.nix { inherit pkgs; })
    (import ../../scripts/clip.nix { inherit pkgs; })
    (import ../../scripts/startup.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/wallsetter.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/web-search.nix { inherit pkgs; })
    (import ../../scripts/obsidian-new.nix {
      inherit pkgs;
      inherit username;
    })
    (import ../../scripts/rofi-launcher.nix { inherit pkgs; })
    (import ../../scripts/screenshootin.nix { inherit pkgs; })
    (import ../../scripts/list-hypr-bindings.nix {
      inherit pkgs;
      inherit host;
    })
  ];

  programs.nyaa = {
    enable = true;
    download_client = "DefaultApp";
    client.default_app.use_magnet = true;
    source.nyaa.default_sort = "Seeders";
  };

  services = {
    flameshot = {
      enable = true;
      package = pkgs.flameshot;
    };
    picom = {
      enable = true;
      activeOpacity = 1.0;
      inactiveOpacity = 0.8;
      shadow = true;
      shadowOffsets = [
        (-25)
        (-25)
      ];
      shadowOpacity = 0.5;
      fade = false;
      fadeDelta = 3;
      fadeSteps = [
        3.0e-2
        3.0e-2
      ];
      opacityRules = [
        "100:class_g = 'Vivaldi-stable'"
        "100:class_g = 'Rofi'"
        "100:class_g = 'duckstation-qt'"
      ];
      backend = "glx";
      vSync = true;
      settings = {
        blur = {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
        shadow-radius = 25;
      };
    };
    hypridle = {
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs = {
    carapace = {
      enable = true;
      enableNushellIntegration = true;
    };
    yazi = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    thefuck = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
    atuin = {
      enable = true;
      settings = {
        style = "compact";
      };
      enableNushellIntegration = true;
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
    spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        enabledExtensions = with spicePkgs.extensions; [
          adblock
          fullScreen
          volumePercentage
          showQueueDuration
          goToSong
          powerBar
          skipOrPlayLikedSongs
          volumeProfiles
          playNext
          history
          keyboardShortcut
          shuffle
        ];
        theme = spicePkgs.themes.nightlight;
        # theme = {
        #   name = "Retro";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "Motschen";
        #     repo = "Retroblur";
        #     rev = "685cf3aea4ed1a4d82f687293f0efb5baa1aec06";
        #     hash = "sha256-YAOmeSAxD0qR8Y7t+HOBoTCJtiJNfveJCmiptfg25OE=";
        #   };
        # };
        # theme = spicePkgs.themes.catppuccin;
        # colorScheme = "macchiato";
      };
    wezterm = {
      enable = false;
      enableZshIntegration = true;
      extraConfig = ''
        return {
          font = wezterm.font_with_fallback {
                "Pixilized",
                "CozetteHiDpi",
                "koishi",
                "fairfax",
                "JetBrains Mono Nerd Font Mono",
          },
          font_size = 16.0,
          color_scheme = "Catppuccin Macchiato",
          hide_tab_bar_if_only_one_tab = true,
          enable_wayland = false,
        }
      '';
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableNushellIntegration = true;
      options = [ "--cmd cd" ];
    };
    tmux = import ../../config/tmux.nix { inherit pkgs; };
    gh.enable = true;
    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };
    kitty = {
      enable = true;
      package = pkgs.kitty;
      settings = {
        scrollback_lines = 2000;
        wheel_scroll_min_lines = 1;
        window_padding_width = 4;
        confirm_os_window_close = 0;
      };
      extraConfig = ''
        tab_bar_style fade
        tab_fade 1
        active_tab_font_style   bold
        inactive_tab_font_style bold
      '';
    };
    bash = {
      enable = true;
      enableCompletion = true;
      profileExtra = ''
        #if [ -z "$DISPLAY" ]; then
        #  exec awesome
        #fi
      '';
      initExtra = ''
        fastfetch
        if [ -f $HOME/.bashrc-personal ]; then
          source $HOME/.bashrc-personal
        fi
      '';
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/cylisos";
        fu = "nh os switch --hostname ${host} --update /home/${username}/cylisos";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        ".." = "cd ..";
        host = "nvim ~/cylisos/hosts/${host}/";
        config = "nvim ~/cylisos/config/";
        oo = "cd /home/${username}/Documents/Main/";
        orv = "nvim '/home/${username}/Documents/Main/01 - Rough Notes/'*";
        lz = "lazygit";
      };
    };
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        sv = "sudo nvim";
        fr = "nh os switch --hostname ${host} /home/${username}/cylisos";
        fu = "nh os switch --hostname ${host} --update /home/${username}/cylisos";
        ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
        v = "nvim";
        cat = "bat";
        ls = "eza --icons";
        ll = "eza -lh --icons --grid --group-directories-first";
        la = "eza -lah --icons --grid --group-directories-first";
        host = "nvim ~/cylisos/hosts/${host}/";
        config = "nvim ~/cylisos/config/";
        py-server = "python -m http.server 8040";
        py-virt = "source .venv/bin/activate";
        py-virtc = "python3 -m venv .venv";
        rl = "source ~/.zshrc";
        zl = "zellij";
        cmc = "cmus-remote -C 'clear'";
        cma = "cmus-remote -C 'add ~/Music";
        cmu = "cmus-remote -C 'update-cache -f'";
        nix-shell = "nix-shell --command zsh";
        nix-develop = "nix develop --command zsh";
        ytmd = "yt-dlp --embed-metadata -x $(ytfzf -I l | grep 'https://')";
        spotd = "spotdl download $1";
        oo = "cd /home/${username}/Documents/Main/";
        orv = "nvim '/home/${username}/Documents/Main/01 - Rough Notes/'*";
        lz = "lazygit";
      };
      defaultKeymap = "emacs";
      history = {
        ignoreAllDups = true;
        path = "$HOME/.zsh_history";
        save = 10000;
        size = 10000;
      };
      profileExtra = ''
        # if [ -z "$DISPLAY" ]; then
        #  exec awesome
        # fi
      '';
      initExtra = ''
        bindkey -e

        # [[ ! -f ${../../config/.p10k.zsh} ]] || source ${../../config/.p10k.zsh}
        krabby random
        # OMP
        # eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/dracula.omp.json)"
        zstyle ':completion:*:git-checkout:*' sort false
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':completion:*' list-colours ''${(s.:.)LS_COLORS}
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
        eval "$(fzf --zsh)"
        eval $(thefuck --alias tf)
        export MANPAGER='nvim +Man!'
      '';
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "sudo"
          "golang"
          "rust"
          "command-not-found"
          "pass"
          "direnv"
        ];
      };
      plugins = [
        {
          name = "zsh-autosuggestions";
          src = pkgs.zsh-autosuggestions;
          file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
        }
        {
          name = "zsh-completions";
          src = pkgs.zsh-completions;
          file = "share/zsh-completions/zsh-completions.zsh";
        }
        {
          name = "zsh-syntax-highlighting";
          src = pkgs.zsh-syntax-highlighting;
          file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
        }
        # {
        #   name = "powerlevel10k";
        #   src = pkgs.zsh-powerlevel10k;
        #   file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        # }
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];
    };
    home-manager.enable = true;
    hyprlock = {
      enable = false;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 10;
          hide_cursor = true;
          no_fade_in = false;
        };
        background = [
          {
            path = "/home/${username}/Pictures/Wallpapers/elden ring-mohg.png";
            blur_passes = 3;
            blur_size = 8;
          }
        ];
        image = [
          {
            path = "/home/${username}/.config/face.jpg";
            size = 150;
            border_size = 4;
            border_color = "rgb(0C96F9)";
            rounding = -1; # Negative means circle
            position = "0, 200";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(CFE6F4)";
            inner_color = "rgb(657DC2)";
            outer_color = "rgb(0D0E15)";
            outline_thickness = 5;
            placeholder_text = "Password...";
            shadow_passes = 2;
          }
        ];
      };
    };
  };
}
