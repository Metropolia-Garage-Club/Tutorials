vim.keymap.set("n", "<leader>h", "<C-]>", { desc = "Jump to tag in help", buffer = true })
vim.keymap.set("n", "<leader>fe", vim.cmd.Ex)
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
