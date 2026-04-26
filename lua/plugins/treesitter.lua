return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    config = function()
        require('nvim-treesitter').install({
            "c", "lua", "vim", "vimdoc", "query", "python", "go", "nix", "haskell"
        })

        vim.api.nvim_create_autocmd('FileType', {
            pattern = { "c", "lua", "vim", "vimdoc", "query", "python", "go", "nix", "haskell" },
            callback = function()
                vim.treesitter.start()
            end,
        })

        vim.api.nvim_create_autocmd('FileType', {
            pattern = { "c", "lua", "vim", "vimdoc", "query", "python", "go", "nix", "haskell" },
            callback = function()
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end
}
