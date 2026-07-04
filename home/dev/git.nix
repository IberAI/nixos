{ lib, pkgs, ... }: {
  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    package = pkgs.git;

    settings = {
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
      include.path = "~/.config/git/local.inc";

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
    };
  };

  home.file.".config/git/local.inc.example".text = ''
    [user]
      name = Your Name
      email = you@example.com

    # Uncomment after importing your private key locally.
    # [user]
    #   signingkey = YOUR_GPG_KEY_ID
    # [commit]
    #   gpgsign = true
    # [tag]
    #   gpgsign = true
    # [gpg]
    #   program = gpg
  '';

  home.activation.gitLocalConfig = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    user_name=/run/secrets/git/userName
    user_email=/run/secrets/git/userEmail
    signing_key=/run/secrets/git/signingKey
    target="$HOME/.config/git/local.inc"

    if [ -r "$user_name" ] && [ -r "$user_email" ]; then
      mkdir -p "$HOME/.config/git"
      {
        printf '[user]\n'
        printf '  name = %s\n' "$(cat "$user_name")"
        printf '  email = %s\n' "$(cat "$user_email")"

        if [ -r "$signing_key" ]; then
          printf '  signingkey = %s\n' "$(cat "$signing_key")"
          printf '[commit]\n'
          printf '  gpgsign = true\n'
          printf '[tag]\n'
          printf '  gpgsign = true\n'
          printf '[gpg]\n'
          printf '  program = gpg\n'
        fi
      } > "$target"
      chmod 0600 "$target"
    fi
  '';
}
