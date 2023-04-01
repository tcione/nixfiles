{ config, pkgs, ... }:

{
  home.username = "tortoise";
  home.homeDirectory = "/home/tortoise";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs.unstable; [
    exa
    neovim
  ];

  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    withNodeJs = false;

    extraPackages = with pkgs; [
      unstable.nodePackages.bash-language-server
      unstable.nodePackages.typescript
      unstable.nodePackages.typescript-language-server
      unstable.nodePackages.yaml-language-server
      unstable.rubyPackages.solargraph
      unstable.shellcheck
      unstable.rust-analyzer
      unstable.rnix-lsp
      unstable.nil
      gnumake
    ];

    plugins = with pkgs.unstable.vimPlugins; [
      nvim-treesitter.withAllGrammars

      # Telescope
      plenary-nvim
      {
        plugin = telescope-nvim;
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
          lspconfig.rnix.setup{on_attach=on_attach}
        '';
      }

      # Complete
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      {
        plugin = nvim-cmp;
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
        config = "colorscheme captppuccin";
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
}
