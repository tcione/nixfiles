{ config, pkgs, ... }:

{
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
      nil
      gnumake
      clang-tools
      gopls
      nodePackages_latest.vscode-langservers-extracted
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
          capabilities.textDocument.completion.completionItem.snippetSupport = true
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
          nvim_lsp.clangd.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.svelte.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.gopls.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          nvim_lsp.html.setup({
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
        '';
      }

      # Snippets
      friendly-snippets
      {
        plugin = luasnip;
        type = "lua";
        config = ''
          require("luasnip.loaders.from_vscode").lazy_load()
        '';
      }

      # Complete
      cmp-buffer
      cmp-nvim-lsp
      cmp-path
      cmp_luasnip
      {
        plugin = nvim-cmp;
        type = "lua";
        config = ''
          local cmp_has_words_before = function()
            unpack = unpack or table.unpack
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
          end

          local cmp = require('cmp')
          local luasnip = require('luasnip')

          cmp.setup({
            snippet = {
              expand = function(args)
                require('luasnip').lsp_expand(args.body)
              end,
            },
            mapping = {
              ["<C-k>"] = cmp.mapping.select_prev_item(),
              ["<C-j>"] = cmp.mapping.select_next_item(),
              ["<C-d>"] = cmp.mapping.scroll_docs(-4),
              ["<C-f>"] = cmp.mapping.scroll_docs(4),
              ["<C-Space>"] = cmp.mapping.complete(),
              ["<C-e>"] = cmp.mapping.close(),
              ["<C-CR>"] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
              }),
              ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.confirm()
                elseif luasnip.expand_or_jumpable() then
                  luasnip.expand_or_jump()
                elseif cmp_has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end, { "i", "s" }),
              ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                  cmp.confirm()
                elseif luasnip.jumpable(-1) then
                  luasnip.jump(-1)
                else
                  fallback()
                end
              end, { "i", "s" }),
            },
            sources = {
              { name = 'luasnip' },
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
      {
        plugin = zen-mode-nvim;
        type = "lua";
        config = ''
          require("zen-mode").setup({
            window = {
              backdrop = 1,
              width = 80,
              height = 1,
              options = {
                signcolumn = "no",
                number = false,
                colorcolumn = "",
              },
            },
            plugins = {
              options = {
                enabled = true,
                ruler = true,
                showcmd = false,
                relativenumber = false,
                spell = true,
              },
              kitty = {
                enabled = false,
                font = "+4",
              },
            },
            on_open = function(win)
            end,
            on_close = function()
            end,
          })
        '';
      }
      quickfix-reflector-vim
      vim-eunuch
      vim-fugitive
      vim-vinegar
      BufOnly-vim
      PreserveNoEOL
      ferret
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
