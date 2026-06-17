return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    require("nvim-treesitter.install").compilers = { "clang", "gcc" }
  end,
}
