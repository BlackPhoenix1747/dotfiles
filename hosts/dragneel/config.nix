{
  config,
  pkgs,
  host,
  inputs,
  username,
  options,
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
    image = ../../config/wallpapers/law.jpg;
    base16Scheme = {
      # base00 = "1e1e2e"; # base
      # base01 = "181825"; # mantle
      # base02 = "313244"; # surface0
      # base03 = "45475a"; # surface1
      # base04 = "585b70"; # surface2
      # base05 = "cdd6f4"; # text
      # base06 = "f5e0dc"; # rosewater
      # base07 = "b4befe"; # lavender
      # base08 = "f38ba8"; # red
      # base09 = "fab387"; # peach
      # base0A = "f9e2af"; # yellow
      # base0B = "a6e3a1"; # green
      # base0C = "94e2d5"; # teal
      # base0D = "89b4fa"; # blue
      # base0E = "cba6f7"; # mauve
      # base0F = "f2cdcd"; # flamingo
      base00 = "24283B";
      base01 = "16161E";
      base02 = "343A52";
      base03 = "444B6A";
      base04 = "787C99";
      base05 = "A9B1D6";
      base06 = "CBCCD1";
      base07 = "D5D6DB";
      base08 = "C0CAF5";
      base09 = "A9B1D6";
      base0A = "0DB9D7";
      base0B = "9ECE6A";
      base0C = "B4F9F8";
      base0D = "2AC3DE";
      base0E = "BB9AF7";
      base0F = "F7768E";
    };
    polarity = "dark";
    opacity.terminal = 0.8;
    cursor.package = pkgs.banana-cursor;
    cursor.name = "Banana";
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
    nano.enable = false;
    gamemode.enable = true;
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
    ffmpeg-full
    socat
    pokemonsay
    krabby
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
    zsh
    gamemode
    deluge-gtk
    zed-editor
    nixd
    vivaldi
    vivaldi-ffmpeg-codecs
    nextcloud-client
    lazygit
    xfce.tumbler
    luajitPackages.luarocks
    cliphist
    scc
    xorg.xev
    wev
    pamixer
    gimp
    inkscape
    vesktop
    obsidian
    gitleaks
    nvtopPackages.amd
    amberol
    obs-studio
    pass
    wezterm
    rmpc
    xournal
    scrot
    zellij
    thefuck # Favorite package btw
    # aseprite
    # libresprite
    # redis
    exercism
    tldr
    protonvpn-cli
    protonvpn-gui
    pipes-rs
    # tym
    spotdl
    screenkey
    radeontop
    aria2
    foliate
    cmus
    cmusfm
    zathura
    vlc
    qalculate-gtk
    jdk
    yazi
    figlet
    soulseekqt
    yacreader
    ripgrep
    lutgen
    fd
    spotify
    sshfs
    timg
    flowtime
    mousam
    freetube
    anup
    libreoffice
    lutris
    wine64
    # wineWow64Packages.waylandFul
    # ente-auth
    xwallpaper
    xbindkeys
    polybar
    xwayland-satellite-unstable
    cloudflare-warp
    stremio
    rofi-pass
    factorio-headless
    corectrl
    yt-dlp
    ytfzf
    nushell
    carapace
    localsend
    gpodder
    geany
    waypaper
    zoom-us
    (emacsWithPackagesFromUsePackage {
      package = pkgs.emacs-git;
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
        # epkgs.elcord
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
        # epkgs.haskell-mode
        epkgs.go-mode
        epkgs.zig-mode
        epkgs.projectile
        epkgs.eshell-toggle
        epkgs.dired-open
        epkgs.peep-dired
        epkgs.neotree
        epkgs.doom-themes
        epkgs.doom-modeline
        epkgs.git-timemachine
        epkgs.magit
        epkgs.hl-todo
        epkgs.perspective
        epkgs.rainbow-delimiters
        epkgs.tldr
        epkgs.lsp-mode
        epkgs.lsp-ui
        epkgs.lsp-treemacs
        epkgs.lsp-ivy
        epkgs.dap-mode
        epkgs.obsidian
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
      noto-fonts-cjk-sans
      font-awesome
      symbola
      material-icons
      victor-mono
      iosevka
    ];
  };

  environment.variables = {
    CYLISOS_VERSION = "1.0";
    CYLISOS = "true";
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
    cloudflare-warp.enable = true;
    emacs.enable = true;
    kanata = {
      enable = true;
      keyboards = {
        main = {
          config = ''
            (defsrc
              caps
              ralt
            )
            (defvar
              tap 200
              hold 200
            )
            (defalias 
              caps (tap-hold $tap $hold esc lctl)
            )
            (deflayer base
              @caps
              bspc
            )
          '';
        };
      };
    };
    tailscale.enable = true;
    xserver = {
      enable = true;
      displayManager.startx.enable = true;
      desktopManager = {
        xfce = {
          enable = true;
          enableXfwm = false;
          noDesktop = true;
        };
      };
      windowManager.i3.enable = true;
      xkb = {
        layout = "us,jp";
        options = "grp:win_space_toggle";
        variant = "";
      };
    };
    desktopManager.plasma6.enable = false;
    greetd = {
      enable = true;
      vt = 2;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri";
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
      settings = {
        folders = {
          "/home/${username}/Documents/Main" = {
            id = "obsidian";
            devices = [ "mobile" ];
          };
        };
      };
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

  # Bluetooth Support
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

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
  security.pam.services.hyprlock = {
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
      substituters = [
        "https://cache.garnix.io"
        "https://ghostty.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
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
  };
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 53317 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  system.stateVersion = "23.11";
}
