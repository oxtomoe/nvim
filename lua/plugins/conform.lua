return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },

    opts = {
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff_fix", "ruff_format" },
            javascript = { "prettier" },
            nix = { "nixpkgs-fmt" },
        },

        format_on_save = {
            timeout_ms = 1000,
            lsp_fallback = true,
        },
    },
}
