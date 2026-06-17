return {
  "AstroNvim/astrolsp",
  ---@type AstroLSPOpts
  opts = {
    -- Указываем серверы, которые нужно запускать напрямую из PATH
    servers = {
      "zls",
    },
    -- Если вам нужно передать специфичные настройки в zls
    config = {
      zls = {
        -- Например, можно отключить форматирование сервером, если используете что-то другое
        -- on_attach = function(client)
        --   client.server_capabilities.documentFormattingProvider = false
        -- end,
      },
    },
  },
}
