local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- alias keymap
local map = vim.api.nvim_set_keymap
local function mapn(key, command)
  vim.api.nvim_set_keymap("n", key, command, opts)
end


-- send leader to space
map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- windows
mapn("<C-h>", "<C-w>h")
mapn("<C-j>", "<C-w>j")
mapn("<C-k>", "<C-w>k")
mapn("<C-l>", "<C-w>l")

-- mapn("<leader>e", ":Lex 30<cr>")
mapn("<leader>e", ":Lex 30<cr>")

-- resize
mapn("<C-Up>", ":resize -2<CR>")
mapn("<C-Down>", ":resize +2<CR>")
mapn("<C-Left>", ":vertical resize -2<CR>")
mapn("<C-Right>", ":vertical resize +2<CR>")

-- navigate
mapn("<S-l>", ":bnext<CR>")
mapn("<S-h>", ":bprevious<CR>")

