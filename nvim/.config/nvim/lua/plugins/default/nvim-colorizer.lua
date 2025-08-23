-- In your plugin setup file
return {
  "norcalli/nvim-colorizer.lua",
  config = function()
    require("colorizer").setup()
  end,
}
