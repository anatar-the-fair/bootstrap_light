-- plugins/telescope.lua:
local config = function()
  local telescope = require("telescope")
  telescope.setup({
    defaults = {
      mappings = {
        i = {
          ["<C-j>"] = "move_selection_next",
          ["<C-k>"] = "move_selection_previous",
        },
      },
    },
    pickers = {
      find_files = {
        theme = "dropdown",
        previewer = false,
        hidden = true,       -- show hidden files
      },
      live_grep = {
        theme = "dropdown",
        previewer = false,
      },
      buffers = {
        theme = "dropdown",
        previewer = false,
      },
      -- no need to add config for the new picker here since we'll pass options on the fly
    },
  })
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.3",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = config,
  keys = {
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps", mode = "n" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Telescope help_tags", mode = "n" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Telescope find_files", mode = "n" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Telescope live_grep", mode = "n" },
    { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Telescope buffers", mode = "n" },
{ "<leader>fr", "<cmd>Telescope oldfiles<CR>", desc = "Telescope oldfiles", mode = "n" },

    -- New keybinding for searching all files including hidden and gitignored under ~/.config
    {
      "<leader>fc",
      function()
        require("telescope.builtin").find_files({
          cwd = "~/.config",
          hidden = true,
          no_ignore = true,
          previewer = false,
          theme = "dropdown",
        })
      end,
      desc = "Find all files (hidden/gitignored) in dotfiles config",
      mode = "n",
    },
  },
}

