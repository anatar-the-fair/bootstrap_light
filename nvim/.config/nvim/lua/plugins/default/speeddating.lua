return {
  "tpope/vim-speeddating",
  -- Optional: Add keybindings or configuration
  config = function()
    -- Optional: Define custom date formats or settings
    vim.cmd("SpeedDatingFormat %Y-%m-%d") -- Example: Add a custom date format
  end,
}
