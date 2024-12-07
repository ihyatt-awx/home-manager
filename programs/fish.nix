pkgs:
let
  docker-dev = ''docker run --network host -it --init --privileged \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /opt/awlinux/src:/opt/awlinux/src \
    -v (hg root):(hg root) \
    containers.allworxcorp.com/ihyatt/allworx-build-environment:latest'';
# containers.allworxcorp.com/jenkins/allworx-build-environment:0.22
in
{
  enable = true;
  loginShellInit = ''
    set -x EDITOR nvim
    set -x LIBVIRT_DEFAULT_URI "qemu:///system"
    fish_add_path ~/.local/bin
    fish_add_path ~/.local/bin/scripts
    fish_add_path /var/lib/flatpak/exports/bin
    fish_add_path ~/.cargo/bin
    fish_add_path ~/.local/share/npm-global/bin
  '';

  shellAbbrs = {
    b = "bat";
    e = "nvim";
    "1" = "prevd";
    "2" = "prevd 2";
    "3" = "prevd 3";
    "4" = "prevd 4";
    c = "cd";
    cg = "cargo";
    reload = "exec fish";
    nv = "lvim";
    tree = "eza -TR --git-ignore";
    up = "topgrade";
    sc = "sudo systemctl";
    scs = "systemctl status";
    scst = "sudo systemctl start";
    scsp = "sudo systemctl stop";
    scr = "sudo systemctl restart";
    jr = "journalctl";
    jre = "journalctl -e -u";
    jrf = "journalctl -f -u";

    nxp = "nix-shell --command fish -p";
    nxs = "nix search nixpkgs";
    # nxr = {
    #   expansion = "nix run nixpkgs#%";
    #   setCursor = true;
    # };
    # nxsh = {
    #   expansion = "nix shell nixpkgs#%";
    #   setCursor = true;
    # };

    g = "git";
    ga = "git add";
    gaa = "git add --all";
    gau = "git add -u";
    gb = "git branch";
    gco = "git checkout";
    gc = "git commit";
    gca = "git commit --amend";
		gcl = "git clone";
    gd = "git diff";
    gds = "git diff --staged";
    gf = "git fetch";
    gl = "git log";
    gm = "git merge";
    gp = "git push";
    gpl = "git pull";
    gpn = "git push -u origin (current_branch)";
    gr = "git remote";
    gra = "git remote add";
    grao = "git remote add origin";
    grb = "git rebase";
    grbi = "git rebase -i";
    gs = "git status -sb";
    gsu = "git submodule";
    gro = "git restore";
    gsw = "git switch";

    h = "hg";
    ha = "hg add";
    hs = "hg status";
    hc = "hg commit";
    hu = "hg update";
    hm = "hg merge";
    hf = "hg fetch";
    hd = "hg vdiff";
    hl = "hg log";
    hr = "hg revert";
    hrc = "hg revert -C";
    hp = "hg push";
    hpl = "hg pull";
    hbr = "hg rebase";
  };

  shellAliases = {
    cl = "printf '\\033[2J\\033[3J\\033[1;1H'";
    git-master-to-main = "git branch -m master main && git push origin :master main:main";
    l = "eza";
    la = "eza -a";
    ll = "eza -l";
    lla = "eza -al";
    lnw = "eza --sort accessed -r";
    scratch = "nvim /tmp/scratch.txt";
    ssh = "kitty +kitten ssh";
    bssh = "${pkgs.openssh}/bin/ssh";
    m0 = "minicom -D /dev/ttyUSB0";
    m1 = "minicom -D /dev/ttyUSB1";
    m2 = "minicom -D /dev/ttyUSB2";
    fixlib = "sudo rm -f /lib/libdl.a /lib64/libdl.a";
    clear-phone-ssh = "sed -i 's/192\.168\.5\..*//' ~/.ssh/known_hosts";
  };

  interactiveShellInit = ''
    fish_vi_key_bindings
    set fish_cursor_default block
    set fish_cursor_insert line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace underscore
    set fish_cursor_external line
    set fish_cursor_visual block


    set -x EXA_COLORS 'di=35;01:da=35'

    # Syntax Highlighting Colors
    set -Ux fish_color_normal c0caf5
    set -Ux fish_color_command 7dcfff
    set -Ux fish_color_keyword bb9af7
    set -Ux fish_color_quote e0af68
    set -Ux fish_color_redirection c0caf5
    set -Ux fish_color_end ff9e64
    set -Ux fish_color_error f7768e
    set -Ux fish_color_param 9d7cd8
    set -Ux fish_color_comment 565f89
    set -Ux fish_color_selection --background=33467c
    set -Ux fish_color_search_match --background=33467c
    set -Ux fish_color_operator 9ece6a
    set -Ux fish_color_escape bb9af7
    set -Ux fish_color_autosuggestion 565f89

    # Completion Pager Colors
    set -Ux fish_pager_color_progress 565f89
    set -Ux fish_pager_color_prefix 7dcfff
    set -Ux fish_pager_color_completion c0caf5
    set -Ux fish_pager_color_description 565f89
    set -Ux fish_pager_color_selected_background --background=33467c

    source ~/.config/fish/functions/__fre_cd.fish

    abbr -a nxr --set-cursor "nix run nixpkgs#%"
    abbr -a nxsh --set-cursor "nix shell nixpkgs#%"

    set -Ux HGDEMANDIMPORT disable
    source "$HOME/.cargo/env.fish"
  '';

  functions = {
    fre-clean = ''
      			for p in (fre --sorted)
      				if ! [ -d $p ]
      					echo $p
      					fre -D $p
      				end
      			end
      		'';
    fish_greeting = ''
       echo 💖 hiya izzy welcome to (gethost) "~" 🏳️‍⚧️
    '';

    trace-bat = ''
      for addr in $argv
        set -a args "$(math -b 16 0x$addr - 4)"
      end
      addr2line -Cafisp -e $(hg root)/BUILD_AREA/battleship/targets/battleship/oisapp/ecosapp/oisapp.elf $args
    '';

    trace-vortex-phonegui = ''
      for addr in $argv
        set -a args "$(math -b 16 0x$addr - 4)"
      end
      addr2line -Cafisp -e $(hg root)/BUILD_AREA/vortex/93xx/phonegui/phonegui/bin/phonegui $args
    '';

    trace-vortex-pcore = ''
      for addr in $argv
        set -a args "$(math -b 16 0x$addr - 4)"
      end
      addr2line -Cafisp -e $(hg root)/BUILD_AREA/vortex/93xx/pcore/main/pcore/bin/pcore $args
    '';

    trace-vserver = ''
      for addr in $argv
        set -a args "$(math -b 16 0x$addr - 8)"
      end
      addr2line -Cafisp -e $(hg root)/BUILD_AREA/vserver/targets/vserver/awxServer/bin/awxServer $args
    '';
    r = ''
      rg -g '!BUILD_AREA/' -g '!thirdparty/' -g '!Android-Reach/' -g '!iOS-Reach/' -g '!Battleship-DSP/' -p $argv | less -R
    '';

    extract-log = ''
      set tmp (mktemp -d)

      set xls $argv[1]
      ${pkgs.yq}/bin/xq -r '.Workbook.Worksheet[] | select(."@ss:Name" == "Syslog") | .Table.Row[] | .Cell.Data."#text"' $xls > "$tmp/unsorted.txt"
      grep 'Jan  1 00:00' "$tmp/unsorted.txt" > "$tmp/fist.txt"
      grep -v 'Jan  1 00:00' "$tmp/unsorted.txt" > "$tmp/last.txt"
      cat "$tmp/fist.txt" "$tmp/last.txt"
    '';
    extract-log-zip = ''
      set tmp (mktemp -d)

      unzip -qq -d $tmp $argv[1] 
      set xls (find $tmp -name '*.xls')
      ${pkgs.yq}/bin/xq -r '.Workbook.Worksheet[] | select(."@ss:Name" == "Syslog") | .Table.Row[] | .Cell.Data."#text"' $xls > "$tmp/unsorted.txt"
      grep 'Jan  1 00:00' "$tmp/unsorted.txt" > "$tmp/fist.txt"
      grep -v 'Jan  1 00:00' "$tmp/unsorted.txt" > "$tmp/last.txt"
      cat "$tmp/fist.txt" "$tmp/last.txt"
    '';
    build-shell = ''${docker-dev} bash -c "cd $(hg root); exec bash"'';
    mk = ''${docker-dev} make -j16 -C (hg root) -f (hg root)/Allworx.mak $argv'';
    mkh = ''${docker-dev} make -j16 -C (hg root) -f (hg root)/Allworx.mak $argv awxn.desthost=localhost'';
    mkmake = ''${docker-dev} make -C (hg root) $argv'';
    mkb = ''${docker-dev} bear --append --config (hg root)/bear-config.json --output (hg root)/compile_commands.json -- make -j16 -C (hg root) -f (hg root)/Allworx.mak $argv awxn.desthost=localhost'';
    # mk-orig = "make -j16 -f $(hg root)/Allworx.mak $argv";
    # mkh-orig = ''make -j16 -f $(hg root)/Allworx.mak $argv awxn.desthost=localhost'';
    # mk = "make -j16 -f $(hg root)/Allworx.mak $argv";
    # mkh = ''make -j16 -f $(hg root)/Allworx.mak $argv awxn.desthost=localhost'';
    upload-vserver = ''
      podman load -i BUILD_AREA/vserver/targets/vserver/awlinux/containers/vserver.tar
      podman tag localhost/vserver:latest containers.allworxcorp.com/ihyatt/vserver:latest
      podman push containers.allworxcorp.com/ihyatt/vserver:latest
      '';
    run-vserver = ''
      sudo podman rmi -f localhost/vserver:latest
      sudo podman load -i BUILD_AREA/vserver/targets/vserver/awlinux/containers/vserver.tar
      sudo podman run -it --cap-add=SYS_PTRACE --cap-add=CAP_SYS_NICE --security-opt seccomp=unconfined \
        --env AWX_PHONE_IFACE=eth0 --env AWX_INIT_ADMIN_PASSWORD=admin \
        --network host localhost/vserver:latest /usr/bin/start.sh
      '';
    run-vserver-echo = ''
      podman rmi -f localhost/vserver:latest
      podman load -i BUILD_AREA/vserver/targets/vserver/awlinux/containers/vserver.tar
      set log_dir (mktemp -d)
      echo tailing log at $log_dir/awxServer-startup.log
      podman run -it --cap-add=SYS_PTRACE --cap-add=CAP_SYS_NICE --security-opt seccomp=unconfined \
        --network host -v $log_dir:/var/log:Z \
        --env AWX_PHONE_IFACE=eth0 --env AWX_INIT_ADMIN_PASSWORD=admin \
        localhost/vserver:latest /usr/bin/start.sh && tail -f $log_dir/awxServer-startup.log
      '';
    shell-vserver = ''
      podman rmi -f localhost/vserver:latest
      podman load -i BUILD_AREA/vserver/targets/vserver/awlinux/containers/vserver.tar
      podman run -it localhost/vserver:latest bash
      '';
    cdr = ''
      if set DIR (hg root 2> /dev/null)
        cd $DIR
      else if set DIR (git rev-parse --show-toplevel 2> /dev/null)
        cd $DIR
      end
    '';

    pssh = ''
      ${pkgs.openssh}/bin/ssh -i ~/.ssh/devmode -o StrictHostKeyChecking=no "root@192.168.5.$argv[1]"
    '';

    gbd = {
      wraps = "git branch -d";
      body = "git branch -d $argv[1] && git push --delete origin $argv[1]";
    };
    gbD = {
      wraps = "git branch -D";
      body = "git branch -D $argv[1] && git push --delete origin $argv[1]";
    };
    mkproj = {
      body = ''
        cookiecutter "$HOME/Projects/nixcfg/programs/cookiecutter/$argv[1]"
      '';
    };
    tmp = {
      wraps = "nvim";
      body = ''
        set dir (mktemp -d)
        nvim "$dir/temp.txt"
        rm -r "$dir"
      '';
    };

    gethost = ''
      if test -f /run/.containerenv
          function gethost
              grep -F name= /run/.containerenv | cut -d '"' -f2; 
          end
      else if command -v hostnamectl &> /dev/null
          function gethost --wraps=hostnamectl --description 'alias gethost hostnamectl'
              hostnamectl --pretty; 
          end
      else if command -v hostname &> /dev/null
          function gethost --wraps=hostname --description 'alias gethost hostname -s'
              hostname -s;
          end
      else
          function gethost --wraps=hostname --description 'alias gethost hostname'
              echo host_error;
          end
      end
    '';

    mkshell = ''
            echo "{ pkgs ? import <nixpkgs> {} }:

            pkgs.mkShell {
              packages = with pkgs; [ $argv ];
            }" > shell.nix
            echo "use nix" > .envrc && direnv allow .
      			printf ".envrc\n.direnv" >> .gitignore
    '';

    copy = ''
      if command -v wl-copy &> /dev/null
          if test -f "$argv[1]"
              wl-copy < "$argv[1]"
          else
              wl-copy $argv
          end
      else
          xclip -sel clip "$argv"
      end
    '';

    paste = ''
      if command -v wl-paste &> /dev/null
          wl-paste
      else
          xclip -sel clip -o "$argv"
      end
    '';

    current_branch = ''
      set ref (git symbolic-ref HEAD 2> /dev/null); or \
      set ref (git rev-parse --short HEAD 2> /dev/null); or return
      echo $ref | sed s-refs/heads/--
    '';

    __fre_cd = {
      onVariable = "PWD";
      body = ''
                status --is-command-substitution; and return
        	      fre --add (pwd)
      '';
    };
  };

  plugins = [
    # {
    #   name = "done";
    #   src = pkgs.fishPlugins.done.src;
    # }
    {
      name = "puffer";
      src = pkgs.fishPlugins.puffer.src;
    }
    {
      name = "autopair";
      src = pkgs.fishPlugins.autopair.src;
    }
  ];
}
