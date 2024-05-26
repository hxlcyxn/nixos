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
      s = "status -s -b";
    };

    signing = {
      key = null;
      signByDefault = true;
    };

    delta = {
      enable = true;
      options = {};
    };

    extraConfig = {
      branch = {
        sort = "-committerdate";
      };
      column = {
        ui = "auto";
      };
      rerere = {
        enabled = true;
        autoUpdate = true;
      };
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
