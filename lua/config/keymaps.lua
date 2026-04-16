local key = vim.keymap.set
local harpoon = require("harpoon")

harpoon:setup({
    settings = {
        save_on_toggle = true,
    }
})

require("which-key").add({
    { "<leader>f",  group = "Files/Find" },
    { "<leader>s",  group = "Search" },
    { "<leader>q",  group = "Quit" },
    { "<leader>g",  group = "Go(to)" },
    { "<leader>c",  group = "Code" },
    { "<leader>b",  group = "Buffers" },
    { "<leader>e",  group = "Edit Config" },
    { "<leader>ek", group = "Kitty" },
    { "<leader>h",  group = "Help" },
    { "<leader>w",  group = "Windows" },
    { "<leader>1",  hidden = true },
    { "<leader>2",  hidden = true },
    { "<leader>3",  hidden = true },
    { "<leader>4",  hidden = true },
})

-- === group: (f)iles ===
key("n", "<leader>fs", "<cmd>w<cr>", { desc = "Save file" })
key("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find files" })
key("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Grep files" })

-- === group: (c)onfig ===
-- Kitty
key("n", "<leader>eks", "<cmd>e ~/.local/share/kitty/sessions/<cr>", { desc = "Edit kitty sessions" })
key("n", "<leader>ekk", "<cmd>e ~/nixos/modules/home/kitty.nix<cr>", { desc = "Edit kitty config" })

-- === group: (s)earch ===
key("n", "<leader>st", function() Snacks.picker.todo_comments() end, { desc = "Find all todo's" })
key("n", "<leader>sT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end,
    { desc = "Find only Todo/Fix/Fixme" })

-- === group: (q)uit ===
key("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Safe quit (all)" })
key("n", "<leader>qQ", "<cmd>qa!<cr>", { desc = "Force quit (all)" })

-- === group: (g)o ===
key("n", "<leader>gd", function() Snacks.picker.lsp_definitions() end, { desc = "Go to definition" })
key("n", "<leader>gr", function() Snacks.picker.lsp_references() end, { desc = "Go to reference" })

-- === group: (c)ode ===
key("n", "<leader>cs", function() Snacks.picker.lsp_symbols() end, { desc = "File symbols (functions, classes, etc)" })
key({ "n", "v" }, "<leader>cf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Code format (buffer)" })

-- === group: (b)uffers ===
key("n", "<leader>bb", function()
    Snacks.picker.buffers({
        current = false,
        sort_lastused = true,
        layout = {
            preset = "ivy",
        }
    })
end, { desc = "Buffer switch" })

key("n", "<leader>bd", function()
    Snacks.bufdelete()
end, { desc = "Safe buffer delete" })

-- === group: (h)arpoon ===
key("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add File" })
key("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Quick Menu" })
key("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
key("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
key("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
key("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
key("n", "<C-p>", function() harpoon:list():prev() end, { desc = "Harpoon Prev" })
key("n", "<C-n>", function() harpoon:list():next() end, { desc = "Harpoon Next" })

-- === group: (h)elp ===
key("n", "<leader>hn", function() Snacks.picker.help() end, { desc = "Search nvim docs" })

-- === group: (w)indows ===
-- Splits
key("n", "<leader>w|", "<C-W>v", { desc = "Split right (Vertical)" })
key("n", "<leader>w-", "<C-W>s", { desc = "Split below (Horizontal)" })

-- Control
key("n", "<leader>w=", "<C-W>=", { desc = "Make splits equal" })
key("n", "<leader>wd", "<cmd>close<cr>", { desc = "Close current split" })

-- === Window navigation ===
key("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
key("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
key("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
key("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- === Change window size ===
key("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
key("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
key("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
key("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- === Aliases ===
key("n", "<leader>,", function()
    Snacks.picker.buffers({
        current = false,
        sort_lastused = true,
        layout = {
            preset = "ivy",
        }
    })
end, { desc = "Buffer switch" })

key("n", "<leader>.", function()
    Snacks.picker.files({
        hidden = true,
    })
end, { desc = "Find/Create file" })

key("n", "<leader><space>", function()
    Snacks.picker.smart()
end, { desc = "Smart Find Files" })

key("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Grep files" })

key({ "n", "v" }, "-", "<cmd>Oil<cr>", { desc = "Open Oil", silent = true })

-- === Other ===
key("n", "]t", function() require("todo-comments").jump_next() end, { desc = "Next todo" })
key("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "Prev todo" })
