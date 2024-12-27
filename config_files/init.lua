-- Author: Jack Lukomski
-- TODO:
-- 1. Add tresitter -> Done
-- 2. Add telescope -> Done
-- 3. Add Harpoon
-- 4. Add LSP for python?

vim.cmd('colorscheme habamax')

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- wirectory navigation
vim.api.nvim_set_keymap('n', '<leader>d', ':Ex<CR>', { noremap = true, silent = true }) -- go to dir view

-- Window management
vim.api.nvim_set_keymap('n', '<leader>vw', ':Vex<CR>', { noremap = true, silent = true }) -- create vertial window
vim.api.nvim_set_keymap('n', '<leader>hw', ':Sex<CR>', { noremap = true, silent = true }) -- create horizontal window

 -- Move between windows
vim.api.nvim_set_keymap('n', '<leader>h', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>j', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>k', '<C-w>k', { noremap = true, silent = true })

 -- Rotate windows
vim.api.nvim_set_keymap('n', '<Leader>rw', '<C-w>r', { noremap = true, silent = true })

-- Termainal stuff
function open_terminal()
    local activate_path = "./.venv/bin/activate"
    local cmd = ":terminal"

    -- Check if the virtual environment activation file exists
    if vim.fn.filereadable(activate_path) == 1 then
	cmd = cmd .. " bash -c 'source " .. activate_path .. " && bash'"
    end

    vim.cmd(cmd)
end

function open_vertical_terminal()
    local activate_path = "./.venv/bin/activate"
    local cmd = ":Vex | terminal"

    -- Check if the virtual environment activation file exists
    if vim.fn.filereadable(activate_path) == 1 then
	    cmd = cmd .. " bash -c 'source " .. activate_path .. " && bash'"
    end

    vim.cmd(cmd)
end

vim.api.nvim_set_keymap('n', '<leader>t', ':lua open_terminal()<CR>', { noremap = true, silent = true }) -- open terminal
vim.api.nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true }) -- exit terminal mode to normal mode
vim.api.nvim_set_keymap('n', '<leader>vwt', ":lua open_vertical_terminal()<CR>", { noremap = true, silent = true })

-- Comment stuff
vim.api.nvim_set_keymap('v', '<Leader>ac', ':s/^/# /<CR>', { noremap = true, silent = true }) -- add comment
vim.api.nvim_set_keymap('v', '<Leader>uc', ':s/^# //<CR>', { noremap = true, silent = true }) -- uncomment

-- Installing lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	    {
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
		    require("nvim-treesitter.configs").setup {
			ensure_installed = { "python", "lua" },
			highlight = { enable = True },
		    }
		end,
	    },
	    {
		"nvim-telescope/telescope.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
		    require("telescope").setup()
		end,
	    },

	        {
      "github/copilot.vim",
      config = function()
      end,
    },
}})

-- Telescope keymaps
local builtin = require('telescope.builtin')

vim.keymap.set('n', '<Space>sf', builtin.find_files, {})
vim.keymap.set('n', '<Space><Space>', builtin.oldfiles, {})
vim.keymap.set('n', '<Space>sg', builtin.live_grep, {})
vim.keymap.set('n', '<Space>sh', builtin.help_tags, {})
