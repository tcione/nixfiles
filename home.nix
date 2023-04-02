{ config, pkgs, ... }:

{
  home.username = "tortoise";
  home.homeDirectory = "/home/tortoise";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    exa
    bat
    fd
    bottom

    spotify
    gimp-with-plugins

    # Desktop
    # - Notifications
    wofi
    glib
    libnotify
  ];

  # ========================================
  # == Start: DESKTOP
  # ========================================

  services.dunst = {
    enable = true;
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
      size = "64x64";
    };
    settings = {
      global = {
        monitor = 0;
        follow = "none";
        width = 370;
        height = 370;
        origin = "top-right";
        offset = "10x10";
        scale = 0;
        notification_limit = 0;
        progress_bar = true;
        progress_bar_height = 12;
        progress_bar_frame_width = 0;
        progress_bar_min_width = 362;
        progress_bar_max_width = 362;
        progress_bar_corner_radius = 0;
        highlight = "#FFFFFFFF";
        indicate_hidden = "yes";
        transparency = 0;
        separator_height = 2;
        padding = 8;
        horizontal_padding = 8;
        text_icon_padding = 0;
        frame_width = 1;
        frame_color = "#77777780";
        gap_size = 4;
        separator_color = "frame";
        sort = "yes";
        font = "Noto Sans 10";
        line_height = 0;
        markup = "full";
        format = "<b>%s</b>\n%b";
        alignment = "left";
        vertical_alignment = "center";
        show_age_threshold = 60;
        ellipsize = "middle";
        ignore_newline = "no";
        stack_duplicates = true;
        hide_duplicate_count = false;
        show_indicators = "yes";
        sticky_history = "yes";
        history_length = 20;
        dmenu = "/usr/bin/dmenu -p dunst:";
        browser = "/usr/bin/xdg-open";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 5;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "close_current";
        mouse_middle_click = "do_action, close_current";
        mouse_right_click = "close_all";
      };
      experimental = { per_monitor_dpi = false; };
      urgency_low = {
        background = "#313244DF";
        foreground = "#CDD6F4";
        frame_color = "#45475ADF";
        timeout = 10;
      };
      urgency_normal = {
        background = "#313244DF";
        foreground = "#CDD6F4";
        frame_color = "#45475ADF";
        timeout = 10;
      };
      urgency_critical = {
        background = "#F38BA8DF";
        foreground = "#CDD6F4";
        frame_color = "#F2CDCDDF";
        timeout = 0;
      };
      category_progress = {
        category = "progress";
        width = 500;
        height = 500;
        origin = "center-center";
        offset = "0x0";
      };
    };
  };

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 52.52;
    longitude = 13.40;
    settings = {
      general = {
        adjustment-method = "wayland";
        fade = 1;
      };
    };
    temperature = {
      day = 6500;
      night = 2800;
    };
    tray = true;
  };

  # ========================================
  # == End: DESKTOP
  # ========================================


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

  programs.tmux = {
    enable = true;
    prefix = "C-a";
    clock24 = true;
    escapeTime = 0;
    keyMode = "vi";
    mouse = true;
    newSession = true;
    sensibleOnTop = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      tmux-fzf
      fzf-tmux-url
      {
        plugin = prefix-highlight;
        extraConfig = ''
          set -g @prefix_highlight_fg '#A6E3A1'
          set -g @prefix_highlight_bg '#1E1E2E'
        '';
      }
      {
        plugin = tmux-thumbs;
        extraConfig = ''
          set -g @thumbs-command 'echo -n {} | wl-copy'
        '';
      }
    ];
    extraConfig = ''
      set -g status-left-length 32
      set -g status-right '#{prefix_highlight} | %a %h-%d %H:%M'
      set -g status-style fg=#A6E3A1,bg=#1E1E2E

      set-option -g allow-rename off
      bind-key c new-window -c '#{pane_current_path}'
      bind | split-window -h -c '#{pane_current_path}'
      bind - split-window -v -c '#{pane_current_path}'
      unbind '"'
      unbind %

      # vim-like pane switching
      bind -r ^ last-window
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R

      bind-key -r H run-shell "~/.local/bin/tmux-init"
      unbind C
      bind-key -r C run-shell "tmux neww ~/.local/bin/tmux-sessionizer.sh"
    '';
  };

  home.file."./.local/bin/tmux-init.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      tmux-safe-switch.sh "home" "$HOME"
    '';
  };

  home.file."./.local/bin/tmux-sessionizer.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      # Taken from https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/bin/tmux-sessionizer

      if [[ $# -eq 1 ]]; then
        selected=$1
      else
        selected=$(find ~/Projects -mindepth 1 -maxdepth 1 -type d | fzf)
      fi

      if [[ -z $selected ]]; then
        exit 0
      fi

      selected_name=$(basename "$selected" | tr . _)

      tmux-safe-switch.sh "$selected_name" "$selected"
    '';
  };

  home.file."./.local/bin/tmux-safe-switch.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash

      session_name="$1"
      session_dir="$2"
      tmux_running=$(pgrep tmux)

      if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s "$session_name" -c "$session_dir"
        exit 0
      fi

      if ! tmux has-session -t "$session_name" 2> /dev/null; then
        tmux new-session -ds "$session_name" -c "$session_dir"
      fi

      if [[ -z $TMUX ]]; then
        tmux attach -t "$session_name"
      else
        tmux switch-client -t "$session_name"
      fi
    '';
  };

  programs.kitty = {
    enable = true;
    theme = "Catppuccin-Mocha";
    font = {
      package = pkgs.fira-code-symbols;
      name = "Fira Code Medium";
      size = 12;
    };
    keybindings = {
      "ctrl+." = "next_tab";
      "ctrl+," = "previous_tab";
      "ctrl+t" = "new_tab_with_cwd";
      "ctrl+0" = "goto_tab 1";
      "ctrl+1" = "goto_tab 2";
      "ctrl+2" = "goto_tab 3";
      "ctrl+3" = "goto_tab 4";
      "ctrl+4" = "goto_tab 5";
    };
    settings = {
      adjust_line_height = "100%";
      cursor_blink_interval = "0";
      window_padding_width = "5";
      hide_window_decorations = "no";
      remember_window_size = "no";
      initial_window_width = "1000";
      initial_window_height = "650";
      enable_audio_bell = "no";
      confirm_os_window_close = "10";
      tab_separator = "|";
      tab_bar_margin_width = "0.0";
      tab_bar_style = "separator";
    };
  };

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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.command-not-found.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    defaultKeymap = "viins";
    initExtra = ''
      export PATH="$PATH:$HOME/.local/bin"
    '';
    profileExtra = ''
      export EDITOR='vim'

      if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        export SDL_VIDEODRIVER=wayland
        export MOZ_ENABLE_WAYLAND=1
        export GTK_THEME=Dracula
        export XDG_CURRENT_DESKTOP=Hyprland
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=Hyprland
        export QT_AUTO_SCREEN_SCALE_FACTOR=1
        export QT_QPA_PLATFORM="wayland;xcb"
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        export QT_QPA_PLATFORMTHEME=qt5ct
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONEREPARENTING=1
        export CLUTTER_BACKEND="wayland"
        # export GDK_BACKEND="wayland"

        eval $(gnome-keyring-daemon -sd)
        export SSH_AUTH_SOCK

        exec Hyprland
      fi
    '';
  };

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    extraPackages = with pkgs; [
      nodePackages.bash-language-server
      nodePackages.typescript
      nodePackages.typescript-language-server
      nodePackages.yaml-language-server
      rubyPackages.solargraph
      shellcheck
      rust-analyzer
      rnix-lsp
      nil
      gnumake
    ];

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-treesitter.withAllGrammars;
        type = "lua";
        config = ''
          require'nvim-treesitter.configs'.setup({
            highlight = { enable = true }
          })
        '';
      }

      # Telescope
      plenary-nvim
      {
        plugin = telescope-nvim;
        type = "lua";
        config = ''


          local actions = require('telescope.actions')
          local telescope = require('telescope')
          telescope.load_extension('fzf')
          telescope.setup({
            defaults = {
              mappings = {
                i = {
                  ["<C-j>"] = actions.move_selection_next,
                  ["<C-k>"] = actions.move_selection_previous,
                },
              },
            }
          })
        '';
      }
      telescope-fzf-native-nvim

      # LSP
      {
        plugin = lsp-colors-nvim;
        type = "lua";
        config = ''
          require("lsp-colors").setup({
            Error = "#db4b4b",
            Warning = "#e0af68",
            Information = "#0db9d7",
            Hint = "#10B981"
          })
        '';
      }
      {
        plugin = trouble-nvim;
        type = "lua";
        config = ''
          require("trouble").setup({
            fold_open = "v",
            fold_closed = ">",
            indent_lines = true,
            icons = false,
            signs = {
                error = "error",
                warning = "warn",
                hint = "hint",
                information = "info"
            },
            use_lsp_diagnostic_signs = false
          })
        '';
      }
      {
        plugin = nvim-lspconfig;
        type = "lua";
        config = ''
          local nvim_lsp = require('lspconfig')

          local on_lsp_attach = function(client, bufnr)
            local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
            local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

            -- Enable completion triggered by <c-x><c-o>
            buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

            -- Mappings.
            local opts = { noremap=true, silent=true }

            -- See `:help vim.lsp.*` for documentation on any of the below functions
            buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
            buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
            buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
            buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
            buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
            buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
            buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
            buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
            buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
            buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
            buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
            buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
            buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
            buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
            buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
            buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
          end

          -- Enable LSP servers
          local capabilities = vim.lsp.protocol.make_client_capabilities()
          capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

          nvim_lsp.solargraph.setup({
            cmd = { "solargraph", "stdio" },
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.tsserver.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.rust_analyzer.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.bashls.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.rnix.setup{on_attach=on_attach}
        '';
      }

      # Complete
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp = require('cmp')

          cmp.setup({
            mapping = {
              ["<C-k>"] = cmp.mapping.select_prev_item(),
              ["<C-j>"] = cmp.mapping.select_next_item(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.close(),
              ["<Tab>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }),
            },
            sources = {
              { name = 'nvim_lsp' },
              { name = 'path' },
              { name = 'buffer' },
            }
          })
        '';
      }

      # Random
      {
        plugin = vim-test;
        config = ''
          let g:test#strategy = 'neovim'
          let g:test#neovim#start_normal = 1
        '';
      }
      {
        plugin = lualine-nvim;
        type = "lua";
        config = ''
          require'lualine'.setup({
            options = { theme = 'jellybeans' }
          })
        '';
      }
      {
        plugin = vim-hexokinase;
        config = ''
          let g:Hexokinase_highlighters = ['backgroundfull']
        '';
      }
      {
        plugin = catppuccin-nvim;
        type = "lua";
        config = ''
          require("catppuccin").setup({})
          vim.cmd.colorscheme "catppuccin"
        '';
      }
      {
        plugin = nerdcommenter;
        config = ''
          let g:NERDDefaultAlign = 'left'
          let g:NERDSpaceDelims = 1
        '';
      }
      quickfix-reflector-vim
      vim-eunuch
      vim-fugitive
      vim-vinegar
      BufOnly-vim
      PreserveNoEOL
    ];

    extraConfig = ''
      function! DeleteTrailingWhiteSpace()
        exe "normal mz"
        %s/\s\+$//ge
        exe "normal `z"
      endfunc

      let mapleader = ","
      let g:mapleader = ","
      let maplocalleader = "\\"

      filetype plugin indent on

      set exrc
      set guicursor=
      set relativenumber
      set hidden
      set number
      set noswapfile
      set nobackup
      set nowritebackup
      set undodir=~/.vim/undodir
      set undofile
      set incsearch
      set scrolloff=8
      set expandtab
      set smarttab
      set shiftwidth=2
      set tabstop=2
      set autoindent
      set smartindent
      " set wrap
      " set wrapmargin=2
      set noerrorbells
      set novisualbell
      set colorcolumn=80
      set signcolumn=yes
      set termguicolors
      set autoread
      set clipboard=unnamedplus
      set noshowcmd
      set encoding=utf8
      set ffs=unix,dos,mac
      set backspace=eol,start,indent
      set whichwrap+=<,>,h,l
      set hlsearch
      set showmatch
      set timeoutlen=500
      set synmaxcol=1000
      set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
      set list
      set breakindent
      set breakindentopt=shift:2,min:40,sbr
      set linebreak
      set shada^=%
      set completeopt=menu,menuone,noselect
      set laststatus=3

      " =========================================
      " Mappings
      " =========================================
      nmap <leader>w :w!<cr>
      map 0 ^
      map <space> /
      map <c-space> ?
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l

      nnoremap <leader>p <cmd>Telescope find_files<cr>
      nnoremap ; <cmd>Telescope buffers<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fh <cmd>Telescope help_tags<cr>

      " =========================================
      " Initialization commands
      " =========================================
      augroup tcione
        autocmd!
        autocmd BufWrite * :call DeleteTrailingWhiteSpace()
        " Return to last edit position when opening files
        autocmd BufReadPost *
             \ if line("'\"") > 0 && line("'\"") <= line("$") |
             \   exe "normal! g`\"" |
             \ endif
      augroup END

      augroup highlight_yank
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=700}
      augroup END
    '';
    extraLuaConfig = ''
    '';
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      catppuccin-vim
    ];
    extraConfig = ''
      """""""""""""""""""""""""""""""""""""
      " Minimal vim config, since I've migrated
      " fully to neovim
      """"""""""""""""""""""""""""""""""""""

      " Remap leader for nice combos
      let mapleader = ","
      let g:mapleader = ","
      let maplocalleader = "\\"
      let base16colorspace=256

      filetype off
      syntax enable
      colorscheme catppuccin_mocha

      highlight OverLength ctermbg=red ctermfg=white guibg=#592929
      match OverLength /\%81v.\+/

      set undodir=~/.vim/undodir
      set relativenumber
      set exrc
      set termguicolors
      set nocompatible
      set maxmempattern=5000
      set history=700
      set autoread
      set clipboard=unnamed
      set t_Co=256
      set termguicolors
      set noruler
      set noshowcmd
      set encoding=utf8
      set ffs=unix,dos,mac
      set nobackup
      set nowb
      set noswapfile
      set number
      set backspace=eol,start,indent
      set whichwrap+=<,>,h,l
      set hlsearch
      set showmatch
      set noerrorbells
      set novisualbell
      set colorcolumn=80
      set t_vb=
      set tm=500
      set synmaxcol=1000
      set laststatus=2
      set listchars=eol:¬,tab:>-,trail:~,extends:>,precedes:<
      set list
      set expandtab
      set smarttab
      set shiftwidth=2
      set tabstop=2
      set autoindent
      set smartindent
      set wrap
      set breakindent
      set breakindentopt=shift:2,min:40,sbr
      set linebreak
      set tw=1000
      set wm=2
      set viminfo^=%
      set scrolloff=8

      nmap <leader>w :w!<cr>
      map 0 ^
      map <space> /
      map <c-space> ?
      map <C-j> <C-W>j
      map <C-k> <C-W>k
      map <C-h> <C-W>h
      map <C-l> <C-W>l
      map <C-k><C-b> :Explore<cr>
      map - :Explore<cr>
      map <leader>fi g=GG
      map <leader>cd :cd %:p:h<cr>:pwd<cr>
    '';
  };
}
