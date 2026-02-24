return {
  -- COPILOT: keep it simple and predictable.
  -- LazyVim extra installs and configures it; we only tweak behavior.
  {
    "zbirenbaum/copilot.lua",
    opts = {
      panel = { enabled = false }, -- keep UI noise low
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        -- We'll add a "smart Tab accept" later (after baseline is stable).
      },
      filetypes = {
        -- enable everywhere by default; adjust if you want to disable in certain filetypes
        markdown = true,
        help = false,
        gitcommit = true,
      },
    },
  },

  -- AVANTE: Cursor-like refactor/apply edits.
  -- We provide consistent keymaps under <leader>a to avoid conflicts.
  {
    "yetone/avante.nvim",
    keys = {
      -- General entry points
      { "<leader>aa", "<cmd>AvanteAsk<cr>", desc = "Avante: Ask" },
      { "<leader>ac", "<cmd>AvanteChat<cr>", desc = "Avante: Chat" },
      { "<leader>ae", "<cmd>AvanteEdit<cr>", desc = "Avante: Edit" },
      { "<leader>ar", "<cmd>AvanteRefresh<cr>", desc = "Avante: Refresh" },

      -- Visual mode: operate on selection (this is the money)
      { "<leader>aa", ":'<,'>AvanteAsk<cr>", mode = "v", desc = "Avante: Ask selection" },
      { "<leader>ae", ":'<,'>AvanteEdit<cr>", mode = "v", desc = "Avante: Edit selection" },
    },
    opts = {
      -- Keep defaults; we’ll add model/provider selection later.
    },
  },
}
