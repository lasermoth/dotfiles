{...}: {
  programs.git = {
    enable = true;

    settings = {
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status --short --branch";
        last = "log -1 HEAD --stat";
        lg = "log --graph --pretty=format:'%C(auto)%h %C(bold blue)%ad %C(auto)%d %s %C(dim white)- %an' --date=short";
      };

      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      fetch.prune = true;
      rebase.autoStash = true;
      diff.colorMoved = "default";
      merge.conflictStyle = "zdiff3";

      # 1Password SSH signing foundation. Commit signing stays disabled until
      # user.signingKey is set to an SSH public key from 1Password.
      gpg.format = "ssh";
      gpg.ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      commit.gpgsign = false;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      features = "decorations";
      navigate = true;
      side-by-side = true;
      line-numbers = true;
      syntax-theme = "Catppuccin Mocha";
    };
  };
}
