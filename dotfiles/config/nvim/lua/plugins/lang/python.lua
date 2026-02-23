return {
  -- 1) Ensure Python tooling is installed via Mason (declarative)
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "pyright",
        "ruff",
        "debugpy",
      })
    end,
  },

  -- 2) LazyVim Python extra knobs (optional, but nice to centralize here)
  -- You can keep these in config/options.lua too; I like them here for "Python owns Python".
  {
    "LazyVim/LazyVim",
    opts = function()
      vim.g.lazyvim_python_lsp = "pyright" -- or "basedpyright"
      vim.g.lazyvim_python_ruff = "ruff" -- or "ruff_lsp" if you end up needing it
    end,
  },

  -- 3) Formatting + import organization via Ruff + Conform
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
      },
    },
  },
}
