{
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$character";
      right_format = "$git_status$git_branch";
      add_newline = false;
      character = {
        success_symbol = "[|](bold blue)";
        error_symbol = "[|](bold red)";
        vimcmd_symbol = "[¦](bold blue)";
        vimcmd_replace_one_symbol = "[¦](bold red)";
        vimcmd_replace_symbol = "[¦](bold red)";
        vimcmd_visual_symbol = "[¦](bold purple)";
      };

      directory = {
        format = "[$read_only]($read_only_style)[$path]($style) ";
        style = "bold blue";
        read_only_style = "bold red";
        truncation_length = 1;
        truncate_to_repo = false;
        read_only = "[RO] ";
      };

      git_status = {
        format = " ([\\[$all_status$ahead_behindi\\]]($style))";
        style = "bold red";
        ahead = ">";
        behind = "<";
        diverged = "<>";
        renamed = "r";
        deleted = "x";
      };

      git_branch = {
        format = " @ [$symbol$branch]($style)";
        style = "bold purple";
        symbol = "";
      };
    };
  };
}
