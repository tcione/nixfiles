{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autocd = true;
    defaultKeymap = "viins";
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin"
    '';
    profileExtra = ''
      export EDITOR='vim'

      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        eval $(gnome-keyring-daemon -sd)
        export SSH_AUTH_SOCK=~/.1password/agent.sock
        systemctl --user import-environment PATH

        exec Hyprland
      fi
    '';
  };
}
