{
  config,
  pkgs,
  ...
}: {
  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.git;

    # NEW: use settings.user.* instead of userName/userEmail
    settings = {
      user = {
        name = "IberAI";
        email = "ilteber.dover@gmail.com";
      };

      # NEW: aliases moved under settings.alias
      alias = {
        st = "status -sb";
        co = "checkout";
        br = "branch";
        ci = "commit";
        df = "diff";
        lg = "log --oneline --graph --decorate";
        last = "log -1 HEAD";
      };

      init.defaultBranch = "main";

      color.ui = "auto";
      diff.colorMoved = "default";

      core = {
        editor = "nvim";
        autocrlf = "input";
      };

      pull = {
        rebase = true;
        ff = "only";
      };

      rebase.autoStash = true;

      push = {
        default = "simple";
        followTags = true;
      };

      merge = {
        ff = "only";
        conflictStyle = "zdiff3";
      };

      help.autocorrect = 10;
      credential.helper = "cache --timeout=3600";

      gpg.program = "gpg";
      tag.gpgSign = true;
    };

    signing = {
      key = "05AA4F0A904C41E5D4206BFCF167B7A3106DE448";
      signByDefault = true;
    };
  };
}
