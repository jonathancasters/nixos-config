#
# Neovim configuration file
#

{ pkgs, ... }:

let
  # custom lua code to make remapping easier
  utils = ''
    -- vim options
    local o = vim.o
    -- vim global variables
    local g = vim.g

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


    -- COC-SETTINGS
    -- To support docker-compose auto-completion
    vim.api.nvim_exec([[
      augroup FileTypeYaml
        autocmd!
        autocmd FileType yaml if vim.fn.expand('%:t') == 'docker-compose.yml' | setlocal filetype=yaml.docker-compose | endif
        autocmd FileType yaml if vim.fn.expand('%:t') == 'compose.yml' | setlocal filetype=yaml.docker-compose | endif
      augroup END
    ]], false)

    g.coc_filetype_map = {
      ['yaml.docker-compose'] = 'dockercompose',
    }

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
  '';
in {

  home.packages = with pkgs; [
    # install language server to enable auto-completion on docker-compose files
    docker-compose-language-service
    nixd
    #kotlin-language-server
    #haskell-language-server
  ];

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;

      # make sure that vi or vim also points to nvim
      viAlias = true;
      vimAlias = true;
      
      # auto-completion
      coc.enable = true;
      coc.settings = {
        "languageserver" = {
          nix = {
            command = "nixd";
            filetypes = ["nix"];
          };
          dockerfile = {
            command = "docker-langserver";
            filetypes = ["dockerfile"];
            args = ["--stdio"];
          };
          dockercompose = {
            command = "docker-compose-langserver";
            args = ["--stdio"];
            filetypes = ["dockercompose"];
            rootPatterns = [".git" ".env" "docker-compose.yml" "compose.yml"];
          };
#          haskell = {
#            command = "haskell-language-server-wrapper";
#            args = [ "--lsp" ];
#            rootPatterns = [
#              "*.cabal"
#              "stack.yaml"
#              "cabal.project"
#              "package.yaml"
#              "hie.yaml"
#            ];
#            filetypes = [ "haskell" "lhaskell" ];
#          };
#          kotlin = {
#            command = "kotlin-language-server";
#            filetypes = ["kotlin"];
#          };
        };
      };

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
        coc-cmake                       # auto-completion for cmake
        coc-clangd                      # auto-completion for c/c++
        coc-sh                          # auto-completion for bash 
        coc-python                      # auto-completion for python
        coc-json                        # auto-completion json
        coc-prettier                    # formatting
        #coc-java                        # auto-completion java
        #coc-tsserver                    # auto-completion javascript / typescript
      ];
      
      extraLuaConfig = utils + keymaps + plugin-config + theme;
    };
  };
}
