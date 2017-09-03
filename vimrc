" This block should stay at the top.
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#rc()

Plugin 'VundleVim/Vundle.vim'

" Go between .h and .cpp/.c files easily
Plugin 'vim-scripts/a.vim'
" Nice package for wrapping selected text in quotes, parentheses, etc.
Plugin 'tpope/vim-surround'
Plugin 'altercation/vim-colors-solarized'
" Enables basic wrapper FZF vim command. Requires fzf binary to be installed on
" the system.
Plugin 'junegunn/fzf'
" Some extra bells and whistles so that fzf works nicely with vim.
Plugin 'junegunn/fzf.vim'
" Facebook-specific. Good for syntax highlighting .thrift IDL files.
Plugin 'solarnz/thrift.vim'
Plugin 'jsonm.vim', {'pinned': 1}

" My color tweaks
augroup HiglightTODO
    autocmd!
    autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO\|FIXME', -1)
augroup END
" Define autocmd for some highlighting *before* the colorscheme is loaded
augroup VimrcColors
au!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=#444444
  autocmd ColorScheme * highlight Tab             ctermbg=darkblue  guibg=darkblue
  "autocmd ColorScheme * highlight Todo            guifg=Purple
augroup END

" Once Vundle has loaded the plugins, we can turn on filetype.
filetype plugin indent on
syntax enable
set ignorecase  " Needed for smartcase
set smartcase   " smartcase searching
set background=dark
" solarized options 
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
colorscheme solarized
" the following line seems to fix weird issues with vim inside of iTerm2
set t_Co=256

" Automatically changes working directory to same as current file
set autochdir
" Disable audio bell, but keep visual bell
set noerrorbells visualbell t_vb= 
set mouse=a
" Enable switching buffers without saving
set hidden 

set nohlsearch
set incsearch

" Column width
au BufRead,BufNewFile *.{c,cpp,h,java,md,tex} setlocal textwidth=80

""" Some vim tricks
" At the vim command line:
"   :imap <c-j>d <c-r>=system('/Users/jon/myscript.py')
"   If myscript.py writes, say, a UUID to stdout, the new (insert-mode) command
"   <c-j>d will insert a uuid right into your buffer.

" Useful for any program using ctags.
" If tags file is not in current dir, look in parent, etc.
set tags=tags;

" Settings inspired by Learn Vimscript the Hard Way
" The following are very useful for typing in long constant names like
" MY_BIG_CONSTANT_INT
"inoremap <some-prefix> <esc>viwUea
"nnoremap <some-prefix> viwUe

let mapleader = ","
" Consider also setting local leader
" set maplocalleader = "\\"

" Edit my Vimrc 
" ^~~~~~~~^~~~~
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Source Vimrc
" ^~~~~~~^~~~~
nnoremap <leader>sv :source $MYVIMRC<cr>

" Surround word in double quotes
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
vnoremap <leader>" <esc>`>a"<esc>`<i"<esc>gvlolo

" Save wear and tear on the left pinky
inoremap jk <esc>

set backspace=2
set softtabstop=2
set shiftwidth=2 "tab size
set expandtab "expand tabs to spaces

map <C-K> :pyf /Users/jon/bin/clang-format.py<CR>
imap <C-K> <ESC>:pyf /Users/jon/bin/clang-format.py<CR>i

""""""""""""""""""""""""""""
" fzf and ag configuration "
""""""""""""""""""""""""""""
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

autocmd! User FzfStatusLine call <SID>fzf_statusline()

let g:fzf_tags_command = 'ctags --extra=+fq -R'
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \   'bg':      ['bg', 'Normal'],
  \   'hl':      ['fg', 'Comment'],
  \   'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \   'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \   'hl+':     ['fg', 'Statement'],
  \   'info':    ['fg', 'PreProc'],
  \   'prompt':  ['fg', 'Conditional'],
  \   'pointer': ['fg', 'Exception'],
  \   'marker':  ['fg', 'Keyword'],
  \   'spinner': ['fg', 'Label'],
  \   'header':  ['fg', 'Comment'] }

" Ag and Ag! commands taken from fzf.vim README
autocmd VimEnter * command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
  \                 <bang>0)
nnoremap <Leader>a :Ag<CR>

" fzf.vim plugin commands for searching for files and for text in 
" open buffers.
" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Many more useful fzf.vim commands, such as Files and Buffers below,
" are described at
" https://github.com/junegunn/fzf.vim/blob/master/README.md#commands
nnoremap <Leader>t :Files<CR>
nnoremap <Leader>b :Buffers<CR>
