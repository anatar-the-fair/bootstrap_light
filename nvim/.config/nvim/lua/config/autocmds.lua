-- Filename: ~/.config/nvim/lua/config/autocmds.lua

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- close some filetypes with <esc>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "grug-far",
    "help",
    "lspinfo",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "dbout",
    "gitsigns-blame",
    "Lazy",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "<esc>", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})


-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
  callback = function()
    -- -- By default wrap is set to true regardless of what I chose in my options.lua file,
    -- -- This sets wrapping for my skitty-notes and I don't want to have
    -- -- wrapping there, I wanto to decide this in the options.lua file
    -- vim.opt_local.wrap = false
    vim.opt_local.spell = true
  end,
})

-- Show LSP diagnostics (inlay hints) in a hover window / popup lamw26wmal
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
-- https://www.reddit.com/r/neovim/comments/1168p97/how_can_i_make_lspconfig_wrap_around_these_hints/
-- If you want to increase the hover time, modify vim.o.updatetime = 200 in your
-- options.lua file
--
-- -- In case you want to use custom borders
-- local border = {
--   { "🭽", "FloatBorder" },
--   { "▔", "FloatBorder" },
--   { "🭾", "FloatBorder" },
--   { "▕", "FloatBorder" },
--   { "🭿", "FloatBorder" },
--   { "▁", "FloatBorder" },
--   { "🭼", "FloatBorder" },
--   { "▏", "FloatBorder" },
-- }
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
  group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
  callback = function()
    vim.diagnostic.open_float(nil, {
      focus = false,
      border = "rounded",
    })
  end,
})

-- When I open markdown files I want to fold the markdown headings
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.md",
  callback = function()
    -- Get the full path of the current file
    local file_path = vim.fn.expand("%:p")
    -- Ignore files in my daily note directory
    if file_path:match(os.getenv("HOME") .. "/github/obsidian_main/250%-daily/") then
      return
    end -- Avoid running zk multiple times for the same buffer
    if vim.b.zk_executed then
      return
    end
    vim.b.zk_executed = true -- Mark as executed
    -- Use `vim.defer_fn` to add a slight delay before executing `zk`
    vim.defer_fn(function()
      vim.cmd("normal zk")
      -- This write was disabling my inlay hints
      -- vim.cmd("silent write")
      vim.notify("Folded keymaps", vim.log.levels.INFO)
    end, 100) -- Delay in milliseconds (100ms should be enough)
  end,
})

-- Clear jumps when I open Neovim, otherwise there'a lot of crap that links to
-- different files, trying this and will see if it works out or not
vim.api.nvim_create_autocmd("BufWinEnter", {
  once = true,
  callback = function()
    vim.schedule(function()
      vim.cmd("clearjumps")
    end)
  end,
})

-- Disable harper_ls when a markdown file inside ~/github/obsidian_main/075-umg is opened
local umg_root = vim.fn.expand("~/github/obsidian_main/075-umg")
-- Only register the autocmd if the target directory exists
if vim.fn.isdirectory(umg_root) == 1 then
  vim.api.nvim_create_autocmd("BufRead", {
    group = augroup("umg_markdown_disable_ls"),
    pattern = "*.md",
    callback = function()
      local file_path = vim.fn.expand("%:p")
      -- Check that the file resides inside umg_root
      if vim.startswith(file_path, umg_root .. "/") then
        -- Prevent running twice for the same buffer
        if vim.b.harper_ls_disabled then
          return
        end
        vim.b.harper_ls_disabled = true
        vim.schedule(function()
          pcall(vim.api.nvim_command, "LspStop harper_ls")
        end)
        vim.notify("UMG markdown opened: harper_ls disabled", vim.log.levels.INFO)
      end
    end,
  })
end
