return {
  -- 1. Плагин для автодополнения (Ghost Text)
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    config = function()
      require("minuet").setup {
        provider = "openai_compatible",
        n_completions = 1,
        context_window = 4000,
        provider_options = {
          openai_compatible = {
            api_key = "OPENROUTER_API_KEY",
            name = "openrouter",
            end_point = "https://openrouter.ai/api/v1/chat/completions",
            -- Для автодополнения нужна очень быстрая модель. Llama 3.1 8B или Haiku отлично подойдут.
            model = "meta-llama/llama-3.1-8b-instruct",
            stream = true,
          },
        },
      }
    end,
  },

  -- 2. Интеграция Minuet в nvim-cmp (если используешь стандартный AstroNvim cmp)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "minuet",
        group_index = 1,
        priority = 100,
      })
    end,
  },

  -- 3. Основной плагин для генерации кода и работы с контекстом
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>ca", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
      { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
      { "<leader>ci", "<cmd>CodeCompanion<cr>", mode = "n", desc = "AI Inline Prompt" },
    },
    opts = {
      strategies = {
        chat = { adapter = "openrouter" },
        inline = { adapter = "openrouter" },
        agent = { adapter = "openrouter" },
      },
      adapters = {
        openrouter = function()
          return require("codecompanion.adapters").extend("openai_compatible", {
            env = {
              -- Безопасное получение ключа из переменных окружения
              api_key = "cmd:echo $OPENROUTER_API_KEY",
            },
            url = "https://openrouter.ai/api/v1/chat/completions",
            schema = {
              model = {
                -- Для сложной логики (например, работы с памятью в C или многопоточностью) лучше использовать Sonnet
                default = "anthropic/claude-3.5-sonnet",
              },
            },
          })
        end,
      },
      display = {
        chat = {
          -- Позволяет сохранять чаты. Ты можешь использовать команду :CodeCompanionChat Save
          -- и сохранять их в скрытую папку .codecompanion/ в корне проекта
          show_settings = true,
        },
      },
    },
  },
}
