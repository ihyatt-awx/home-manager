pkgs: 
let
  nixGL = import <nixgl> {};
in
{
  enable = true;
  package = pkgs.hello;
  # package = pkgs.writeShellScriptBin "kitty" ''
  #   #!/bin/sh
  #   ${nixGL.auto.nixGLDefault}/bin/nixGL ${pkgs.kitty}/bin/kitty "$@"
  # '';
  font.name = "Fira Code";
  font.package = pkgs.fira-code;
  font.size = 12;
  environment = {
    VIRTUAL_ENV_DISABLE_PROMPT = "true";
  };
  keybindings = {
    "ctrl+c" = "copy_and_clear_or_interrupt";
    "ctrl+v" = "paste_from_clipboard";
    "super+v" = "send_text all \\x16";
    "kitty_mod+l" = "next_tab";
    "kitty_mod+h" = "previous_tab";
    "kitty_mod+t" = "new_tab_with_cwd";
    "kitty_mod+s" = "show_scrollback";
    "kitty_mod+e" = "kitty_scrollback_nvim";
    "kitty_mod+g" = "kitty_scrollback_nvim --config ksb_builtin_last_cmd_output";
  };
  settings = {
    enable_audio_bell = false;
    remember_window_size = false;
    initial_window_width = "110c";
    initial_window_height = "30c";
    hide_window_decorations = true;
    scrollback_lines = 5000;
    tab_bar_edge = "bottom";
    tab_bar_style = "powerline";
    tab_powerline_style = "angled";
    allow_remote_control = "socket-only";
    listen_on = "unix:/tmp/kitty";
    shell_integration = "enabled";
    notify_on_cmd_finish = "never";
    # kitty-scrollback.nvim Kitten alias
    action_alias = "kitty_scrollback_nvim kitten /nix/store/scx0q24rfqlja022c8j36jp887kkybcj-vim-pack-dir/pack/myNeovimPackages/start/mikesmithgh-kitty-scrollback.nvim/python/kitty_scrollback_nvim.py";
    mouse_map = "ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output";

    symbol_map = "U+23FB-U+23FE,U+2665,U+26A1,U+2B58,U+E000-U+E00A,U+E0A0-U+E0A3,U+E0B0-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+E200-U+E2A9,U+E300-U+E3E3,U+E5FA-U+E634,U+E700-U+E7C5,U+EA60-U+EBEB,U+F000-U+F2E0,U+F300-U+F32F,U+F400-U+F4A9,U+F500-U+F8FF Symbols Nerd Font Mono";

    # For rounded corners in Gnome
    # linux_display_server = "x11";

    ## name: Tokyo Night
    ## license: MIT
    ## author: Folke Lemaitre
    ## upstream: https://github.com/folke/tokyonight.nvim/raw/main/extras/kitty/tokyonight_night.conf


    background = "#1a1b26";
    foreground = "#c0caf5";
    selection_background = "#33467c";
    selection_foreground = "#c0caf5";
    url_color = "#73daca";
    cursor = "#c0caf5";
    cursor_text_color = "#1a1b26";

    # Tabs
    active_tab_background = "#cc96e8";
    active_tab_foreground = "#4a1f62";
    inactive_tab_background = "#292e42";
    inactive_tab_foreground = "#545c7e";

    # Windows
    active_border_color = "#cc96e8";
    inactive_border_color = "#292e42";

    # normal
    color0 = "#15161e";
    color1 = "#f7768e";
    color2 = "#9ece6a";
    color3 = "#e0af68";
    color4 = "#7aa2f7";
    color5 = "#bb9af7";
    color6 = "#7dcfff";
    color7 = "#a9b1d6";

    # bright
    color8 = "#414868";
    color9 = "#f7768e";
    color10 = "#9ece6a";
    color11 = "#e0af68";
    color12 = "#7aa2f7";
    color13 = "#bb9af7";
    color14 = "#7dcfff";
    color15 = "#c0caf5";

    # extended colors
    color16 = "#ff9e64";
    color17 = "#db4b4b";
  };
}
