" =======
" Plugins
" =======
call plug#begin('~/.local/share/nvim/plugged')

" Go between .h and .cpp/.c files easily
Plug 'vim-scripts/a.vim'
" Nice package for wrapping selected text in quotes, parentheses, etc.
Plug 'tpope/vim-surround'
Plug 'altercation/vim-colors-solarized'
Plug 'iCyMind/NeoSolarized'
" Enables basic wrapper FZF vim command. Requires fzf binary to be installed on
" the system.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
" Some extra bells and whistles so that fzf works nicely with vim.
Plug 'junegunn/fzf.vim'
" Distraction-free writing
Plug 'junegunn/goyo.vim',      { 'for': 'markdown' }
Plug 'junegunn/limelight.vim', { 'for': 'markdown' }
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
" Enhanced command-line completion mode (for file names, command names, etc.)
set wildmenu
set wildmode=list:longest,full
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
  " Set textwidth to 80 characters. colorcolumn setting is relative to
  " textwidth.
  autocmd BufRead,BufNewFile *.{c,cpp,h,java,md} setlocal textwidth=80 colorcolumn=+1
augroup END

function! s:strip_trailing_whitespace()
  " Strip trailing whitespace but retain 'expected' cursor
  let l = line(".")
  let c = col(".")
  %s/\s\+$//e
  call cursor(l, c)
endfunction

augroup StripTrailingWhitespace
  autocmd!
  autocmd BufWritePre * call s:strip_trailing_whitespace()
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
noremap <C-k> :pyf /usr/local/share/clang/clang-format.py<CR>
inoremap <C-k> <c-o>:pyf /usr/local/share/clang/clang-format.py<CR>


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

" From junegunn/fzf.vim. Patterns passed to ag must be properly escaped.
function! s:escape_ag_pattern(pattern)
  return "'".substitute(a:pattern, "'", "'\\\\''", 'g')."'"
endfunction

function! s:ag_with_directory(dir, ...)
  return call(
    \ 'fzf#vim#ag_raw',
    \  extend([s:escape_ag_pattern('^(?=.)').' '.a:dir], a:000))
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

  " Ad: ag through given directory. Useful when grepping through large
  " codebases and you don't want to search through the entire repo.
  autocmd VimEnter * command! -bang -nargs=* -complete=dir Ad
    \ call s:ag_with_directory(<q-args>,
    \                          <bang>0 ? fzf#vim#with_preview('up:60%')
    \                                  : fzf#vim#with_preview('right:50%:hidden', '?'),
    \                          <bang>0)
augroup END

" Many more useful fzf.vim commands such as :Ag, :Files, and :Buffers below are
" described at
" https://github.com/junegunn/fzf.vim/blob/master/README.md#commands

" ag to fuzzy grep through code
nnoremap <Leader>a :Ag<CR>
" Fuzzy match for files
nnoremap <Leader>t :Files<CR>
" Fuzzy search open buffer names
nnoremap <Leader>b :Buffers<CR>

" Exit terminal mode. Mnemonic is that 'n' stands for normal.
tnoremap <Leader>n <C-\><C-n>

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

" Highlight tab characters with 'Error' group coloring. Use :retab to fix.
syntax match tab display "\t"
highlight link tab Error

" the following line seems to fix weird issues with vim inside of iTerm2
if &term == "screen-256color"
  set t_Co=256
endif

" Solarized settings
" let g:solarized_visibility = "high"
" let g:solarized_contrast = "high"
" set background=dark
" colorscheme solarized
colorscheme NeoSolarized


" =====================================
" Limelight settings + Goyo integration
" =====================================
" Color name (:help cterm-colors)
let g:limelight_conceal_ctermfg = 'blue'
let g:limelight_default_coefficient = 0.9

augroup GoyoAndLimelight
  " Remove all existing GoyoAndLimelight autocommands
  autocmd!

  autocmd User GoyoEnter Limelight
  autocmd User GoyoLeave Limelight!
augroup END
