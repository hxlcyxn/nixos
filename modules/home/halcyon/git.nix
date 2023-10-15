{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "halcyon";
    userEmail = "55317573+hxlcyxn@users.noreply.github.com";

    aliases = {
      a = "add";
      aa = "add .";
      cm = "commit -m";
      p = "pull";
      s = "status -s";
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
  home.shellAliases = {g = "git";};

  programs.gh = {
    enable = true;
    gitCredentialHelper = {
      enable = true;
    };
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
