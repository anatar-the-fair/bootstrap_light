-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

-- ✅ Load the lazy.nvim module
local lazy = require("lazy")

-- Set the python3_host_prog variable
vim.g.python3_host_prog = os.getenv("HOME") .. "/.local/share/nvim/venv"

-- Load default plugins at startup
lazy.setup({
  rocks = {
	  enabled = false,
	  hererocks = false
  },
-- Preload missing/needed plugins manually
  { "folke/flash.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim" },

  { import = "plugins.default" },
}, 

{
  defaults = { lazy = false }, -- default plugins load eagerly
  performance = {
    rtp = {
      disabled_plugins = {
        "netrw",
        "netrwPlugin",
        "gzip",
        "tarPlugin",
        "zipPlugin",
        "getscript",
        "getscriptPlugin",
        "vimball",
        "vimballPlugin",
        "2html_plugin",
        "logiPat",
        "rrhelper",
      },
    },
  },
})

-- Set keymap to load extra keymaps and plugins
vim.keymap.set("n", "<leader>le", function()
  require("lazy").setup({ { import = "plugins.extra" } }, { once = true })
  vim.notify("Extra plugins loaded!", vim.log.levels.INFO)
end, { desc = "Load extra plugins" })
