{...}: {
  home.file = {
    ".config/ghostty/config".source = ../../dotfiles/ghostty/config;

    ".local/bin/ghostty-herdr" = {
      source = ../../scripts/ghostty-herdr.sh;
      executable = true;
    };
  };
}
