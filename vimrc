"주의: Source Explorer의 충돌을 피하기 위해서 SrcExpl_pluginList를 새로 작성

"====================================================
"= Bundle
"====================================================
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'VundleVim/Vundle.vim'
Bundle 'fatih/vim-go'

Bundle 'gmarik/vundle'
Bundle 'snipMate'
Bundle 'The-NERD-tree'
Bundle 'taglist-plus'
Bundle 'git://github.com/wesleyche/SrcExpl.git'
Bundle 'SuperTab'
Bundle 'cscope_macros.vim'
Bundle 'gtags.vim'
Bundle 'OmniCppComplete'
Bundle 'armasm'
Bundle 'https://github.com/dhruvasagar/vim-table-mode.git'
Bundle 'The-NERD-Commenter'
Bundle 'matchparenpp'
Bundle 'bling/vim-airline'
Bundle 'flazz/vim-colorschemes'
Bundle 'Indent-Guides'
Bundle 'Better-CSS-Syntax-for-Vim'
Bundle 'OOP-javascript-indentation'
Bundle 'vim-jsbeautify'
Bundle 'vim-json-bundle'
Bundle 'Enhanced-Javascript-syntax'
Bundle 'ZoomWin'

let fzf = $HOME . '/.fzf'
if isdirectory(fzf)
set rtp+=~/.fzf
set hidden

function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

"====================================================
"= FZF args
"====================================================
map <F3> :FZFBuf<CR>
command! FZFBuf call fzf#run({
\   'source':  reverse(<sid>buflist()),
\   'sink':    function('<sid>bufopen'),
\   'down':    len(<sid>buflist()) + 2
\ })

nmap <Char-27>f :FZFFile<CR>
command! FZFFile call fzf#run({
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '40%'})
nmap <Char-27>r :FZFMru<CR>
command! FZFMru call fzf#run({
            \  'source':  v:oldfiles,
            \  'sink':    'e',
            \  'options': '-m -x +s',
            \  'down':    '40%'})

function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags_directory')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()

" TODO: Change Directory
"function! s:cd_source()
"    let cdlist = map(split(system("_z"),"\n"), 'split(v:val, "\t")')
"    return map(cdlist, 'join(v:val, "\t")')
"endfunction
"
"function! s:cd_sink(line)
"    exec cd a:line
"endfunction
"
"nmap <Char-27>d :FZFCD<CR>
"command! FZFCD call fzf#run({
"            \  'source':  s:cd_source(),
"            \  'sink':    function('s:cd_sink'),
"            \  'options': '-m -x +s',
"            \  'down':    '40%'})
else
Bundle 'bufexplorer.zip'
Bundle 'ctrlp.vim'
map <F3> :BufExplorer<cr>
endif

filetype plugin indent on     " required!

"====================================================
"= 어셈블리 파일을 C처럼 인식하여 주석을 달기 위한 트릭
"====================================================
au BufRead,BufNewFile *.S		set ft=c
au! BufNewFile,BufRead /var/log/xcat/*	set filetype=xcat
au Bufenter *.\(c\|cpp\h\|java\|mk\) set et " tab -> space

"====================================================
"= 기본 설정
"====================================================
set cindent			"들여쓰기 설정
set smartindent
set autoindent
set nowrap
set ff=unix
set ruler			" 화면 우측 하단에 현재 커서의 위치(줄,칸)를 보여준다.
set number			" 줄번호 출력
set modifiable
set hlsearch			" Highlight Search
set ts=4			" tab stop - tab 크기
set sw=4			" shift width - shift 크기 조절
set sts=4			" soft tab stop - tab 이동 크기
set	expandtab
set incsearch
set printoptions=portrait:n,wrap:n,duplex:off
set gfn=Bitstream_Vera_Sans_Mono_newro\ 10	" gvim용 폰트 설정
set encoding=utf-8
set fileencodings=utf-8,cp949
set pastetoggle=<F5>
noremap <silent> <F10> :set number!<CR>
imap <silent> <F10> <c-o>:set number!<CR>
set foldmethod=indent
set nofoldenable
set backspace=eol,start,indent
set history=1000

"====================================================
"= 칼라 설정
"====================================================
syntax on
set t_Co=256
    
"==========================
"= autocmd
"==========================
autocmd BufEnter *.c        setlocal ts=4 sw=4 sts=4 
autocmd BufEnter *.S        setlocal ts=4 sw=4 sts=4 
autocmd BufEnter *.py       setlocal ts=4 sw=4 sts=4 
autocmd BufEnter Makefile   setlocal ts=4 sw=4 sts=4 
autocmd BufEnter *.pl       setlocal ts=4 sw=4 sts=4 
autocmd BufEnter *.pm       setlocal ts=4 sw=4 sts=4 
autocmd BufEnter .*         setlocal ts=4 sw=4 sts=4 nocindent
autocmd BufEnter *.md       setlocal ts=4 sw=4 sts=4 nocindent
autocmd BufEnter *.sh       setlocal ts=4 sw=4 sts=4 nocindent
autocmd BufEnter *.js       setlocal ts=4 sw=4 sts=4 nocindent
autocmd BufEnter *.debug    setlocal cursorline
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
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

"====================================================
"= gtags.vim 설정
"====================================================
nmap <C-l> :bo copen<CR>
nmap <C-c> :cclose<CR>
nmap <C-F5> :Gtags<SPACE>
nmap <C-F6> :Gtags -f %<CR>
nmap <C-F7> :GtagsCursor<CR>
nmap <C-F8> :Gozilla<CR>
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>
nmap <C-\><C-]> :GtagsCursor<CR>

"====================================================
"= 키맵핑
"====================================================
" <F3> 이전 정의로 이동 (SrcExpl 플러그인이 설정)
" <F4> 다음 정의로 이동 (SrcExpl 플러그인이 설정)
function! ToggleSearchView()
    if g:searchView
        let g:searchView = 0
        exe "ccl"
    else
        let g:searchView = 1
        exe "vimgrep /".expand("<cword>")."/j ../../**"
        exe "bo cw"
    endif
endfunction

let g:searchView = 0
nnoremap <F2> :call ToggleSearchView()<CR>
map <F7> :BundleSearch<cr>
map <F9> :NERDTreeToggle<CR>
map <F11> :SrcExplToggle<CR>
map <F12> :TagbarToggle<CR>
"map <F12> :TlistToggle<CR>

"=====  PageUP PageDown
map <PageUp> <C-U><C-U>
map <PageDown> <C-D><C-D>

" Fast window resizing with +/- keys (horizontal); / and * keys (vertical)
if bufwinnr(1)
  map <Esc>Ol <C-W>+
  map <Esc>OS <C-W>-
  map <Esc>OQ <c-w><
  map <Esc>OR <c-w>>
endif

"===== Vim 내에서 창 간 이동
nmap <Char-27>h <c-w>h
nmap <Char-27>j <c-w>j 
nmap <Char-27>k <c-w>k 
nmap <Char-27>l <c-w>l 

"===== 버퍼간 이동
map ,x :bn!<CR>	  " Switch to Next File Buffer
map ,z :bp!<CR>	  " Switch to Previous File Buffer
map ,c :e#<CR>   " Switch to Previous edit buffer
map ,w :b#<bar>bd#<CR>	  " Close Current File Buffer
map <Char-27>n :enew<CR>  " open one in current window
map <Char-27>] <C-w>o  " Zoom toggle in current window

map ,1 :b!1<CR>	  " Switch to File Buffer #1
map ,2 :b!2<CR>	  " Switch to File Buffer #2
map ,3 :b!3<CR>	  " Switch to File Buffer #3
map ,4 :b!4<CR>	  " Switch to File Buffer #4
map ,5 :b!5<CR>	  " Switch to File Buffer #5
map ,6 :b!6<CR>	  " Switch to File Buffer #6
map ,7 :b!7<CR>	  " Switch to File Buffer #7
map ,8 :b!8<CR>	  " Switch to File Buffer #8
map ,9 :b!9<CR>	  " Switch to File Buffer #9
map ,0 :b!0<CR>	  " Switch to File Buffer #0

"===== gtags.vim
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>
nmap <C-\><C-]> :GtagsCursor<CR>

"===== make
let startdir = getcwd()
func! Make()
	exe "!cd ".startdir
	exe "make"
endfunc
nmap ,mk :call Make()<cr><cr>

"===== hexViewer
let g:hexViewer = 0
func! Hv()
        if (g:hexViewer == 0)
                let g:hexViewer = 1
                exe "%!xxd"
        else
                let g:hexViewer = 0
                exe "%!xxd -r"
        endif
endfunc
nmap ,h :call Hv()<cr>

"===== man
func! Man()
	let sm = expand("<cword>")
	exe "!man -S 2:3:4:5:6:7:8:9:tcl:n:l:p:o ".sm
endfunc
nmap ,ma :call Man()<cr><cr>

"====================================================
"= Source Explorer config
"====================================================

" // Set the height of Source Explorer window
let g:SrcExpl_winHeight = 8
" // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_refreshTime = 100
" // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_jumpKey = "<ENTER>"
" // Set "Space" key for back from the definition context
let g:SrcExpl_gobackKey = "<SPACE>"

" // In order to avoid conflicts, the Source Explorer should know what plugins
" // except itself are using buffers. And you need add their buffer names into
" // below listaccording to the command ":buffers!"
let g:SrcExpl_pluginList = [
				\ "NERD_tree_1",
				\ "[BufExplorer]",
                \ "__Tag_List__"
				\ ]

" // Enable/Disable the local definition searching, and note that this is not
" // guaranteed to work, the Source Explorer doesn't check the syntax for now.
" // It only searches for a match with the keyword according to command 'gd'
let g:SrcExpl_searchLocalDef = 1
" // Do not let the Source Explorer update the tags file when opening
let g:SrcExpl_isUpdateTags = 0
" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to
" // create/update the tags file
let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase --regex-perl='/^[ \t]*method[ \t]+([^\ \t;\(]+)/\1/m,method,methods/' -R ."
" // Set "<F8>" key for updating the tags file artificially
let g:SrcExpl_updateTagsKey = "<F8>"

" // Set "<F3>" key for displaying the previous definition in the jump list
let g:SrcExpl_prevDefKey = "<F3>"
" // Set "<F4>" key for displaying the next definition in the jump list
let g:SrcExpl_nextDefKey = "<F4>"



"====================================================
"= Tag List
"====================================================
filetype on"vim filetpye on
let Tlist_Ctags_Cmd="/usr/bin/ctags"
let Tlist_Inc_Winwidth=0
let Tlist_Exit_OnlyWindow=1
"window close=off
let Tlist_Auto_Open=0
let Tlist_Use_Right_Window=1

"====================================================
"= Project config
"====================================================
if filereadable(".project.vimrc")
	source .project.vimrc
endif

"====================================================
"= NERD Tree
"====================================================
let NERDTreeWinPos="left"
let g:NERDTreeDirArrows=0
let NERDTreeQuitOnOpen = 1

"====================================================
"= NERD Commenter
"====================================================
let mapleader = ","

"====================================================
"= tags 설정 (cscope, ctags)
"====================================================

"Cscope의 상대경로 문제를 해결하기 위해서 매번 cscope.out파일을 새로 읽는다.
function! LoadCscope()
  exe "silent cs reset"
  let db = findfile("cscope.out", ".;")
  if (!empty(db))
    let path = strpart(db, 0, match(db, "/cscope.out$"))
    set nocscopeverbose " suppress 'duplicate connection' error
    exe "cs add " . db . " " . path
    set cscopeverbose
  endif
endfunction
au BufEnter /* call LoadCscope()
 
"현재 디렉토리부터 root 디렉토리까지 tags를 찾는다.
set tags=tags;/

"====================================================
"= vim-airline
"====================================================
set ttimeoutlen=50
let g:airline#extensions#tabline#enabled = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline_powerline_fonts = 1
let g:Powerline_symbols = 'fancy'
let g:Powerline_mode_V="V·LINE"
let g:Powerline_mode_cv="V·BLOCK"
let g:Powerline_mode_S="S·LINE"
let g:Powerline_mode_cs="S·BLOCK"
set laststatus=2

"====================================================
"= Check Symbol
"====================================================
source ~/develconfig/plugins/checksymbol.vim

"====================================================
"= Windows Setting
"====================================================
if has("gui_running")
    colorscheme Tomorrow-Night-Eighties
    set background=dark
    set guifont=Bitstream_Vera_Sans_Mono_newro:h10
    set guifontwide=Bitstream_Vera_Sans_Mono_newro:h10:cDEFAULT
    set lines=72
    set columns=110
    set guioptions-=T
    lang mes en_US
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    " To enable the saving and restoring of screen positions.
    let g:screen_size_restore_pos = 1

    " To save and restore screen for each Vim instance.
    " This is useful if you routinely run more than one Vim instance.
    " For all Vim to use the same settings, change this to 0.
    let g:screen_size_by_vim_instance = 1

	" Fast window resizing with +/- keys (horizontal); / and * keys (vertical)
	if bufwinnr(1)
		map <kPlus> <C-W>+
		map <kMinus> <C-W>-
		map <kDivide> <c-w><
		map <kMultiply> <c-w>>
	endif

    vnoremap <C-C>  "+y
    map <C-V>       "+gP
    map <S-Insert>  "+gP

    cd ~

    " function area
    function! ScreenFilename()
        if has('amiga')
            return "s:.vimsize"
        elseif has('win32')
            return $HOME.'\_vimsize'
        else
            return $HOME.'/.vimsize'
        endif
    endfunction

    function! ScreenRestore()
        " Restore window size (columns and lines) and position
        " from values stored in vimsize file.
        " Must set font first so columns and lines are based on font size.
        let f = ScreenFilename()
        if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
            let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
            for line in readfile(f)
                let sizepos = split(line)
                if len(sizepos) == 5 && sizepos[0] == vim_instance
                    silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
                    silent! execute "winpos ".sizepos[3]." ".sizepos[4]
                    return
                endif
            endfor
        endif
    endfunction

    function! ScreenSave()
        " Save window size and position.
        if has("gui_running") && g:screen_size_restore_pos
            let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
            let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
                        \ (getwinposx()<0?0:getwinposx()) . ' ' .
                        \ (getwinposy()<0?0:getwinposy())
            let f = ScreenFilename()
            if filereadable(f)
                let lines = readfile(f)
                call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
                call add(lines, data)
            else
                let lines = [data]
            endif
            call writefile(lines, f)
        endif
    endfunction

    if !exists('g:screen_size_restore_pos')
        let g:screen_size_restore_pos = 1
    endif
    if !exists('g:screen_size_by_vim_instance')
        let g:screen_size_by_vim_instance = 1
    endif
    autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
    autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

if !has("gui_running")
    let g:airline#extensions#tabline#left_sep = '|'
    colorscheme lodestone

    " call plug#begin()
    " Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    " Plug 'junegunn/fzf.vim'
    " call plug#end()
endif

let $LOCAL_VIMRC = $HOME.'/.vimrc_local'
if filereadable($LOCAL_VIMRC)
    source $LOCAL_VIMRC
endif

execute pathogen#infect()
filetype plugin indent on
