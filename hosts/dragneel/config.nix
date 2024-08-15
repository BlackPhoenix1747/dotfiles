{
  config,
  pkgs,
  host,
  username,
  options,
  inputs,
  ...
}:

{
  imports = [
    ./hardware.nix
    ./users.nix
    ../../modules/amd-drivers.nix
    ../../modules/intel-drivers.nix
    ../../modules/vm-guest-services.nix
    ../../modules/local-hardware-clock.nix
    ../../modules/overlays.nix
  ];

  boot = {
    # Kernel
    kernelPackages = pkgs.linuxPackages_latest;
    #kernelPackages = pkgs.linuxPackages_zen;

    # This is for OBS Virtual Cam Support
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    # Needed For Some Steam Games
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    # Bootloader.
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # Make /tmp a tmpfs
    tmp = {
      useTmpfs = false;
      tmpfsSize = "30%";
    };
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };
  

  # Styling Options
  stylix = {
    enable = true;
    image = ../../config/wallpapers/japanese-purple.jpg;
    #base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    base16Scheme = {
      base00= "1e1e2e"; # base
      base01= "181825"; # mantle
      base02= "313244"; # surface0
      base03= "45475a"; # surface1
      base04= "585b70"; # surface2
      base05= "cdd6f4"; # text
      base06= "f5e0dc"; # rosewater
      base07= "b4befe"; # lavender
      base08= "f38ba8"; # red
      base09= "fab387"; # peach
      base0A= "f9e2af"; # yellow
      base0B= "a6e3a1"; # green
      base0C= "94e2d5"; # teal
      base0D= "89b4fa"; # blue
      base0E= "cba6f7"; # mauve
      base0F= "f2cdcd"; # flamingo
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.bibata-cursors;
    cursor.name = "Bibata-Modern-Ice";
    cursor.size = 24;
    fonts = {
      monospace = {
        package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      serif = {
        package = pkgs.montserrat;
        name = "Montserrat";
      };
      sizes = {
        applications = 12;
        terminal = 15;
        desktop = 11;
        popups = 12;
      };
    };
  };

  # Extra Module Options
  drivers.amdgpu.enable = true;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;
  local.hardware-clock.enable = false;

  # Enable networking
  networking.networkmanager.enable = true;
  networking.hostName = host;
  networking.timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];

  # Set your time zone.
  time.timeZone = "Asia/Karachi";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  programs = {
    #nix-ld = {
      #enable = true;
      #libraries = with pkgs; [
      #];
    #};
    firefox.enable = true;
    gamemode.enable = true;
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        buf = {
          symbol = " ";
        };
        c = {
          symbol = " ";
        };
        directory = {
          read_only = " 󰌾";
        };
        docker_context = {
          symbol = " ";
        };
        fossil_branch = {
          symbol = " ";
        };
        git_branch = {
          symbol = " ";
        };
        golang = {
          symbol = " ";
        };
        hg_branch = {
          symbol = " ";
        };
        hostname = {
          ssh_symbol = " ";
        };
        lua = {
          symbol = " ";
        };
        memory_usage = {
          symbol = "󰍛 ";
        };
        meson = {
          symbol = "󰔷 ";
        };
        nim = {
          symbol = "󰆥 ";
        };
        nix_shell = {
          symbol = " ";
        };
        nodejs = {
          symbol = " ";
        };
        ocaml = {
          symbol = " ";
        };
        package = {
          symbol = "󰏗 ";
        };
        python = {
          symbol = " ";
        };
        rust = {
          symbol = " ";
        };
        swift = {
          symbol = " ";
        };
        zig = {
          symbol = " ";
        };
      };
    };
    dconf.enable = true;
    seahorse.enable = true;
    fuse.userAllowOther = true;
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    virt-manager.enable = true;
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;
      
  users = {
    mutableUsers = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    killall
    eza
    git
    cmatrix
    lolcat
    fastfetch
    htop
    libvirt
    lxqt.lxqt-policykit
    lm_sensors
    unzip
    unrar
    libnotify
    v4l-utils
    ydotool
    duf
    ncdu
    wl-clipboard
    pciutils
    ffmpeg
    socat
    cowsay
    ripgrep
    lshw
    bat
    pkg-config
    meson
    hyprpicker
    ninja
    brightnessctl
    virt-viewer
    swappy
    appimage-run
    networkmanagerapplet
    yad
    inxi
    playerctl
    nh
    nixfmt-rfc-style
    libvirt
    swww
    grim
    slurp
    file-roller
    swaynotificationcenter
    imv
    mpv
    pavucontrol
    tree
    neovide
    greetd.tuigreet
    fzf
    spotube
    firefox
    yaml-language-server
    vim-language-server
    bash-language-server
    lua-language-server
    haskell-language-server
    vscode-langservers-extracted
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    gamemode
    qbittorrent
    zed-editor
    nixd
    tmuxifier
    ghc
    vivaldi
    vivaldi-ffmpeg-codecs
    nextcloud-client
    lazygit
    xfce.tumbler
    luajitPackages.luarocks
    cliphist
    scc
    python3
    love_0_10
    xorg.xev
    wev
    pamixer
    scrcpy
    android-tools
    gimp
    inkscape
    go
    vesktop
    obsidian
    gitleaks
    nvtopPackages.amd
    scriptisto
    amberol
    obs-studio
    pass
    wezterm
    zig
    zls
    lua54Packages.luacheck
    pylint
    #rmpc
    texliveMedium
    xournal
    scrot
    musikcube
    (emacsWithPackagesFromUsePackage {
      package = pkgs.emacsGit;
      config = ../../config/emacs/init.el;
      extraEmacsPackages = epkgs: [
        epkgs.use-package
        epkgs.evil
        epkgs.evil-collection
        epkgs.evil-tutor
        epkgs.general
        epkgs.which-key
        epkgs.toc-org
        epkgs.org-bullets
        epkgs.sudo-edit
        epkgs.all-the-icons
        epkgs.all-the-icons-dired
        epkgs.counsel
        epkgs.ivy
        epkgs.ivy-rich
        epkgs.all-the-icons-ivy-rich
        epkgs.elcord
        epkgs.eshell-syntax-highlighting
        epkgs.vterm
        epkgs.vterm-toggle
        epkgs.catppuccin-theme
        epkgs.rainbow-mode
        epkgs.company
        epkgs.company-box
        epkgs.dashboard
        epkgs.diminish
        epkgs.flycheck
        epkgs.lua-mode
        epkgs.nix-mode
        epkgs.haskell-mode
        epkgs.projectile
        epkgs.eshell-toggle
        epkgs.dired-open
        epkgs.peep-dired
        epkgs.neotree
        epkgs.doom-themes
        epkgs.doom-modeline
        epkgs.elfeed
        epkgs.elfeed-goodies
        epkgs.git-timemachine
        epkgs.magit
        epkgs.hl-todo
        epkgs.perspective
        epkgs.rainbow-delimiters
        epkgs.tldr
        epkgs.cdlatex
        epkgs.auctex
        epkgs.zig-mode
        epkgs.lsp-mode
        epkgs.lsp-ui
        epkgs.lsp-treemacs
        epkgs.lsp-ivy
        epkgs.dap-mode
        epkgs.helm-lsp
        epkgs.yasnippet
        epkgs.carbon-now-sh
      ];
    })
    #Awesome related
    xorg.xprop
    xorg.xinit
    python312Packages.cmake
    luajitPackages.lgi
    luajit
    xorg.xorgproto
    xorg.libxcb
    xcb-util-cursor
    xorg.xcbutil
    xorg.xcbutilkeysyms
    cairo
    pango
    glib
    haskellPackages.gio
    xclip
  ];

  fonts = {
    packages = with pkgs; [
      noto-fonts-emoji
      noto-fonts-cjk
      font-awesome
      symbola
      material-icons
    ];
  };

  environment.variables = {
    ZANEYOS_VERSION = "2.2";
    ZANEYOS = "true";
  };

  environment.pathsToLink = [ "/share/zsh" ];

  # Extra Portal Configuration
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal
    ];
  };

  # Services to start
  
  services = {
    ollama = {
      enable = false;
      acceleration = "rocm";
    };
    emacs.enable = true;
    mpd = {
      enable = false;
      user = "cylis";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };
    kanata = {
      enable = true;
      keyboards = {
        main = {
        config = ''
  (defsrc
    caps 
  )
  
  (defalias 
    ;; tap caps lock as caps lock, hold caps lock as left control
    caps (tap-hold 200 200 caps lctl)
  )
  (deflayer base
    @caps 
  )
'';
        };
      };
    };
    tailscale.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      xkb = {
        layout = "us,jp";
        options = "grp:win_space_toggle";
        variant = "";
      };
    };
    #desktopManager.plasma6.enable = true;
    greetd = {
      enable = true;
      vt = 3;
      settings = {
        default_session = {
          # Wayland Desktop Manager is installed only for user ryan via home-manager!
          user = username;
          # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config here.
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startx"; 
          #command = "${pkgs.greetd.tuigreet}/bin/tuigreet --sessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions --remember --remember-user-session";
        };
      };
    };
    smartd = {
      enable = false;
      autodetect = true;
    };
    libinput.enable = true;
    fstrim.enable = true;
    gvfs.enable = true;
    openssh.enable = true;
    flatpak.enable = true;
    printing = {
      enable = true;
      drivers = [
        # pkgs.hplipWithPlugin
      ];
    };
    gnome.gnome-keyring.enable = true;
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    ipp-usb.enable = true;
    syncthing = {
      enable = true;
      user = "${username}";
      dataDir = "/home/${username}";
      configDir = "/home/${username}/.config/syncthing";
    };
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    rpcbind.enable = false;
    nfs.server.enable = false;
  };
  systemd.services.flatpak-repo = {
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/${toString config.users.users.cylis.uid}";
  };
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.sane-airscan ];
    disabledDefaultBackends = [ "escl" ];
  };

  # Extra Logitech Support
  hardware.logitech.wireless.enable = false;
  hardware.logitech.wireless.enableGraphical = false;

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Security / Polkit
  security.rtkit.enable = true;
  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  # Optimization settings and garbage collection automation
  nix = {
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Virtualization / Containers
  virtualisation.libvirtd.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # OpenGL
  hardware.graphics = {
    enable = true;
    #driSupport = true;
    #driSupport32Bit = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
