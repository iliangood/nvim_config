return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    servers = {
      "zls",
      "clangd",
    },
    config = {
      zls = {},
      clangd = {
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--fallback-style=Chromium",
          -- Оставляем только извлечение системных библиотек
          "--query-driver=**/*gcc*,**/*g++*",
        },
      },
    },
  },
}
