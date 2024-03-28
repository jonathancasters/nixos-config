#
# Neovim configuration file
#

{ config, lib, pkgs, user, ... }:

let
  # custom lua code to make remapping easier
  utils = ''
    -- vim options
    local o = vim.o
    -- vim global variables
    local g = vim.g
    -- vim api
    local api = vim.api

    -- utility function that helps remapping keys to commands
    function map(mode, keys, command)
      vim.api.nvim_set_keymap(mode, keys, command, {
        silent = true;
        noremap = true;
      })
    end

    nmap = function(keys, command) map("n", keys, command) end
    imap = function(keys, command) map("i", keys, command) end
    vmap = function(keys, command) map("v", keys, command) end
    tmap = function(keys, command) map("t", keys, command) end
  '';

  # custom lua code with key bindings
  keymaps = ''
    -- map leader to space
    g.mapleader = " "

    imap("jk", "<Esc>")
    
    -- write/quit shorts
    nmap("<leader>w", ":w<CR>")
    nmap("<leader>q", ":q<CR>")
    nmap("<leader>fq", ":q!<CR>")

    -- navigate splits
    nmap("<leader>h", ":wincmd h<CR>")
    nmap("<leader>j", ":wincmd j<CR>")
    nmap("<leader>k", ":wincmd k<CR>")
    nmap("<leader>l", ":wincmd l<CR>")

    -- remap arrow keys to make them resize splits
    nmap("<Up>", ":resize +5<CR>")
    nmap("<Down>", ":resize -5<CR>")
    nmap("<Right>", ":vertical resize +5<CR>")
    nmap("<Left>", ":vertical resize -5<CR>")

    nmap("<S-Up>", ":resize +1<CR>")
    nmap("<S-Down>", ":resize -1<CR>")
    nmap("<S-Right>", ":vertical resize +1<CR>")
    nmap("<S-Left>", ":vertical resize -1<CR>")

    -- tab management
    nmap("<leader>ee", ":$tabnew<CR>")
    nmap("<leader>eL", ":tabnew<CR>")
    nmap("<leader>eH", ":-tabnew<CR>")
    nmap("<leader>el", ":tabnext<CR>")
    nmap("<leader>eh", ":tabprevious<CR>")
    nmap("<leader>eq", ":tabclose<CR>")

    -- file explorer 
    nmap("<leader>fe", ":NvimTreeToggle<CR>")
  '';
  # plugin settings
  plugin-config = ''
    -- NVIM-TREE SETTINGS
    -- disable netrw
    g.loaded_netrw = 1
    g.loaded_netrwPlugin = 1
    -- set termguicolors to enable highlight groups
    vim.opt.termguicolors = true
    -- empty setup using defaults
    require("nvim-tree").setup()
    -- enable icons in tree
    require("nvim-web-devicons").setup()
    -- ENABLE PLUGINS
    vim.o.number = true
    
    require('gitsigns').setup()
    require('ibl').setup()
  '';

  # custom theming
  theme = ''
    -- enable intigrations
    require("catppuccin").setup({
      integrations = {
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
      }
    })

    vim.cmd.colorscheme "catppuccin-latte"

    o.tabstop = 4
    o.shiftwidth = 4
  '';

  # language servers
  # https://vonheikemen.github.io/devlog/tools/setup-nvim-lspconfig-plus-nvim-cmp/
  language-servers = ''
    local lspconfig = require('lspconfig')
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()

    -- C/C++
    lspconfig.clangd.setup({
      capabilities = lsp_capabilities,
    })
    -- Nix
    lspconfig.nixd.setup({
      capabilities = lsp_capabilities,
    })
    -- Python
    lspconfig.pyright.setup({
      capabilities = lsp_capabilities,
    })

    api.nvim_create_autocmd('LspAttach', {
      desc = 'LSP actions',
      callback = function()
        local bufmap = function(mode, lhs, rhs)
          local opts = {buffer = true}
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Displays hover information about the symbol under the cursor
        bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')

        -- Jump to the definition
        bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

        -- Jump to declaration
        bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

        -- Lists all the implementations for the symbol under the cursor
        bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

        -- Jumps to the definition of the type symbol
        bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

        -- Lists all the references 
        bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

        -- Displays a function's signature information
        bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

        -- Renames all references to the symbol under the cursor
        bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

        -- Selects a code action available at the current cursor position
        bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

        -- Show diagnostics in a floating window
        bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

        -- Move to the previous diagnostic
        bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

        -- Move to the next diagnostic
        bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
      end
    })

    -- Configure nvim-cmp and luasnip
    vim.opt.completeopt = {'menu', 'menuone', 'noselect'}

    require('luasnip.loaders.from_vscode').lazy_load()

    local cmp = require('cmp')
    local luasnip = require('luasnip')

    local select_opts = {behavior = cmp.SelectBehavior.Select}

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end
      },
      sources = {
        {name = 'path'},
        {name = 'nvim_lsp', keyword_length = 1},
        {name = 'buffer', keyword_length = 3},
        {name = 'luasnip', keyword_length = 2},
      },
      window = {
        documentation = cmp.config.window.bordered()
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = 'λ',
            luasnip = '⋗',
            buffer = 'Ω',
            path = '🖫',
          }

          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
      mapping = {
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
        ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),

        ['<C-e>'] = cmp.mapping.abort(),
        ['<C-y>'] = cmp.mapping.confirm({select = true}),
        ['<CR>'] = cmp.mapping.confirm({select = false}),

        ['<C-f>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(1) then
            luasnip.jump(1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<C-b>'] = cmp.mapping(function(fallback)
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, {'i', 's'}),

        ['<Tab>'] = cmp.mapping(function(fallback)
          local col = vim.fn.col('.') - 1

          if cmp.visible() then
            cmp.select_next_item(select_opts)
          elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
            fallback()
          else
            cmp.complete()
          end
        end, {'i', 's'}),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item(select_opts)
          else
            fallback()
          end
        end, {'i', 's'}),
      },
    })
  '';
in {
  options.${user}.development.nvim.enable = lib.mkOption {
    default = false;
    example = true;
  };

  config = lib.mkIf config.${user}.development.docker.enable {

    home-manager.users.${user} = { ... } : {
      home.packages = with pkgs; [
        nixd
        llvmPackages_15.clang-unwrapped
        nodePackages.pyright
      ];

      programs = {
        neovim = {
          enable = true;
          defaultEditor = true;

          # make sure that vi or vim also points to nvim
          viAlias = true;
          vimAlias = true;

          # plugins to use within the editor
          plugins = with pkgs.vimPlugins; [
            vim-nix                         # helps formatting nix files
            vim-numbertoggle                # automatic switching between absolute and relative line numbers
            indent-blankline-nvim           # indent guide lines
            nvim-tree-lua                   # file explorer
            nvim-web-devicons               # icons in file explorer
            catppuccin-nvim                 # theming
            gitsigns-nvim                   # indicate git changes
            nvim-treesitter.withAllGrammars # syntax highlighting
            nvim-lspconfig                  # language server
            nvim-cmp                        # code completion
            cmp-buffer                      # nvim-cmp source for buffer words
            cmp-path                        # nvim-cmp source for filesystem paths
            cmp-nvim-lsp                    # nvim-cmp source for neovim's built-in language server client
            friendly-snippets               # Snippets collection for a set of different programming languages
            luasnip                         # Snip engine
          ];
          
          extraLuaConfig = utils + keymaps + plugin-config + theme + language-servers;
        };
      };
    };
  };
}
