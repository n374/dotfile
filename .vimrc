" General -------------------------------------------------------------------{{{
    " Set encoding ----------------------------------------------------------{{{
        set encoding=utf-8
    " }}}
    " Set Indent ------------------------------------------------------------{{{
        set autoindent "Preserve current indent on new lines
        set cindent "Set C style indent
    " }}}
    " Show line number and relative number ----------------------------------{{{
        set number
        set relativenumber
    " }}}
    " Highlight current line and column -------------------------------------{{{
        set cursorcolumn
        set cursorline
    " }}}
    " Syntax Highlight ------------------------------------------------------{{{
        syntax on
    " }}}
    " Auto wrap the line in 80 character ------------------------------------{{{
        set textwidth=80
        set formatoptions=tnmM
    " }}}
    " Search ----------------------------------------------------------------{{{
        " Highlight search --------------------------------------------------{{{
        set hlsearch
        " }}}
        " Highlight the next match while still typing out the search pattern {{{
        set incsearch
        " }}}
    " }}}
    " Tab=4 space -----------------------------------------------------------{{{
        set ts=4
        set shiftwidth=4
        set tabstop=4
        set softtabstop=4
        set expandtab
        set backspace=2
    " }}}
    " Fold ------------------------------------------------------------------{{{
        set foldenable
        set foldlevelstart=0
        "setlocal foldlevel=0
            function! MyFoldText() " ----------------------------------------{{{
                let line = getline(v:foldstart)

                let nucolwidth = &fdc + &number * &numberwidth
                let windowwidth = winwidth(0) - nucolwidth - 3
                let foldedlinecount = v:foldend - v:foldstart

                "expand tabs into spaces
                let onetab = strpart('          ', 0, &tabstop)
                let line = substitute(line, '\t', onetab, 'g')
                let line = substitute(line, '----{{'.'{', '-▶▶▶{{'.'{', 'g')

                let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
                let fillcharcount = windowwidth - len(line)
                "return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
                return line . repeat(" ",fillcharcount)
            endfunction " }}}
        set foldtext=MyFoldText()
    " }}}
    " Minimal number of screen lines to keep above and below the cursor------{{{
        set scrolloff=5
    " }}}
    " Show Tabs Enter and trailing blanks------------------------------------{{{
        set list listchars=eol:¬,tab:>\ ,trail:.,
    " }}}
    " Use multiple of shiftwidth when indenting with '<' and '>'-------------{{{
        " http://sfault-image.b0.upaiyun.com/af/fe/affef33b5fab7d26d541457c29e6c3d0_articlex
        set shiftround
    " }}}
    " Highlight the 81st column ---------------------------------------------{{{
        let &colorcolumn=81
    " }}}
    " Open new split panes to right and bottom, which feels more natural ----{{{
        set splitbelow
        set splitright
    " }}}
" }}}
" Key mapping ---------------------------------------------------------------{{{
    " Map leader ------------------------------------------------------------{{{
        let mapleader=","
        let maplocalleader="\\"
    " }}}
    " Jump from one window to another----------------------------------------{{{
        nmap <C-H> <C-W>h
        nmap <C-J> <C-W>j
        nmap <C-K> <C-W>k
        nmap <C-L> <C-W>l
    " }}}
    " Sudo to write ---------------------------------------------------------{{{
        cnoremap w!! w !sudo tee % >/dev/null
    " }}}
    " Fast reloading of the .vimrc ------------------------------------------{{{
        noremap <silent> <leader>ss :source ~/.vimrc<cr>:echom "vimrc sourced"<cr>
    " }}}
    " Fast editing ----------------------------------------------------------{{{
        " Edit the specific file in current window --------------------------{{{
            nnoremap <leader>v :e ~/.vimrc<cr>
            nnoremap <leader>z :e ~/.zshrc<cr>
        " }}}
        " Edit the specific file in a new tab -------------------------------{{{
            nnoremap <leader>tv :tabnew ~/.vimrc<cr>
            nnoremap <leader>tz :tabnew ~/.zshrc<cr>
        " }}}
        " Split the current window and load the specific file ---------------{{{
            nnoremap <leader>sv :split ~/.vimrc<cr>
            nnoremap <leader>sz :split ~/.zshrc<cr>
        " }}}
        " Split the current window vertically and load the specific file ----{{{
            nnoremap <leader>vv :vsplit ~/.vimrc<cr>
            nnoremap <leader>vz :vsplit ~/.zshrc<cr>
        " }}}
    " }}}
    " Searching -------------------------------------------------------------{{{
        nnoremap <leader>si :execute '/' . expand("<cword>")<cr>
        nnoremap <leader>sa :execute '/' . expand("<cWORD>")<cr>
        function! Get_visual_selection()
            " Why is this not a built-in Vim script function?!
            let [lnum1, col1] = getpos("'<")[1:2]
            let [lnum2, col2] = getpos("'>")[1:2]
            let lines = getline(lnum1, lnum2)
            let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
            let lines[0] = lines[0][col1 - 1:]
            return join(lines, "\n")
        endfunction
        vnoremap <leader>si <esc>:execute '/' . Get_visual_selection()<cr>
        " Keep search matches in the middle
        " of the window and pulse the line when
        " moving to them.
            nnoremap n nzzzv
            nnoremap N Nzzzv
        " After search something, you can jump back the line by using 's or
        " jump back to exact postion by using `s
            nnoremap / ms/
            nnoremap ? ms?
    " }}}
    " Set fold method -------------------------------------------------------{{{
        nnoremap <leader>fmk :set fdm=marker<cr>:execute "normal! mfggVGzC`f100zozz"<cr>
        nnoremap <leader>fmn :set fdm=manual<cr>:execute "normal! mfggVGzC`f100zozz"<cr>
        nnoremap <leader>fi :set fdm=indent<cr>:execute "normal! mfggVGzC`f100zozz"<cr>
        nnoremap <leader>fs :set fdm=syntax<cr>:execute "normal! mfggVGzC`f100zozz"<cr>
        nnoremap <leader>fe :set fdm=expr<cr>:execute "normal! mfggVGzC`f100zozz"<cr>
    " }}}
    " Close other fold recursively ------------------------------------------{{{
        nnoremap  <leader>zc :execute "normal! mfzM`f100zozz" <cr>
        " mf:    set mark "f" at current position (hope you not using this mark)
        " zM:    select all the text, close all fold recursively
        " `f100zozz: back to mark "f", seems we need to open all the fold
                    " 100 should be big enough
    " }}}
    " Highlight word --------------------------------------------------------{{{
        " This mini-plugin provides a few mappings for highlighting words temporarily.
        " Sometimes you're looking at a hairy piece of code and would like a certain
        " word or two to stand out temporarily.  You can search for it, but that only
        " gives you one color of highlighting.  Now you can use <leader>N where N is
        " a number from 1-6 to highlight the current word in a specific color.
            function! HiInterestingWord(n) " --------------------------------{{{
                " Save our location.
                normal! mz

                " Yank the current word into the z register.
                normal! "zyiw

                " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
                let mid = 86750 + a:n

                " Clear existing matches, but don't worry if they don't exist.
                silent! call matchdelete(mid)

                " Construct a literal pattern that has to match at boundaries.
                let pat = '\V\<' . escape(@z, '\') . '\>'

                " Actually match the words.
                call matchadd("InterestingWord" . a:n, pat, 1, mid)

                " Move back to our original location.
                normal! `z
            endfunction " }}}
            " Mappings ------------------------------------------------------{{{
                " Add highlighting
                nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
                nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
                nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
                nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
                nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
                nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>
                " Delete highlighting
                nnoremap <silent> <leader>d1 :call matchdelete(86751)<cr>
                nnoremap <silent> <leader>d2 :call matchdelete(86752)<cr>
                nnoremap <silent> <leader>d3 :call matchdelete(86753)<cr>
                nnoremap <silent> <leader>d4 :call matchdelete(86754)<cr>
                nnoremap <silent> <leader>d5 :call matchdelete(86755)<cr>
                nnoremap <silent> <leader>d6 :call matchdelete(86756)<cr>
                nnoremap <silent> <leader>dd :call clearmatches()<cr>
            " }}}
            " !!!!!The following part must after the colorscheme setting
            " If not, copy it manually
            " Default Highlights --------------------------------------------{{{
                hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
                hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
                hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
                hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
                hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
                hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
            " }}}
    " }}}
    " Strong H and L --------------------------------------------------------{{{
        nnoremap H ^
        nnoremap L $
    " }}}
    " Stop highlighting items from the last research ------------------------{{{
        nnoremap <CR> :nohlsearch<cr>
    " }}}
    " Write and source .vimrc -----------------------------------------------{{{
        nnoremap <leader>ws :w<cr>:source ~/.vimrc<cr>:echom "vimrc sourced"<cr>
    " }}}
    " Add/Insert maker ------------------------------------------------------{{{
        " For normal mode ---------------------------------------------------{{{
            nnoremap <leader>am :call AddMarkerNormalMode()<cr>
            function! AddMarkerNormalMode() " -------------------------------{{{
                " Get the indentation
                let IndentLevel=indent('.')/&tabstop
                let IndentInsert=repeat("\<tab>",IndentLevel)
                " Add the second half of marker to a new line
                execute "normal! o".'" }}'.'}'
                if getline('.')=~'\v^ *$'
                    " If this function called from a blank line
                    " just jump to it for first part of marker
                    execute "normal! k0C".IndentInsert
                else
                    " Add a new line for first part of marker
                    execute "normal! O\<esc>0C".IndentInsert
                endif
                " Add the first part of maker
                execute "normal! a\" {{"."{\<esc>hh"
                let CurrentColumn=col('.')
                execute "normal! i" . repeat('-',78-CurrentColumn)
                execute "normal! " . repeat('h',77-CurrentColumn)
                " Enter replace mode to add some plain text
                execute "startreplace"
            endfunction
            " }}}
        " }}}
        " For visual mode ---------------------------------------------------{{{
            " Add marker ----------------------------------------------------{{{
                vnoremap <leader>am mmomn<esc>:call AddMarkerVisualMode(line("'m"),line("'n"))<cr>
                function! AddMarkerVisualMode(pos1,pos2) " ------------------{{{
                    " Make sure pos1 is before pos2
                    if a:pos1>a:pos2
                        let [pos2,pos1]=[a:pos1,a:pos2]
                    else
                        let [pos1,pos2]=[a:pos1,a:pos2]
                    endif
                    " Get the indentation
                    let TabCount=indent('.')/&tabstop
                    let IndentInsert=repeat("\<tab>",TabCount)
                    " Add the later half of marker
                    execute "normal! \<esc>".string(pos2)."Go\<esc>0C".IndentInsert."\" }}"."}"
                    " Add the first part of marker
                    execute "normal! \<esc>".string(pos1)."GO\<esc>0C".IndentInsert."\" {{".'{'."\<esc>hh"
                    execute "normal!  i".repeat('-',78-col('.'))."\<esc>".string(77-col('.')).'h'
                    " Enter replace mode for adding some plain text
                    execute "startreplace"
                endfunction
                " }}}
            " }}}
            " Insert marker -------------------------------------------------{{{
                vnoremap <leader>im mmo<esc>:call InsertMarkerVisualMode(line("'m"),line('.'))<cr>
                function! InsertMarkerVisualMode(pos1,pos2) " ---------------{{{
                    " Make sure pos1 is before pos2
                    if a:pos1>a:pos2
                        let [pos2,pos1]=[a:pos1,a:pos2]
                    else
                        let [pos1,pos2]=[a:pos1,a:pos2]
                    endif
                    " Get the indentation
                    let TabCount=indent('.')/&tabstop
                    let IndentInsert=repeat("\<tab>",TabCount)
                    " Add the later half of marker
                    execute "normal! \<esc>".string(pos2)."Go\<esc>0C".IndentInsert."\" }}"."}"
                    " Insert the first part of marker
                    execute "normal! \<esc>".string(pos1)."G$a"." \" {{".'{'."\<esc>hh"
                    execute "normal!  i".repeat('-',78-col('.'))."\<esc>".string(77-col('.')).'h'
                    " Jump back
                    execute "normal! `m"
                endfunction
                " }}}
            " }}}
        " }}}
    " }}}
    " Ack--------------------------------------------------------------------{{{
        nnoremap <leader>ac :silent execute "Ack! --ignore-dir=doc --ignore-file=is:tags -Q " .  shellescape(expand("<cword>")) <cr>
        nnoremap <leader>aC :silent execute "Ack! --ignore-dir=doc --ignore-file=is:tags -Q " .  shellescape(expand("<cWORD>"))<cr>
        vnoremap <leader>ac <esc>:silent execute "Ack! --ignore-dir=doc --ignore-file=is:tags -Q \"" . Get_visual_selection() . "\"" <cr>
    " " }}}
    " Fold-------------------------------------------------------------------{{{
        " Use space to toggle the current fold
            nnoremap <space> za
            vnoremap <space> za
        " Close the fold which the current fold in recursively
        " If using gvim, it could be convenient
            nnoremap <S-Space> :execute "normal! mf[zzAVzC`f"<cr>
            vnoremap <S-Space> :execute "normal! mf[zzAVzC`f"<cr>
        " If using vim in a terminal, use this instead
            nnoremap <leader><space> :execute "normal! mf[zzAVzC`f"<cr>
            vnoremap <leader><space> :execute "normal! mf[zzAVzC`f"<cr>
    " }}}
    " Copy to/Paste from system's clipboard----------------------------------{{{
        vnoremap <c-c> "+y
        " "+p for paste clipord, gp for move cursor after pasted text
        inoremap <c-v> <esc>"+gpi
    " }}}
    " If multiple matches when navigate using ctags, list them all ----------{{{
        nnoremap <c-]> g<c-]>
    " }}}
" }}}
" Plugins  ------------------------------------------------------------------{{{
    " Vundle ----------------------------------------------------------------{{{
        set nocompatible              " be iMproved, required
        filetype off                  " required

        " set the runtime path to include Vundle and initialize
        if empty(glob("~/.vim/bundle/Vundle.vim"))
            echo "Vundle not exists, downloading"
            !git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
        endif
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
        " alternatively, pass a path where Vundle should install plugins
        "call vundle#begin('~/some/path/here')

        " let Vundle manage Vundle, required
        Plugin 'gmarik/Vundle.vim'

        " All of your Plugins must be added before the following line
        call vundle#end()            " required
        filetype plugin indent on    " required
        " To ignore plugin indent changes, instead use:
        "filetype plugin on
        "
        " Brief help
        " :PluginList       - lists configured plugins
        " :PluginInstall    - installs plugins; append `!` to update or just
        " :PluginUpdate
        " :PluginSearch foo - searches for foo; append `!` to refresh local cache
        " :PluginClean      - confirms removal of unused plugins; append `!` to
        " auto-approve removal
        "
        " see :h vundle for more details or wiki for FAQ
        " Put your non-Plugin stuff after this line

" }}}
    " Airline ---------------------------------------------------------------{{{
        Bundle "bling/vim-airline"
        Bundle "vim-airline/vim-airline-themes"
        set laststatus=2
        let g:airline#extensions#tabline#enabled = 1
        let g:airline_powerline_fonts = 1
        let g:airline_theme = 'badwolf'
" }}}
    " RainbowParentheses ----------------------------------------------------{{{
        Bundle "kien/rainbow_parentheses.vim"
        let g:rbpt_max = 16
        let g:rbpt_loadcmd_toggle = 0
        au VimEnter * RainbowParenthesesToggle
        au Syntax * RainbowParenthesesLoadRound
        au Syntax * RainbowParenthesesLoadSquare
        au Syntax * RainbowParenthesesLoadBraces
    " }}}
    " YouCompleteMe ---------------------------------------------------------{{{
        Bundle 'Valloric/YouCompleteMe'
        "Close the warning of -----------------------------------------------{{{
            " ValueError: Still no compile flags, no completions yet"
            let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
        " }}}
        " Completion for keywords
        let g:ycm_seed_identifiers_with_syntax = 1
        " Make YCM and Eclim play nice
        let g:EclimCompletionMethod = 'omnifunc'
        " Auto close preview window
        let g:ycm_autoclose_preview_window_after_completion=1
    " }}}
    " DelimitMate -----------------------------------------------------------{{{
        " Auto completion for quotes, parens, etc
        Bundle "Raimondi/delimitMate"
        let delimitMate_expand_space=1
        let delimitMate_expand_cr=1
    " }}}
    " Nerdtree --------------------------------------------------------------{{{
        Bundle "scrooloose/nerdtree"
        let NERDTreeIgnore=['.*pyc', 'tag']
        map <F3> :NERDTreeToggle<cr>
    " }}}
    " IndentLine ------------------------------------------------------------{{{
        " Display vertical lines at indentation level
        Bundle "Yggdroot/indentLine"
        let g:indentLine_char = '┆'
        let g:indentLine_color_term = 239
    " }}}
    " Syntastic -------------------------------------------------------------{{{
        Bundle "scrooloose/syntastic"
    " }}}
    " EasyMotion ------------------------------------------------------------{{{
        " Move like open urls by Vimium in Chrome
        Bundle 'Lokaltog/vim-easymotion'
    " }}}
    " CtrlP -----------------------------------------------------------------{{{
        Bundle "kien/ctrlp.vim"
        let g:ctrlp_map = '<c-p>'
        let g:ctrlp_cmd = 'CtrlP'
        " Follow symbolic links when listing files but ignore looped internal
        " symlinks to avoid duplicates
        let g:ctrlp_follow_symlinks=1
        let g:ctrlp_working_path_mode = 'w'
    " }}}
    " Nerdcommenter ---------------------------------------------------------{{{
        Bundle "scrooloose/nerdcommenter"
            " Usage ---------------------------------------------------------{{{
                "[count]<leader>cc |NERDComComment|
                "Comment out the current line or text selected in visual mode.
                "
                "[count]<leader>cn |NERDComNestedComment|
                "Same as <leader>cc but forces nesting.
                "
                "[count]<leader>c |NERDComToggleComment|
                "Toggles the comment state of the selected line(s). If the topmost
                "selected line is commented, all selected lines are uncommented and vice
                "versa.
                "
                "[count]<leader>cm |NERDComMinimalComment|
                "Comments the given lines using only one set of multipart delimiters.
                "
                "[count]<leader>ci |NERDComInvertComment|
                "Toggles the comment state of the selected line(s) individually.
                "
                "[count]<leader>cs |NERDComSexyComment|
                "Comments out the selected lines ``sexily''
                "
                "[count]<leader>cy |NERDComYankComment|
                "Same as <leader>cc except that the commented line(s) are yanked first.
                "
                "<leader>c$ |NERDComEOLComment|
                "Comments the current line from the cursor to the end of line.
                "
                "<leader>cA |NERDComAppendComment|
                "Adds comment delimiters to the end of line and goes into insert mode
                "between them.
                "
                "|NERDComInsertComment|
                "Adds comment delimiters at the current cursor position and inserts
                "between. Disabled by default.
                "
                "<leader>ca |NERDComAltDelim|
                "Switches to the alternative set of delimiters.
                "
                "[count]<leader>cl
                "[count]<leader>cb |NERDComAlignedComment|
                "Same as |NERDComComment| except that the delimiters are aligned down
                "the left side (<leader>cl) or both sides (<leader>cb).
                "
                "[count]<leader>cu |NERDComUncommentLine|
                "Uncomments the selected line(s).
            " }}}
    " }}}
    " SrcExpl ---------------------------------------------------------------{{{
        " Source Explorer
        "   This plugin will change current working directory
        "   go find and comment the command below:
        "       exe "set autochdir"
        Bundle "vim-scripts/SrcExpl"
        nmap <C-I> <C-W>j:call g:SrcExpl_Jump()<CR>
        nmap <C-O> :call g:SrcExpl_GoBack()<CR>
        " // The switch of the Source Explorer
        nmap <F8> :SrcExplToggle<CR>

        " // Set the height of Source Explorer window
        let g:SrcExpl_winHeight = 15

        " // Set 100 ms for refreshing the Source Explorer
        let g:SrcExpl_refreshTime = 100

        " // Set "Enter" key to jump into the exact definition context
        let g:SrcExpl_jumpKey = "<nop>"

        " // Set "Space" key for back from the definition context
        " Conflit with the fold key, chang "space" key to anything else
        let g:SrcExpl_gobackKey = "<nop>"

        " // In order to Avoid conflicts, the Source Explorer should know what plugins
        " // are using buffers. And you need add their bufname into the list below
        " // according to the command ":buffers!"
        let g:SrcExpl_pluginList = [
                \ "__Tag_List__",
                \ "_NERD_tree_",
                \ "Source_Explorer"
            \ ]

        " // Enable/Disable the local definition searching, and note that this is not
        " // guaranteed to work, the Source Explorer doesn't check the syntax for now.
        " // It only searches for a match with the keyword according to command 'gd'
        let g:SrcExpl_searchLocalDef = 1

        " // Do not let the Source Explorer update the tags file when opening
        let g:SrcExpl_isUpdateTags = 0

        " // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to
        " //  create/update a tags file
        let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ."

        " // Set "<F12>" key for updating the tags file artificially
        "let g:SrcExpl_updateTagsKey = "<F12>"

        " SrcExpl will map <Tab> to <C-W>j:call g:SrcExpl_Jump()<CR>
        " Unmap it and map it to whatever you want to map
        nnoremap <C-I> <C-W>j:call g:SrcExpl_Jump()<CR>
        nunmap <Tab>
    " }}}
    " Python-syntax ---------------------------------------------------------{{{
        " Python syntax highlighting script for vim
        Bundle "hdima/python-syntax"
        let python_highlight_all = 1
    " }}}
    " Ack -------------------------------------------------------------------{{{
        " Ack in vim
        Bundle "mileszs/ack.vim"
             " Usage --------------------------------------------------------{{{
                 ":Ack [options] {pattern} [{directories}]
             "}}}
             " Keyboard Shortcuts -------------------------------------------{{{
                 "o    to open (same as enter)
                 "O    to open and close quickfix window
                 "go   to preview file (open but maintain focus on ack.vim
                 "results)
                 "t    to open in new tab
                 "T    to open in new tab silently
                 "h    to open in horizontal split
                 "H    to open in horizontal split silently
                 "v    to open in vertical split
                 "gv   to open in vertical split silently
                 "q    to close the quickfix window
             "}}}
    " }}}
    " TabBar ----------------------------------------------------------------{{{
        Plugin 'majutsushi/tagbar'
        map <F4> :TagbarToggle<cr>
    " }}}
    " Theme -----------------------------------------------------------------{{{
        Plugin 'tomasr/molokai'
        " Plugin 'altercation/vim-colors-solarized'

        set term=screen-256color
        let g:molokai_original = 1
        let g:rehash256 = 1
        set background=dark
        colorscheme molokai

        " The following part copy from key mapping-Highlighting words
        " This part must be after colorscheme setting
        " Default Highlights ------------------------------------------------{{{
            hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
            hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
            hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
            hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
            hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
            hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
        " }}}
    " }}}
    " Mark ------------------------------------------------------------------{{{
        Bundle 'vim-scripts/Mark--Karkat'
    " }}}
    " Vim-windowswap --------------------------------------------------------{{{
        Bundle "wesQ3/vim-windowswap"
    " }}}
    " Vim-tmux-navigator ----------------------------------------------------{{{
        Plugin 'christoomey/vim-tmux-navigator'
        let g:tmux_navigator_no_mappings = 1

        nnoremap <silent> <C-H> :TmuxNavigateLeft<cr>
        nnoremap <silent> <C-J> :TmuxNavigateDown<cr>
        nnoremap <silent> <C-k> :TmuxNavigateUp<cr>
        nnoremap <silent> <C-l> :TmuxNavigateRight<cr>
        nnoremap <silent> <C-/> :TmuxNavigatePrevious<cr>
    " }}}
    " Vim-gitgutter ---------------------------------------------------------{{{
        " Show git diff in gugger
        Plugin 'airblade/vim-gitgutter'
    " }}}
    " Tcd -------------------------------------------------------------------{{{
        " Different work directory in different tab
        " by using :Tcd directory
        Plugin 'vim-scripts/tcd.vim'
    " }}}
    " InstantMarkdown -------------------------------------------------------{{{
        Bundle "suan/vim-instant-markdown"
    " }}}
    " Vim-oscyank -----------------------------------------------------------{{{
        " Copy text from remote vim to system clipboard
        " Terminal emulator should support OSC52
        Bundle 'ojroques/vim-oscyank'
        vnoremap <c-c> :OSCYank<CR>
        let g:oscyank_term = 'default'
    " }}}
" }}}
" Autocommands --------------------------------------------------------------{{{
    " Foldmethod ------------------------------------------------------------{{{
        autocmd! Filetype vim set foldmethod=marker
        autocmd! Filetype zsh set foldmethod=marker
        autocmd! Filetype java set foldmethod=indent
        autocmd! Filetype c set foldmethod=indent
    " }}}
    " Restore cursor to file position in previous edit session---------------{{{
        autocmd! BufReadPost *
                    \ if line("'\"") > 0 && line("'\"") <= line("$") |
                    \   execute "normal! g`\"" |
                    \ endif
    " }}}
    " Detect *.md as Markdown -----------------------------------------------{{{
        autocmd BufNewFile,BufReadPost *.md set filetype=markdown
    " }}}
    " Python ----------------------------------------------------------------{{{
        autocmd! Filetype python
                \ setlocal indentexpr=GetGooglePythonIndent(v:lnum) |
                \ " maximum number of lines to look backwards. |
                \ let s:maxoff = 50 |
                \ function GetGooglePythonIndent(lnum)
                \
                \   " Indent inside parens. |
                \   " Align with the open paren unless it is at the end of the line. |
                \   " E.g. |
                \   "   open_paren_not_at_EOL(100, |
                \   "                         (200, |
                \   "                          300), |
                \   "                         400) |
                \   "   open_paren_at_EOL( |
                \   "       100, 200, 300, 400) |
                \   call cursor(a:lnum, 1)
                \   let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
                \          "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
                \          . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
                \          . " =~ '\\(Comment\\|String\\)$'")
                \   if par_line > 0
                \     call cursor(par_line, 1)
                \     if par_col != col("$") - 1
                \       return par_col
                \     endif
                \   endif
                \
                \   " Delegate the rest to the original function. |
                \   return GetPythonIndent(a:lnum)
                \ endfunction |
                \ |
                \ let pyindent_nested_paren="&sw*2" |
                \ let pyindent_open_paren="&sw*2"
        autocmd! Filetype python
                \ setlocal foldmethod=indent |
                \ nnoremap <buffer> <c-]>
                        \ :YcmCompleter GoToDefinitionElseDeclaration<CR> |
                \ nnoremap <buffer> <c-t>
                        \ <c-o>
    " }}}
    " Thrfit ----------------------------------------------------------------{{{
        autocmd BufNewFile,BufReadPost *.thrift set filetype=thrift
    " }}}
" }}}
