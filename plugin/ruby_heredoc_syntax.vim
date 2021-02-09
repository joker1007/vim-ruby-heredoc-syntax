"=============================================================================
" FILE: ruby_heredoc_syntax.vim
" AUTHOR:  Tomohiro Hashidate <kakyoin.hierophant@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

if exists('g:loaded_ruby_heredoc_syntax')
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:ruby_heredoc_syntax_defaults')
  let g:ruby_heredoc_syntax_defaults = {
        \ "javascript" : {
        \   "start" : "JS",
        \},
        \ "sql" : {
        \   "start" : "SQL",
        \},
        \ "html" : {
        \   "start" : "HTML",
        \},
  \}
endif

if !exists('g:ruby_heredoc_syntax_filetypes')
  let g:ruby_heredoc_syntax_filetypes = {}
endif

let s:context_filetypes_ruby = {
\ 'ruby' : [
\   {
\     'start' : '\%(\%(class\s*\|\%([]})".]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zsJS',
\     'end' : '^\s*\zsJS$',
\     'filetype' : 'javascript',
\   },
\   {
\     'start' : '\%(\%(class\s*\|\%([]})".]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zsHTML',
\     'end' : '^\s*\zsHTML$',
\     'filetype' : 'html',
\   },
\   {
\     'start' : '\%(\%(class\s*\|\%([]})".]\|::\)\)\_s*\|\w\)\@<!<<[-~]\=\zsSQL',
\     'end' : '^\s*\zsSQL$',
\     'filetype' : 'sql',
\   },
\ ]
\}

try
  if !exists('g:context_filetype#filetypes')
    let g:context_filetype#filetypes = s:context_filetypes_ruby
  else
    let s:current_context_filetypes = copy(g:context_filetype#filetypes)
    let g:context_filetype#filetypes = extend(s:context_filetypes_ruby, s:current_context_filetypes)
  endif
catch
endtry

function! s:enable_heredoc_syntax()
  let defaults = deepcopy(g:ruby_heredoc_syntax_defaults)
  let filetype_dic = extend(defaults, g:ruby_heredoc_syntax_filetypes)

  for [filetype, option] in items(filetype_dic)
    call ruby_heredoc_syntax#include_other_syntax(filetype)
    call ruby_heredoc_syntax#enable_heredoc_highlight(filetype, option.start)
  endfor
endfunction

augroup ruby_heredoc_syntax
  autocmd!
  autocmd Syntax ruby call s:enable_heredoc_syntax()
  autocmd Syntax ruby.rspec call s:enable_heredoc_syntax()
augroup END

let g:loaded_ruby_heredoc_syntax = 1

let &cpo = s:save_cpo
unlet s:save_cpo
