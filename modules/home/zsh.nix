{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
    };

    shellAliases = {
      ll = "eza -la --icons --group-directories-first";
      la = "eza -a --icons --group-directories-first";
      l = "eza --icons --group-directories-first";
      cat = "bat";
      gs = "git status --short --branch";
      gd = "git diff";
      gds = "git diff --staged";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      sw = "~/repositories/dotfiles/scripts/switch.sh";
    };

    initContent = ''
      # Fresh zsh foundation managed by Home Manager.
      setopt AUTO_CD
      setopt CORRECT
      setopt HIST_VERIFY
      setopt INTERACTIVE_COMMENTS
      setopt NO_BEEP
      setopt PROMPT_SUBST

      export EDITOR="nvim"
      export VISUAL="$EDITOR"
      export PAGER="less"
      export LESS="-R"

      # Prefer Homebrew's GNU userland over the BSD utilities shipped with macOS.
      # These paths are populated by modules/darwin/homebrew.nix.
      export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/diffutils/bin:$PATH"
      export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gpatch/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gnu-getopt/bin:$PATH"
      export PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gnu-tar/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gnu-time/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gnu-which/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/grep/libexec/gnubin:$PATH"
      export PATH="/opt/homebrew/opt/gzip/bin:$PATH"
      export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
      export MANPATH="/opt/homebrew/opt/coreutils/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/diffutils/share/man:$MANPATH"
      export MANPATH="/opt/homebrew/opt/findutils/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gawk/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gpatch/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gnu-getopt/share/man:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gnu-sed/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gnu-tar/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gnu-time/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gnu-which/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/grep/libexec/gnuman:$MANPATH"
      export MANPATH="/opt/homebrew/opt/gzip/share/man:$MANPATH"
      export MANPATH="/opt/homebrew/opt/make/libexec/gnuman:$MANPATH"

      # mise handles language/tool versions when a project opts into it.
      if command -v mise >/dev/null 2>&1; then
        eval "$(mise activate zsh)"
      fi
    '';
  };
}
