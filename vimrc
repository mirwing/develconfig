set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'fatih/vim-go'

call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8
set fileencoding=utf-8
set termencoding=utf-8

set fencs=utf-8,cp949,iso-8859-1

"==== 기본 변수 설정 ====
set cindent
set smartindent
set autoindent
set nowrap
set ff=unix
set background=dark
set ruler

set ts=4
set sts=4
set sw=4
au Bufenter *.\(c\|cpp\h\|java\|mk\) set et " tab -> space

filetype plugin indent on
syntax on
set backspace=eol,start,indent
set history=1000
set hlsearch
set nu

"==== key 매핑 ====
map <F1> v]}zf                    " 폴딩
map <F2> zo                        " 폴딩 해제
map <F3> :Tlist<cr><C-W><C-W>    " Taglist

"==== 인덴트 설정 및 제거 ====
map ,noi :set noai<CR>:set nocindent<CR>:set nosmartindent<CR>
map ,sei :set ai<CR>:set cindent<CR>:set smartindent<CR>

"==== 파일 버퍼 간 이동 ====
map ,1 :b!1<CR>
map ,2 :b!2<CR>
map ,3 :b!3<CR>
map ,4 :b!4<CR>
map ,5 :b!5<CR>
map ,6 :b!6<CR>
map ,7 :b!7<CR>
map ,8 :b!8<CR>
map ,9 :b!9<CR>
map ,0 :b!10<CR>
map ,w :bw<CR>        " 현재 파일 버퍼를 닫음
map ,_ <C-W>_
map ,= <C-W>=

"==== ctags 설정 ====
set tags=./tags,tags

if version >= 500
func! Sts()
    let st = expand("<cword>")
    exe "sts ".st
endfunc
nmap ,st :call Sts()<cr>

func! Tj()
    let st = expand("<cword>")
    exe "tj ".st
endfunc
nmap ,tj :call Tj()<cr>
endif

"==== cscope 설정 ====
set csprg=/usr/bin/cscope
set csto=0
set cst
set nocsverb

if filereadable("./cscope.out")
    cs add cscope.out
else
    cs add /usr/src/linux-2.4/cscope.out
endif
set csverb

func! Css()
    let css = expand("<cword>")
    new
    exe "cs find s ".css
    if getline(1) == " "
        exe "q!"
    endif
endfunc
nmap ,css : call Css()<cr>

func! Csc()
    let csc = expand("<cword>")
    new
    exe "cs find c ".csc
    if getline(1) == " "
        exe "q!"
    endif
endfunc
nmap ,csc :call Csc()<cr>

"==== man page 설정 ====
func! Man()
    let sm = expand("<cword>")
    exe "!man -S 2:3:4:5:6:7:8:9:tcl:n:l:p:o ".sm
endfunc
nmap ,ma :call Man()<cr><cr> 


"==== ctags -> ctags -R
"==== :tj [tag] -> <tag jump>의 약자로 해당하는 tag로 jump
"==== cursor 위치에서 ctrl-] 되돌아 갈 때는 ctrl-t 

autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType java set omnifunc=javacomplete#Complete
if has("autocmd") && exists("+omnifunc")
         autocmd Filetype *
            \ if &omnifunc == "" |
            \   setlocal omnifunc=syntaxcomplete#Complete |
            \ endif
endif
let g:rubycomplete_buffer_loading = 1 
let g:rubycomplete_classes_in_global = 1 
"let g:rubycomplete_rails = 1


