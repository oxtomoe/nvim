return {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerBuild" },
    opts = {
        task_list = {
            direction = "bottom",
            bindings = {
                ["q"] = "Close",
                ["<CR>"] = "OpenOutput",
                ["<C-l>"] = "RestartTask",
                ["<C-h>"] = "ToggleDetail",
                ["<C-j>"] = "IncreaseDetail",
                ["<C-k>"] = "DecreaseDetail",
            },
            max_height = 20,
            min_height = 8,
            default_detail = 1,
        },
        form = { border = "single" },
        confirm = { border = "single" },
        task_win = { border = "single" },
    },
    config = function(_, opts)
        require("overseer").setup(opts)

        -- РЕГИСТРИРУЕМ КАСТОМНЫЕ ЗАДАЧИ ДЛЯ КАЖДОГО ЯЗЫКА

        -- === LUA ===
        require("overseer").register_template({
            name = "lua: run file",
            builder = function()
                return {
                    cmd = "lua",
                    args = { vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = false },
                        "on_complete_dispose",
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "lua" },
            },
        })

        require("overseer").register_template({
            name = "lua: test with busted",
            builder = function()
                return {
                    cmd = "busted",
                    args = { vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "lua" },
            },
        })

        require("overseer").register_template({
            name = "lua: format with stylua",
            builder = function()
                return {
                    cmd = "stylua",
                    args = { vim.fn.expand("%") },
                    components = { "on_complete_notify", "default" },
                }
            end,
            condition = {
                filetype = { "lua" },
            },
        })

        -- === PYTHON ===
        require("overseer").register_template({
            name = "python: run file",
            builder = function()
                return {
                    cmd = "python3",
                    args = { vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = false },
                        "on_complete_dispose",
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "python" },
            },
        })

        require("overseer").register_template({
            name = "python: ruff check",
            builder = function()
                return {
                    cmd = "ruff",
                    args = { "check", vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "python" },
            },
        })

        require("overseer").register_template({
            name = "python: pytest",
            builder = function()
                return {
                    cmd = "pytest",
                    args = { "-v", "." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "python" },
            },
        })

        require("overseer").register_template({
            name = "python: profile",
            builder = function()
                return {
                    cmd = "python3",
                    args = { "-m", "cProfile", "-s", "cumulative", vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = false },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "python" },
            },
        })

        -- === GO ===
        require("overseer").register_template({
            name = "go: build",
            builder = function()
                return {
                    cmd = "go",
                    args = { "build", "-v", "./..." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "go" },
            },
        })

        require("overseer").register_template({
            name = "go: run",
            builder = function()
                return {
                    cmd = "go",
                    args = { "run", "." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = false },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "go" },
            },
        })

        require("overseer").register_template({
            name = "go: test",
            builder = function()
                return {
                    cmd = "go",
                    args = { "test", "-v", "-race", "./..." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "go" },
            },
        })

        require("overseer").register_template({
            name = "go: coverage",
            builder = function()
                return {
                    cmd = "go",
                    args = { "test", "-cover", "./..." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "go" },
            },
        })

        require("overseer").register_template({
            name = "go: format & lint",
            builder = function()
                return {
                    cmd = "bash",
                    args = { "-c", "goimports -w . && golangci-lint run ./..." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "go" },
            },
        })

        -- === C/C++ ===
        require("overseer").register_template({
            name = "c/c++: compile & run",
            builder = function()
                local file = vim.fn.expand("%")
                local output = vim.fn.expand("%:r")
                return {
                    cmd = "bash",
                    args = {
                        "-c",
                        string.format("clang++ -std=c++17 -Wall -Wextra %s -o %s && ./%s", file, output, output),
                    },
                    components = {
                        { "on_output_quickfix", open = true },
                        "on_complete_dispose",
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "cpp", "c" },
            },
        })

        require("overseer").register_template({
            name = "c/c++: build (make)",
            builder = function()
                return {
                    cmd = "make",
                    args = { "-j", "$(nproc)" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "cpp", "c" },
            },
        })

        -- === HASKELL ===
        require("overseer").register_template({
            name = "haskell: run",
            builder = function()
                return {
                    cmd = "runhaskell",
                    args = { vim.fn.expand("%") },
                    components = {
                        { "on_output_quickfix", open = false },
                        "on_complete_dispose",
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "haskell" },
            },
        })

        require("overseer").register_template({
            name = "haskell: build (stack)",
            builder = function()
                return {
                    cmd = "stack",
                    args = { "build" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "haskell" },
            },
        })

        require("overseer").register_template({
            name = "haskell: format (ormolu)",
            builder = function()
                return {
                    cmd = "ormolu",
                    args = { "-i", vim.fn.expand("%") },
                    components = { "on_complete_notify", "default" },
                }
            end,
            condition = {
                filetype = { "haskell" },
            },
        })

        -- === C# ===
        require("overseer").register_template({
            name = "c#: build",
            builder = function()
                return {
                    cmd = "dotnet",
                    args = { "build" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "cs" },
            },
        })

        require("overseer").register_template({
            name = "c#: run",
            builder = function()
                return {
                    cmd = "dotnet",
                    args = { "run" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = false },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "cs" },
            },
        })

        require("overseer").register_template({
            name = "c#: test",
            builder = function()
                return {
                    cmd = "dotnet",
                    args = { "test", "-v" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "cs" },
            },
        })

        -- === NIX ===
        require("overseer").register_template({
            name = "nix: flake check",
            builder = function()
                return {
                    cmd = "nix",
                    args = { "flake", "check" },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "nix" },
            },
        })

        require("overseer").register_template({
            name = "nix: format",
            builder = function()
                return {
                    cmd = "nixpkgs-fmt",
                    args = { vim.fn.expand("%") },
                    components = { "on_complete_notify", "default" },
                }
            end,
            condition = {
                filetype = { "nix" },
            },
        })

        require("overseer").register_template({
            name = "nix: build",
            builder = function()
                return {
                    cmd = "nix",
                    args = { "build", "." },
                    cwd = vim.fn.getcwd(),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
            condition = {
                filetype = { "nix" },
            },
        })

        -- === UNIVERSAL ===
        require("overseer").register_template({
            name = "quick: run custom command",
            builder = function()
                return {
                    cmd = vim.fn.input("Command: "),
                    components = {
                        { "on_output_quickfix", open = true },
                        "default",
                    },
                }
            end,
        })
    end,
}
