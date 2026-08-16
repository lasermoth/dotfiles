{...}: {
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = true;
      command_timeout = 1000;

      format = "$directory$git_branch$git_status$nix_shell$nodejs$python$rust$golang$cmd_duration$line_break$character";

      palette = "catppuccin_mocha";

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        overlay0 = "#6c7086";
        surface0 = "#313244";
        base = "#1e1e2e";
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };

      directory = {
        style = "bold blue";
        truncation_length = 4;
        truncate_to_repo = false;
      };

      git_branch = {
        symbol = " ";
        style = "bold mauve";
      };

      git_status = {
        style = "bold peach";
        format = "([$all_status$ahead_behind]($style) )";
      };

      nix_shell = {
        symbol = " ";
        style = "bold blue";
      };

      cmd_duration = {
        min_time = 500;
        style = "yellow";
        format = "took [$duration]($style) ";
      };
    };
  };
}
