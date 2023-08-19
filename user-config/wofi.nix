{ config, pkgs, ... }:

{
  programs.wofi = {
    enable = true;
    settings = {
      gtk_dark = true;
      allow_markup = true;
      allow_images = true;
      show = "drun";
      define = "keyexpand=space";
      no_actions = true;
    };
    style = ''
      window {
        background: none;
      }

      #outer-box {
        border: 2px solid rgba(255, 137, 180, 0.4);
        border-radius: 10px;
        background: #1e1e2e;
      }

      #input {
        border-radius: 10px;
        padding-top: 6px;
        padding-bottom: 6px;
        font-size: 16px;
        font-weight: 700;
      }

      .entry {
        padding-top: 2px;
        padding-bottom: 2px;
      }

      #input,
      expander,
      .entry {
        padding-left: 6px;
        padding-right: 6px;
      }

      image + label {
        margin-left: 6px;
      }

      expander > .entry {
        padding-left: 0;
      }

      expander > .entry > image + label {
        margin-left: 0;
      }
    '';
  };
}
