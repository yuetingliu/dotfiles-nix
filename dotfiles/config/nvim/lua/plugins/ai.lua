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
}
