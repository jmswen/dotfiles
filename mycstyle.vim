" For most C/C++ projects, I prefer 2-space tabs. But occasionally (e.g., when
" working with someone else's project, it is better to use 8-space tabs.

if exists('g:loaded_mycstyle')
  finish
endif
let g:loaded_mycstyle = 1

function! mycstyle#eight_space_tabs(project_pattern)
  let l:et = &expandtab
  let l:path = expand('%:p')
  if l:et && l:path =~ a:project_pattern
    setlocal tabstop=8 softtabstop=8 shiftwidth=8
  endif
endfunction
