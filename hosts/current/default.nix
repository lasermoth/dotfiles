{
  hostname,
  username,
  ...
}: {
  imports = [
    ../../modules/darwin/homebrew.nix
    ../../modules/darwin/system.nix
    ../../modules/home
  ];

  networking = {
    computerName = hostname;
    hostName = hostname;
    localHostName = hostname;
  };

  system.primaryUser = username;
}
