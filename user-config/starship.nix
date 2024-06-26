{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      # Don't print a new line at the start of the prompt
      add_newline = false;
      # Disable the package module, hiding it from the prompt completely
      package = { disabled = true; };
      git_branch = { truncation_length = 32; };
    };
  };
}
