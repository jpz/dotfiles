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
" ----- SET AUTOWRITE - write file on build, etc
" ------------------------------------------------------------
set autowrite

" ------------------------------------------------------------
" ----- SET showtabline = 2 - always show tabline
" ------------------------------------------------------------
set showtabline=2

" ------------------------------------------------------------
" ----- PREFER TO OPEN THINGS IN TABS
" ------------------------------------------------------------
set switchbuf=usetab,newtab

" ------------------------------------------------------------
" ----- VIMPLUG
" ------------------------------------------------------------
"  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-syntastic/syntastic'
Plug 'vim-airline/vim-airline'

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }


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

" extra go highlighting options
let g:go_highlight_build_constraints = 1

