{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "quitte" = {
        hostname = "quitte.ifsr.de";
        user = "root";
        port = 22;
      };
      "harbinger" = {
        hostname = "harbinger";
        port = 22;
      };
      "mononome" = {
          hostname = "ssh.monono.me";
          user = "root";
          port = 22;
        };
    };
  };
}
