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
    nmap("tt", ":NERDTreeFind<CR>")
  '';
in {
  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;

      # make sure that vi or vim also points to nvim
      viAlias = true;
      vimAlias = true;
      
      # auto-completion
      coc.enable = true;

      # plugins to use within the editor
      plugins = with pkgs.vimPlugins; [
        vim-nix               # helps formatting nix files
        indent-blankline-nvim # indent guide lines
        nerdtree              # file explorer
      ];
      
      extraLuaConfig = utils + keymaps;
    };
  };
}
