-- /home/rasmus/.config/nvim/init.lua

-- Set leader key early
vim.g.mapleader = " "
vim.g.maplocalleader = " "


vim.opt.termguicolors = true

require("config.lazy")

-- Core config
require('config.options')
require('config.autocmds')
require('config.keymaps')
