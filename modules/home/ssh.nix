{...}: {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      # OpenSSH requires quotes around paths containing spaces.
      IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      ForwardAgent = "no";
      ServerAliveInterval = 30;
      ServerAliveCountMax = 3;
    };
  };
}
