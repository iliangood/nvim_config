-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

-- Создаем переменную для хранения таймера автосохранения вне функции
local autosave_timer = nil

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
      update_in_insert = false,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer" 
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,
      },
    },
   autocmds = {
      auto_save = {
        {
          -- Отслеживаем изменения текста и выход из режима вставки
          event = { "TextChanged", "InsertLeave" },
          desc = "Автосохранение с задержкой в 1 секунду и обновление ошибок в Normal режиме",
          pattern = "*",
          callback = function()
            -- Проверяем базовые условия буфера
            if vim.bo.readonly or vim.fn.expand("%") == "" or vim.bo.buftype ~= "" then
              return
            end

            -- 1. ЛОГИКА АВТОСОХРАНЕНИЯ С ТАЙМЕРОМ
            if vim.bo.modified then
              if autosave_timer then
                autosave_timer:stop()
              else
                local uv = vim.uv or vim.loop
                autosave_timer = uv.new_timer()
              end

              autosave_timer:start(1000, 0, vim.schedule_wrap(function()
                if vim.api.nvim_buf_is_valid(0) and vim.bo.modified then
                  vim.cmd("silent update")
                end
                autosave_timer = nil
              end))
            end

            -- 2. ПРИНУДИТЕЛЬНОЕ ОБНОВЛЕНИЕ ОШИБОК (Только в нормальном режиме)
            -- vim.api.nvim_get_mode().mode -> "n" означает Normal mode
            if vim.api.nvim_get_mode().mode == "n" then
              vim.schedule(function()
                if vim.api.nvim_buf_is_valid(0) then
                  local bufnr = vim.api.nvim_get_current_buf()
                  -- Перерисовываем виртуальный текст текущего буфера
                  vim.diagnostic.show(nil, bufnr, nil, { virtual_text = true })
                end
              end)
            end

          end,
        },
      },
    },
  },
}
