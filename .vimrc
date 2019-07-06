" ------------------------------------------------------------
" Install vim-plug First
" ------------------------------------------------------------
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


" ------------------------------------------------------------
" ----- VIMRC RELOADING AND EDITING 
" ------------------------------------------------------------

" Quickly edit/reload this configuration file
nnoremap gev :e $MYVIMRC<CR>
nnoremap gegv :e $MYGVIMRC<CR>

if has ('autocmd') " Remain compatible with earlier versions
 augroup vimrc     " Source vim configuration upon save
    autocmd! BufWritePost $MYVIMRC source % | echom "Reloaded " . $MYVIMRC | redraw
    autocmd! BufWritePost $MYGVIMRC if has('gui_running') | so % | echom "Reloaded " . $MYGVIMRC | endif | redraw
  augroup END
endif " has autocmd

" ------------------------------------------------------------
" ----- STORE SWP FILES ELSEWHERE
" ------------------------------------------------------------
" mkdir ~/.vimswap
set directory=~/.vimswap//
silent !mkdir ~/.vimswap  > /dev/null 2>&1


" ------------------------------------------------------------
" ----- SET LEADER TO SPACE
" ------------------------------------------------------------
let mapleader = "\<Space>"

" ------------------------------------------------------------
" ----- MOVE BETWEEN BUFFERS WITH CTRL-<direction>
" ------------------------------------------------------------
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

" ------------------------------------------------------------
" ----- MOVE THROUGH QUICKFIXLIST WITH CTRL-n/p
" ------------------------------------------------------------
map <C-n> :cnext<CR>
map <C-p> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" ------------------------------------------------------------
" ----- MORE NATURAL SPLIT OPENING
" ------------------------------------------------------------
set splitbelow
set splitright

" ------------------------------------------------------------
" ----- EASIER MOVEMENT BETWEEN TABS
" ------------------------------------------------------------
noremap <S-l> gt
noremap <S-h> gT

" ------------------------------------------------------------
" ----- QUIT FILES WITH LEADER + Q
" ------------------------------------------------------------
noremap <leader>q :q<cr>

" ------------------------------------------------------------
" ----- SAVE FILES WITH LEADER + S
" ------------------------------------------------------------
noremap <leader>s :w<cr>

" ------------------------------------------------------------
" ----- FIX AUTOCOMPLETE
" ------------------------------------------------------------
"
"  work in progress - would be good to have TAB complete,
"  should look at some of the plugins 
"
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
  \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
  \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'


" ------------------------------------------------------------
" ----- SET AUTOWRITE - write file on build, etc
" ------------------------------------------------------------
set autowrite

" ------------------------------------------------------------
" ----- SET showtabline = 2 - always show tabline
" ------------------------------------------------------------
set showtabline=2

" ------------------------------------------------------------
" ----- Ensure syntax highlighting still works even on long
" ----- lines - turn it off it having probs
" ------------------------------------------------------------
set synmaxcol=0

" ------------------------------------------------------------
" ----- PREFER TO OPEN THINGS IN TABS
" ------------------------------------------------------------
set switchbuf=usetab,newtab

" ------------------------------------------------------------
" ----- VIMPLUG
" ------------------------------------------------------------

call plug#begin('~/.vim/plugged')

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'haya14busa/incsearch.vim'
Plug 'scrooloose/nerdcommenter' 
Plug 'easymotion/vim-easymotion' 

Plug 'pangloss/vim-javascript'

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'nsf/gocode', { 'rtp': 'vim', 'do': '~/.vim/plugged/gocode/vim/symlink.sh' }


" help splitjoin - this moves code in various languages from multiline to
" single line and back again
Plug 'AndrewRadev/splitjoin.vim'

" Initialize plugin system
call plug#end()


set rtp+=/usr/local/opt/fzf

" ------------------------------------------------------------
" ----- set up Syntastic stuff
" ------------------------------------------------------------
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

let g:syntastic_python_checkers=['flake8']
" ------------------------------------------------------------
" ----- NERDTree
" ------------------------------------------------------------
nnoremap <leader>n :NERDTreeToggle<CR>

" ------------------------------------------------------------
" ----- incsearch 
" ----- see https://github.com/haya14busa/incsearch.vim
" ------------------------------------------------------------
map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

" :h g:incsearch#auto_nohlsearch
set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)


" ------------------------------------------------------------
" ------------------------------------------------------------
" ------------------------------------------------------------
"  FileType configurations
" ------------------------------------------------------------
" ------------------------------------------------------------
" ------------------------------------------------------------

" ------------------------------------------------------------
" ----- go files
" ------------------------------------------------------------
let g:go_test_timeout = '10s' "10s is the default
let g:go_fmt_command = "goimports" " use goimports on save to fix imports up

autocmd FileType go nmap <leader>r <Plug>(go-run)
autocmd FileType go nmap <leader>t <Plug>(go-test)

" run :GoBuild or :GoTestCompile based on the go file
function! s:build_go_files()
  let l:file = expand('%')
  if l:file =~# '^\f\+_test\.go$'
    call go#test#Test(0, 1)
  elseif l:file =~# '^\f\+\.go$'
    call go#cmd#Build(0)
  endif
endfunction

autocmd FileType go nmap <leader>b :<C-u>call <SID>build_go_files()<CR>
autocmd FileType go nmap <leader>c <Plug>(go-coverage-toggle)
autocmd FileType go nmap <leader>cb <Plug>(go-coverage-browser)

autocmd FileType go imap <leader>, <C-x><C-o>

" extra go highlighting options
let g:go_highlight_build_constraints = 1

let g:go_auto_type_info = 1
let g:go_info_mode = 'gocode'


