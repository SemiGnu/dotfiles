" VS Code Vim-focused config based on the current Neovim Lua config.
" This intentionally avoids Neovim-only Lua/plugin commands.

" Leader
let mapleader = " "
let maplocalleader = " "
nnoremap <Space> <Nop>
vnoremap <Space> <Nop>

" Options
set nobackup
set clipboard=unnamedplus
set cmdheight=1
set completeopt=menuone,noselect
set conceallevel=0
set fileencoding=utf-8
set hlsearch
set ignorecase
set pumheight=10
set showmode
set showtabline=2
set smartcase
set smartindent
set splitbelow
set splitright
set noswapfile
set termguicolors
set timeoutlen=1000
set undofile
set updatetime=300
set nowritebackup
set expandtab
set shiftwidth=2
set tabstop=2
set cursorline
set number
set norelativenumber
set numberwidth=4
set signcolumn=yes
set nowrap
set scrolloff=8
set sidescrolloff=8
set whichwrap+=<,>,[,],h,l
set iskeyword+=-

" Neovim-only in your Lua config. Keep guarded so the file stays usable in Vim.
if has('nvim')
  set shortmess+=c
  if exists('&showcmdloc')
    set showcmdloc=statusline
  endif
endif

" Window navigation
nnoremap <silent> <C-h> <C-w>h
nnoremap <silent> <C-j> <C-w>j
nnoremap <silent> <C-k> <C-w>k
nnoremap <silent> <C-l> <C-w>l

" Resize splits
nnoremap <silent> <C-Up> :resize +2<CR>
nnoremap <silent> <C-Down> :resize -2<CR>
nnoremap <silent> <C-Left> :vertical resize -2<CR>
nnoremap <silent> <C-Right> :vertical resize +2<CR>

" Navigate buffers
nnoremap <silent> <S-l> :bnext<CR>
nnoremap <silent> <S-h> :bprevious<CR>

" Keep selection after indenting
vnoremap <silent> < <gv
vnoremap <silent> > >gv

" Move text
nnoremap <silent> <A-j> <Esc>:m .+1<CR>==
nnoremap <silent> <A-k> <Esc>:m .-2<CR>==
vnoremap <silent> <A-j> :m '>+1<CR>gv=gv
vnoremap <silent> <A-k> :m '<-2<CR>gv=gv

" VS Code Vim cannot use your Neovim plugins directly:
" - <leader>e was :NvimTreeToggle
" - <leader>f was Telescope find_files
" - <leader><S-f> was Telescope live_grep
"
" If you use VSCode Neovim instead of VSCodeVim, these command mappings may work:
" nnoremap <silent> <leader>e :call VSCodeNotify('workbench.view.explorer')<CR>
" nnoremap <silent> <leader>f :call VSCodeNotify('workbench.action.quickOpen')<CR>
" nnoremap <silent> <leader>F :call VSCodeNotify('workbench.action.findInFiles')<CR>
