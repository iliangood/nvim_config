-- ~/.config/nvim/lua/plugins/my-plugin.lua
return {
  "aveplen/ruscmd.nvim",
  config = function()
    require("ruscmd").setup({})
  end,
}
