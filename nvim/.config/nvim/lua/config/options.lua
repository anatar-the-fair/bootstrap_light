vim.g.loaded_perl_provider = 0

vim.g.mapleader = " "

local opt = vim.opt

opt.timeout = true
-- Default neovim is 1,000 but lazyvim sets it to 300
opt.timeoutlen = 1000

opt.laststatus = 2
opt.statusline = "%m"

-- Indentation
opt.smartindent = true

---- Important Grammar and spell check
opt.spelllang = "en_us"
opt.spell = true
opt.spellfile= "~/.local/share/dictionaries/en.utf-8.add"

-- Search
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.completeopt = "menuone,noselect"

-- Apperance
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cmdheight = 1
opt.scrolloff = 0
opt.fillchars:append { eob = " " }  -- eob = end-of-buffer
opt.colorcolumn = ""

-- Autocommand to apply settings for markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		-- Statusline settings
		opt.laststatus = 2
		opt.statusline = "%m"

		-- Line numbers
		opt.number = true
		opt.relativenumber = true

		-- Disable the gutter
		opt.signcolumn = "no"

		-- Text width and wrapping
		opt.textwidth = 80
		opt.linebreak = false
		opt.wrap = true

		-- No colorcolumn
		opt.colorcolumn = ""
	end,
})

-- Settings for non-markdown files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		-- Only apply these settings if the filetype is not markdown
		if vim.bo.filetype ~= "markdown" then
			opt.relativenumber = true
			opt.textwidth = 80
			opt.wrap = true
			opt.colorcolumn = ""
		end
	end,
})

-- Behaviour
opt.hidden = true
opt.errorbells = false
--opt.backspace = "indent, eol, start"
opt.splitright = true
opt.splitbelow = true
opt.autochdir = false
opt.iskeyword:append("a")
opt.clipboard:append("unnamedplus")
opt.modifiable = true
--opt.guicursor = true
opt.encoding = "UTF-8"

opt.conceallevel = 0

-- Show LSP diagnostics (inlay hints) in a hover window / popup
-- Time it takes to show the popup after you hover over the line with an error
vim.o.updatetime = 200

-- Use wl-copy and wl-paste for system clipboard integration on Wayland
vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --type text/plain",
  },
  paste = {
    ["+"] = "wl-paste --no-newline",
    ["*"] = "wl-paste --no-newline",
  },
  cache_enabled = true,
}


