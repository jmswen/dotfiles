" =======
" Plugins
" =======
call plug#begin('~/.local/share/nvim/plugged')

" Go between .h and .cpp/.c files easily
Plug 'vim-scripts/a.vim'
" Nice package for wrapping selected text in quotes, parentheses, etc.
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'
" Enables basic wrapper FZF vim command. Requires fzf binary to be installed on
" the system.
Plug 'junegunn/fzf'
" Some extra bells and whistles so that fzf works nicely with vim.
Plug 'junegunn/fzf.vim'
" Facebook-specific. Good for syntax highlighting .thrift IDL files.
Plug 'solarnz/thrift.vim'
Plug '~/jsonm.vim'

call plug#end()


" ==================
" Basic vim settings
" ==================
set ignorecase  " Needed for smartcase
set smartcase   " smartcase searching
" Automatically changes working directory to same as current file
set autochdir
" Disable audio bell, but keep visual bell
set noerrorbells visualbell t_vb= 
set mouse=a
" Enable switching buffers without saving
set hidden 
" Search highlight settings
set nohlsearch
set incsearch
" Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert mode.
set backspace=indent,eol,start
" Tabs are two spaces.
set softtabstop=2
set shiftwidth=2
set expandtab
" Useful for any program using ctags.
" If tags file is not in current dir, look in parent, etc.
set tags=tags;

" Some extra vim tricks
" At the vim command prompt:
"   :imap <c-j>d <c-r>=system('/Users/jon/myscript.py')
"   If myscript.py writes, say, a UUID to stdout, the new (insert-mode) command
"   <c-j>d will insert a uuid right into your buffer.

augroup TextWidth
  " Remove existing TextWidth autocommand
  autocmd!
  autocmd BufRead,BufNewFile *.{c,cpp,h,java,md} setlocal textwidth=80
augroup END

let mapleader = ","  " Consider also setting local leader

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
" clang-format shortcuts
nnoremap <C-K> :pyf /Users/jon/bin/clang-format.py<CR>
inoremap <C-K> <ESC>:pyf /Users/jon/bin/clang-format.py<CR>i


" ========================
" fzf and ag configuration
" ========================
function! s:fzf_statusline()
  " Override statusline as you like
  highlight fzf1 ctermfg=161 ctermbg=251
  highlight fzf2 ctermfg=23 ctermbg=251
  highlight fzf3 ctermfg=237 ctermbg=251
  setlocal statusline=%#fzf1#\ >\ %#fzf2#fz%#fzf3#f
endfunction

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

augroup FzfAutocmds
  " Remove all FzfAutocmds autocommands
  autocmd!

  " Override the default :FzfStatusLine provided in the fzf results buffer.
  autocmd User FzfStatusLine call <sid>fzf_statusline()

  " This override of the provided :Files command shows a preview of the file
  " contents on the right-hand side.
  autocmd VimEnter * command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

  " Ag and Ag! commands taken from fzf.vim README. :Ag! shows a nice preview
  " of matches with surrounding context.
  autocmd VimEnter * command! -bang -nargs=* Ag
    \ call fzf#vim#ag(<q-args>,
    \                 <bang>0 ? fzf#vim#with_preview('up:60%')
    \                         : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                 <bang>0)
augroup END

" Many more useful fzf.vim commands such as :Ag, :Files, and :Buffers below are
" described at
" https://github.com/junegunn/fzf.vim/blob/master/README.md#commands
"
" ag to fuzzy grep through code
nnoremap <Leader>a :Ag<CR>
" Fuzzy match for files
nnoremap <Leader>t :Files<CR>
" Fuzzy search open buffer names
nnoremap <Leader>b :Buffers<CR>


" ======
" Colors
" ======
augroup HiglightTodo
  " Remove all HighlightTodo autocommands
  autocmd!

  autocmd WinEnter,VimEnter * :silent! call matchadd('Todo', 'TODO\|FIXME', -1)
augroup END

" Define autocmd for some highlighting *before* the colorscheme is loaded
augroup VimrcColors
  " Remove all VimrcColors autocommands
  autocmd!
  autocmd ColorScheme * highlight ExtraWhitespace ctermbg=darkgreen guibg=#444444
  autocmd ColorScheme * highlight Tab             ctermbg=darkblue  guibg=darkblue
  autocmd ColorScheme * highlight Todo            guifg=Purple
augroup END

" Solarized settings
let g:solarized_visibility = "high"
let g:solarized_contrast = "high"
set background=dark
colorscheme solarized
" the following line seems to fix weird issues with vim inside of iTerm2
set t_Co=256
