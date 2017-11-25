syntax enable 		  "enable syntax processing

set smarttab        "gotta be smart about it
set shiftwidth=2    "1 tab = 2 spaces
set tabstop=2 	  	"number of visualspaces per TAB
set softtabstop=2 	"number of spaces in tab when editing
set expandtab		    "Tabs are spaces

set number		      "Show line number
set relativenumber	"Show current line number
set lazyredraw		  "Redraw vim window only when necessary
set showmatch		    "highlight matching braces

set ignorecase      "Ignorecase when searching
set smartcase       "When searching, be smart about case
set incsearch       "Searching acts like it does in browser

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

try
    colorscheme torte
    "colorscheme koehler
catch
endtry

"move vertically by visual line
nnoremap j gj
nnoremap k gk

set encoding=utf8 "Set utf8 as std. encoding and en_US as std. lang
set ffs=unix,dos,mac "Use Unix as std. file type

" Turn backup off, since most stuff is in git
set nobackup
set nowb
set noswapfile

" Map <Space> to / (search)
map <space> /


" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

set laststatus=2 "always show status command

map 0 ^ "Remap VIM 0 to first non-blank character

" Delete trailing white space on save, useful for some filetypes ;)
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre * :call CleanExtraSpaces()
endif

" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

