-- Функция динамически ищет esp-clang от Espressif. Если не находит — берет системный.
local function get_clangd_cmd()
  local search_path = vim.fn.expand("~/.espressif/tools/esp-clang/*/esp-clang/bin/clangd")
  local handle = io.popen("ls " .. search_path .. " 2>/dev/null | head -n 1")
  if handle then
    local res = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if res ~= "" then return res end
  end
  return "clangd" -- Fallback на системный, если esp-clang не установлен
end

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
          get_clangd_cmd(), -- <-- Вызываем функцию автопоиска вместо жесткой строки
          "--background-index",
          "--clang-tidy",
          "--fallback-style=Chromium",
          "--query-driver=**/*gcc*,**/*g++*",
        },
      },
    },
  },
}
