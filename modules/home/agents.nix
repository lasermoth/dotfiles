{...}: {
  # Global coding-agent instructions. Keep the source outside the repository
  # root so this dotfiles repo can still have its own project-local AGENTS.md.
  home.file = {
    # Pi global context file: https://pi.dev
    ".pi/agent/AGENTS.md".source = ./AGENTS.md;

    # opencode global rules file.
    ".config/opencode/AGENTS.md".source = ./AGENTS.md;

    # OpenAI Codex CLI global instructions.
    ".codex/AGENTS.md".source = ./AGENTS.md;

    # Common non-AGENTS.md equivalents for tools that use their own filename.
    ".claude/CLAUDE.md".source = ./AGENTS.md;
    ".gemini/GEMINI.md".source = ./AGENTS.md;
  };
}
