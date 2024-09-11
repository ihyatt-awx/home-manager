{ pkgs, lib, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "ihyatt";
  home.homeDirectory = "/home/ihyatt";

   # installing my packages uvu
  home.packages = with pkgs; [
    # CLI utilities
    (nerdfonts.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
    btop
    fd
    ripgrep
    wl-clipboard
    nvd
    zip
    unzip
    sshfs
    dogdns
    moreutils # vidir
    kitty-img
    fre
    loc
    nix-index
    rhvoice
    nix-output-monitor
    pv
    libsecret
    html2text
    mediainfo
    pciutils
    usbutils
    nix-tree
    vulnix
    lsof
    quickemu
    tesseract
    nebula
    ventoy
    gh
    du-dust
    dua
    ouch
    progress
    hydra-check
    pass
    cookiecutter
    tcpdump
    tftp-hpa
    yq
    docker-credential-helpers
    bear
  ];

  # Configure my programs
  programs.fzf = {
    enable = true;
    changeDirWidgetCommand = "fre --sorted";
  };
  programs.gpg.enable = true;
  programs.jq.enable = true;
  programs.kitty = import programs/kitty.nix pkgs;
  programs.starship = import programs/starship.nix lib;
  programs.fish = import programs/fish.nix pkgs;
  #programs.ssh = import programs/ssh.nix pkgs osConfig;
  programs.git = import programs/git.nix pkgs;
  # programs.mercurial = import programs/mercurial.nix pkgs;
  programs.neovim = import programs/neovim pkgs lib;
  programs.helix = import programs/helix pkgs;
  programs.topgrade = {
    enable = true;
    settings = {
      misc = {
        assume_yes = true;
        pre_sudo = true;
        disable = [ "containers" "gnome_shell_extensions" "nix" "git_repos" ];
      };
    };
  };
  programs.eza = {
    enable = true;
    git = true;
    icons = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--group"
      "--extended"
    ];
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.load_dotenv = false;
  };
  programs.nushell = {
    enable = true;
  };
  programs.bat = {
    enable = true;
    syntaxes = {
      nushell = {
        src = pkgs.stdenv.mkDerivation {
          pname = "nushell_sublime_syntax";
          version = "2024-04-08";
          src = pkgs.fetchFromGitHub {
            owner = "kurokirasama";
            repo = "nushell_sublime_syntax";
            rev = "395c382aa2aa3d3ae4cfb701086af905eeaba2b4";
            hash = "sha256-81FLVuswox7S77JShkvhMTHfrlzbxxR3HANZ5C+tMs8=";
          };
          patches = [ ./bat-fix.patch ]; # Fixes https://github.com/kurokirasama/nushell_sublime_syntax/issues/4
          installPhase = ''
            mkdir -p $out
            cp nushell.sublime-syntax $out
          '';
        };
        file = "nushell.sublime-syntax";
      };
    };
  };
  programs.atuin = {
    enable = true;
    flags = [
      "--disable-up-arrow"
    ];
    settings = {
      update_check = false;
      keymap_mode = "vim-insert";
      keymap_cursor = {
        vim_insert = "steady-bar";
        vim_normal = "steady-block";
      };
    };
  };
  # Configure Gnome shell juuuust right WIP
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "espresso@coadmunkee.github.com"
        "gsconnect@andyholmes.github.io"
        "rounded-window-corners@yilozt"
        "caffeine@patapon.info"
        "appindicatorsupport@rgcjonas.gmail.com"
        "aztaskbar@aztaskbar.gitlab.com"
        "clipboard-indicator@tudmotu.com"
      ];
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "org.gnome.Nautilus.desktop"
        "org.mozilla.thunderbird.desktop"
        "chrome-cifhbcnohmdccbgoicgdjpfamggdegmo-Default.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      prefer-dark = true;
    };
    "org/gnome/shell/keybindings" = {
      toggle-message-tray = [ "<Super>m" ];
    };
    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" "compose:ralt" ];
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      sort-directories-first = true;
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file:///home/ihyatt/.local/share/backgrounds/wallpaper.jpg";
      picture-uri-dark = "file:///home/ihyatt/.local/share/backgrounds/wallpaper.jpg";
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///home/ihyatt/.local/share/backgrounds/wallpaper.jpg";
      color-shading-type = "solid";
      picture-options = "zoom";
      primary-color = "#000000000000";
      secondary-color = "#000000000000";
    };
    # Pano settings
    "org/gnome/shell/extensions/pano" = {
      open-links-in-browser = false;
      paste-on-select = false;
    };
    "org/gnome/shell/extensions/pano/text-item" = {
      header-bg-color = "rgb(97,53,131)";
      body-bg-color = "rgb(36,31,49)";
      body-color = "rgb(255,255,255)";
    };
  };

  home.file.wallpaper = {
    source = ./wallpaper.jpg;
    target = ".local/share/backgrounds/wallpaper.jpg";
  };

  home.stateVersion = "23.11"; # Please read the comment before changing.
  programs.home-manager.enable = true;
}
