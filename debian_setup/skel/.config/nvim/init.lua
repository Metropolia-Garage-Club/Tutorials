vim.g.mapleader = " "

-- Diagnostic test
vim.keymap.set("n", "<leader>tt", function() print("Leader works!") end)

-- Custom settings and scripts
require("aiot.settings")
require("aiot.myscripts.keybinds")

vim.g.codi_virtual_text_pos = "right"

-- Easily debug which plugin is causing problems
local debug_mode = false
local plugins

if debug_mode then
    plugins = {
--         require("aiot.plugins."),
    }
else
    plugins = "aiot.plugins"
end
