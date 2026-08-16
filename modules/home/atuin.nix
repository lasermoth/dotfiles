{...}: {
  programs.atuin = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      # Keep history local for now; no Atuin sync account or remote upload.
      auto_sync = false;

      # Avoid storing known secret patterns in the local Atuin database.
      secrets_filter = true;
      history_filter = [
        "(?i).*(password|passwd|secret|token|api[_-]?key|access[_-]?key|private[_-]?key|client[_-]?secret|bearer|authorization).*"
        "^\\s*export\\s+.*(KEY|TOKEN|SECRET|PASSWORD|PASS|AUTH).*"
        "^\\s*op\\s+signin.*"
        "^\\s*aws\\s+configure.*"
        "^\\s*gh\\s+auth\\s+token.*"
        "^\\s*npm\\s+token.*"
      ];

      search_mode = "fuzzy";
      filter_mode = "global";
      enter_accept = false;
      update_check = false;
    };
  };
}
