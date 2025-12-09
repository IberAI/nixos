{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    package = pkgs.git;

    # Basic identity
    userName  = "IberAI";
    userEmail = "ilteber.dover@gmail.com";

    # Handy aliases
    aliases = {
      st   = "status -sb";
      co   = "checkout";
      br   = "branch";
      ci   = "commit";
      df   = "diff";
      lg   = "log --oneline --graph --decorate";
      last = "log -1 HEAD";
    };

    # Extra git config (good sane defaults)
    extraConfig = {
      # New repos use "main" as the default branch
      init.defaultBranch = "main";

      # Colors & diffs
      color.ui = "auto";
      diff.colorMoved = "default";

      # Editor & line endings
      core = {
        editor   = "nvim";   # change to "vim" or "nano" if you prefer
        autocrlf = "input";  # safe for Linux, avoids CRLF hell
      };

      # Pull / rebase behavior
      pull = {
        rebase = true;   # `git pull` will rebase by default
        ff     = "only"; # refuse non-fast-forward merges on pull
      };

      rebase.autoStash = true; # stash/unstash automatically when rebasing

      # Push behavior
      push = {
        default    = "simple"; # safe default
        followTags = true;     # push annotated tags that point to pushed commits
      };

      # Merge behavior
      merge = {
        ff             = "only";  # no implicit merge commits on `git merge`
        conflictStyle  = "zdiff3"; # nicer conflict markers (if your git supports it)
      };

      # Small QoL
      help.autocorrect = 10;                 # typo correction after 1s
      credential.helper = "cache --timeout=3600"; # keep creds in memory for 1 hour
    };

    # If you later add a GPG key, you can enable this:
    # signing = {
    #   key = "YOUR-GPG-KEY-ID";
    #   signByDefault = true;
    # };
  };
}

