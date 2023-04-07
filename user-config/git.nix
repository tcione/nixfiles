{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Tales Cione";
    userEmail = "talesj@gmail.com";
    aliases = {
      l = "log --pretty=oneline -n 20 --graph --abbrev-commit";
      tree = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      s = "status -s";
      tags = "tag -l";
      rn = "!r() { git rebase -i HEAD~$1; }; r";
      aa = "add --all";
      undo = "reset --hard HEAD";
      unstage = "!f() { git reset --soft HEAD~1; git reset HEAD; }; f";
      pushoc = "!f() { git push origin $(git rev-parse --abbrev-ref HEAD); }; f";
      pulloc = "!f() { git pull origin $(git rev-parse --abbrev-ref HEAD); }; f";
    };
    delta.enable = true;
    ignores = [
      "*.pyc"
      ".DS_Store"
      "Desktop.ini"
      "._*"
      "Thumbs.db"
      ".Spotlight-V100"
      ".Trashes"
      ".extra"
      "!.gitkeep"
      "tmux-client*.log"
      "*.swp"
      "__gitignore_*"
      "__todo.txt"
      "vim/.netrwhist"
    ];
  };
}
