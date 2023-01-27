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
    };
  };
}
