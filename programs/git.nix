pkgs: {
  enable = true;
  lfs.enable = true;
  package = pkgs.gitAndTools.gitFull;
  userName = "Isabella Hyatt";
  userEmail = "ihyatt@allworx.com";
  extraConfig = {
    core.editor = "nvim";
    init.defaultbranch = "main";
    pull.rebase = true;
    push.followTags = true;
    credential.helper = "libsecret";
    sendemail."main" = {
      annotate = true;
      confirm = "auto";
    };
  };
  delta.enable = true;
  delta.options = {
    features = "side-by-side line-numbers decorations";
    plus-style = "syntax \"#003800\"";
    minus-style = "syntax \"#3f0001\"";
    syntax-theme = "Dracula";
    decorations = {
      commit-decoration-style = "bold yellow box ul";
      file-style = "bold yellow ul";
      file-decoration-style = "none";
      hunk-header-decoration-style = "cyan box ul";
    };
    line-numbers = {
      line-numbers-left-style = "cyan";
      line-numbers-right-style = "cyan";
      line-numbers-minus-style = "124";
      line-numbers-plus-style = "28";
    };
  };
}
