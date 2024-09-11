lib: {
  enable = true;
  settings = {
    format = lib.concatStrings [
      "[╭](#fed6ff)[](#22152a)"
      "$os"
      "$username"
      "$hostname"
      "$container"
      "[](bg:#291933 fg:#22152a)"
      "$directory"
      "[](fg:#291933 bg:#4a1f62)"
      "$git_branch"
      "$git_status"
      "$hg_branch"
      "[](fg:#4a1f62 bg:#cc96e8)"
      "$c"
      "$elixir"
      "$elm"
      "$golang"
      "$haskell"
      "$java"
      "$julia"
      "$nodejs"
      "$nim"
      "$rust"
      "$scala"
      "[](fg:#cc96e8 bg:#ff68a1)"
      "$docker_context"
      "[](fg:#ff68a1 bg:#e34d87)"
      "$jobs"
      "$time"
      "[ ](fg:#e34d87)"
      "$fill $battery $status $cmd_duration "
      "[](#74d7ec)[](#ffafc7)[](#fbf9f5)[](#ffb5cb)[](#73d5ea)"
      "$line_break[│](#fed6ff)$line_break[╰](#fed6ff)[](#d4ade8) "
    ];

    username = {
      disabled = false;
      format = "[$user ]($style)";
      show_always = true;
      style_root = "bg:#22152a";
      style_user = "bg:#22152a";
    };
    hostname = {
      style = "bg:#22152a";
      format = "[ $hostname]($style)";
    };
    container = {
      format = "[$symbol ]($style)";
      style = "bg:#22152a";
    };
    directory = {
      format = "[ $path ]($style)";
      style = "bg:#291933";
      substitutions = { Documents = "󰈙"; Downloads = " "; Music = " "; Pictures = " "; Projects = ""; };
      truncation_length = 3;
      truncation_symbol = "…/";
    };

    git_branch = {
      format = "[ $symbol $branch ]($style)";
      style = "bg:#4a1f62";
      symbol = "";
    };
    git_status = {
      format = "[$all_status$ahead_behind ]($style)";
      style = "bg:#4a1f62";
    };
    hg_branch = {
      format = "[ $symbol $branch ]($style)";
      style = "bg:#4a1f62";
      symbol = "";
    };

    c = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    elixir = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg#1A1B26";
      symbol = " ";
    };
    elm = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg#1A1B26";
      symbol = " ";
    };
    golang = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    haskell = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    java = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    julia = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    nim = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };
    nix_shell = {
      format = "[ $symbol $context ]($style) $path";
      style = "bg:#ff68a1";
      symbol = "";
    };
    nodejs = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = "";
    };
    rust = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = "";
    };
    scala = {
      format = "[ $symbol ($version) ]($style)";
      style = "bg:#cc96e8 fg:#1A1B26";
      symbol = " ";
    };

    fill = {
      symbol = " ";
    };
    jobs = {
      format = "[$symbol$number]($style)";
      style = "bg:#e34d87";
    };
    status = {
      disabled = false;
      format = "[\\[$common_meaning$signal_name$maybe_int\\]]($style)";
      map_symbol = true;
      style = "bold red";
    };
    time = {
      disabled = false;
      format = "[ ♥ $time ]($style)";
      style = "bg:#e34d87";
      time_format = "%R";
    };
    character = {
      error_symbol = " [](#d4ade8)";
      success_symbol = " [](#d4ade8)";
    };
    docker_context = {
      format = "[ $symbol $context ]($style) $path";
      style = "bg:#ff68a1";
      symbol = " ";
    };
  };
}
