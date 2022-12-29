{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "halcyon";
    userEmail = "55317573+hxlcyxn@users.noreply.github.com";

    aliases = {
      aa = "add .";
      cm = "commit -m";
    };

    signing = {
      key = null;
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {};
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enabled";
      aliases = {
        co = "pr checkout";
      };
    };
    extensions = with pkgs; [
      gh-dash
      # no package for:
      # gh-poi
      # gh-markdown-preview
    ];
  };
}
