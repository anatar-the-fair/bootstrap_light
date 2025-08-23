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
vim.g.python3_host_prog = "/usr/bin/python3"
-- Or you can use a custom environment like this
-- vim.g.python3_host_prog = os.getenv("HOME") .. "/.local/share/venv/nvim"

-- I know what I am doing :)
vim.g.lazyvim_check_order = false 

-- Load default plugins at startup
lazy.setup({
  -- 1. Optionally load LazyVim extras (examples, customize as needed)
  -- { import = "lazyvim.plugins.extras.lang.typescript" },
  -- { import = "lazyvim.plugins.extras.coding.copilot" },

  -- 2. Preload any specific plugins
  { "folke/flash.nvim" },
  { "nvim-lualine/lualine.nvim" },
  { "nvim-telescope/telescope.nvim" },

  -- 3. Your own plugin specs
  { import = "plugins.default" },
  { import = "plugins.default.colorschemes" },
}, {
  defaults = { lazy = false },
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
