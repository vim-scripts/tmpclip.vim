" ------------------------------------------------------------------------------
" Name:    tmpclip.vim
" Version: 1.0
" Author:  Ryan Gies
" Summary: Use a temp file as a clipboard
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
" ------------------------------------------------------------------------------
" Use a temp file as a clipboard
" ------------------------------------------------------------------------------
" This allows copy/paste from one vim session to another outside of a window
" manager. In my case, I have muliple PuTTY windows, each running screen,
" where many screens have vim instances.
"
" Sample keyboard mappings using the 't' register for holding the text while it 
" is in transit.
"
"   " Copy visually selected text
"   vmap <S-y> "ty:call <SID>tmpClipWrite('t')<CR>
"
"   " Paste said text after the cursor
"   nmap <C-p> :call <SID>tmpClipRead('t')<CR>"tp
"
"   " Paste said text before the cursor
"   nmap <C-o> :call <SID>tmpClipRead('t')<CR>"tP
" ------------------------------------------------------------------------------

" Shared clipboard filename.
"
" * Note effective user permissions
"
" * Want to share across machines? Could abstract to allow remote clipboards
"   e.g., ftp://example.com/clip.txt

let g:TmpClipFilename = expand('$HOME') . '/.tmpclip'

" Commands which act on the '"' register. For example, to copy the current
" line to another buffer:
" 
" In the source Vim buffer
"
"   yy
"   :TmpClipWrite
"
" Then in the destination Vim buffer
"
"   :TmpClipRead
"   p

command! TmpClipWrite call      <SID>tmpClipWrite('"')
command! TmpClipRead  call      <SID>tmpClipRead('"')

" tmpClipWrite - Write the contents of a register to the clipboard file

func! <SID>tmpClipWrite(reg)
  call writefile([getreg(a:reg)], g:TmpClipFilename)
endfunction

" tmpClipRead - Read the clipboard file into the named register

func! <SID>tmpClipRead(reg)
  let text = ''
  for line in readfile(g:TmpClipFilename)
    let text = text . line
  endfor
  call setreg(a:reg, text)
endfunction
