local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

  -- alias keymap
local map = vim.api.nvim_set_keymap
local function mapn(key, command)
  vim.api.nvim_set_keymap('n', key, command, opts)
end

local function mapi(key, command)
  vim.api.nvim_set_keymap('i', key, command, opts)
end

local function mapv(key, command)
  vim.api.nvim_set_keymap('v', key, command, opts)
end

-- send leader to space
map('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- windows
mapn('<C-h>', '<C-w>h')
mapn('<C-j>', '<C-w>j')
mapn('<C-k>', '<C-w>k')
mapn('<C-l>', '<C-w>l')

-- mapn('<leader>e', ':Lex 30<cr>')
mapn('<leader>e', ':Lex 30<cr>')

-- resize
mapn('<C-Up>', ':resize +2<CR>')
mapn('<C-Down>', ':resize -2<CR>')
mapn('<C-Left>', ':vertical resize -2<CR>')
mapn('<C-Right>', ':vertical resize +2<CR>')

-- navigate buffers
mapn('<S-l>', ':bnext<CR>')
mapn('<S-h>', ':bprevious<CR>')

-- escape
mapi('jk','<ESC>')
mapi('kj','<ESC>')

-- indent
mapv('<', '<gv')
mapv('>', '>gv')

-- move text
mapn('<A-j>', '<Esc>:m .+1<CR>==')
mapn('<A-k>', '<Esc>:m .-2<CR>==')
mapv('<A-j>', ":m '>+1<CR>gv=gv")
mapv('<A-k>', ":m '<-2<CR>==gv")

