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

let s:save_cpo = &cpo
set cpo&vim

function! ruby_heredoc_syntax#syntax_group(filetype)
  let ft = toupper(a:filetype)
  return 'rubyHereDocCodeGroup'.ft
endfunction

function! ruby_heredoc_syntax#syntax_code_region(filetype)
  let ft = toupper(a:filetype)
  return 'rubyHereDocCodeRegion'.ft
endfunction

function! ruby_heredoc_syntax#syntax_start_region(filetype)
  let ft = toupper(a:filetype)
  return 'rubyHereDocCodeStart'.ft
endfunction

function! ruby_heredoc_syntax#include_other_syntax(filetype)
  let group = ruby_heredoc_syntax#syntax_group(a:filetype)

  " syntax save
  if exists('b:current_syntax')
    let s:current_syntax = b:current_syntax
    unlet b:current_syntax
  endif

  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'

  " syntax restore
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif

  return group
endfunction

function! ruby_heredoc_syntax#enable_heredoc_highlight(filetype, start)
  let group = ruby_heredoc_syntax#syntax_group(a:filetype)
  let start_region = ruby_heredoc_syntax#syntax_start_region(a:filetype)
  let code_region = ruby_heredoc_syntax#syntax_code_region(a:filetype)

  let regexp1 = "\\%(\\%(class\\s*\\|\\%([]})\"'.]\\|::\\)\\)\\_s*\\|\\w\\)\\@<!<<[-~]\\=\\zs['`\"]\\=".a:start
  let syntax1 = 'syntax region '.start_region.' matchGroup=rubyStringDelimiter start=+'.regexp1.'+ end=+$+ oneline contains=ALLBUT,@rubyNotTop'

  let regexp2 = "\\%(\\%(class\\|::\\)\\_s*\\|\\%([]}).]\\)\\s\\|\\w\\)\\@<!<<['`\"]\\=".a:start."['`\"]\\=\\ze\\%(.*<<[-~]\\=['`\"]\\=\\h\\)\\@!"
  let syntax2 = 'syntax region '.code_region.' matchGroup=rubyStringDelimiter start=+'.regexp2.'+hs=s+2 end=+^'.a:start.'$+ contains='.start_region.',@'.group.' fold keepend'

  let regexp3 = "\\%(\\%(class\\|::\\)\\_s*\\|\\%([]}).]\\)\\s\\|\\w\\)\\@<!<<-\\z(".a:start."\\)\\ze\\%(.*<<-\\=['`\"]\\=\\h\\)\\@!"
  let regexp3 = "\\%(\\%(class\\|::\\)\\_s*\\|\\%([]}).]\\)\\s\\|\\w\\)\\@<!<<[-~]['`\"]\\=".a:start."['`\"]\\=\\ze\\%(.*<<[-~]\\=['`\"]\\=\\h\\)\\@!"
  let syntax3 = 'syntax region '.code_region.' matchGroup=rubyStringDelimiter start=+'.regexp3.'+hs=s+3 end=+^\s*\zs'.a:start.'$+ contains='.start_region.',@'.group.' fold keepend'

  execute syntax1
  execute syntax2
  execute syntax3
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
