# Antigen ------------------------------------------------------------------{{{
    [ -f ~/.antigen/antigen.zsh  ] || git clone https://github.com/zsh-users/antigen.git "${HOME}/.antigen"
    source ~/.antigen/antigen.zsh

    antigen use oh-my-zsh
    antigen bundle colored-man-pages
    antigen bundle git
    antigen bundle docker

    antigen bundle zsh-users/zsh-syntax-highlighting
    antigen bundle wu-nerd/fasd
    antigen bundle supercrabtree/k
    antigen bundle zsh-users/zsh-autosuggestions
    antigen bundle zsh-users/zsh-completions

    antigen theme https://github.com/denysdovhan/spaceship-zsh-theme spaceship
    export SPACESHIP_TIME_SHOW=true
    antigen apply
# }}}
# Configuration-------------------------------------------------------------{{{
#   This for vim theme in tmux ---------------------------------------------{{{
        export TERM=screen-256color
#   }}}
#   Emacs key binding ------------------------------------------------------{{{
        bindkey '^P' up-line-or-search
        bindkey '^N' down-line-or-search
#   }}}
#   Set vim as the default editor-------------------------------------------{{{
        export VISUAL=vim
        export EDITOR="$VISUAL"
#    }}}
#   Use EscEsc to sudo the last command or the current command--------------{{{
        sudo-command-line() {
            # If current buffer is empth, get the last command
            [[ -z $BUFFER ]] && zle up-history
            # If the command not start with sudo
            [[ $BUFFER != sudo\ * ]] && {
              typeset -a bufs
              bufs=(${(z)BUFFER})
              # If the first word in BUFFER is an alias, replace is with
              # it's value
              if (( $+aliases[$bufs[1]] )); then
                bufs[1]=$aliases[$bufs[1]]
              fi
              bufs=(sudo $bufs)
              BUFFER=$bufs
            }
            zle end-of-line
        }
        zle -N sudo-command-line
        bindkey "\e\e" sudo-command-line
#   }}}
#   Use percol in Ctrl-R ---------------------------------------------------{{{
        function exists { which $1 &> /dev/null }

        if exists percol; then
            function percol_select_history() {
                local tac
                exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
                BUFFER=$(fc -l -n 1 | eval $tac | percol --query "$LBUFFER")
                CURSOR=$#BUFFER         # move cursor
                zle -R -c               # refresh
            }

            zle -N percol_select_history
            bindkey '^R' percol_select_history
        fi
#   }}}
#   Prevent iTerm2 from closing when typeing Ctrl-D ------------------------{{{
        set -o ignoreeof
#   }}}
#   Load private configration ----------------------------------------------{{{
        [ -f ~/.zshrc.private ] && source ~/.zshrc.private
#   }}}
#   Speeds up for pasting in zsh-autosuggestions ---------------------------{{{
        # https://github.com/zsh-users/zsh-autosuggestions/issues/238
        pasteinit() {
            OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
            zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
        }

        pastefinish() {
            zle -N self-insert $OLD_SELF_INSERT
        }
        zstyle :bracketed-paste-magic paste-init pasteinit
        zstyle :bracketed-paste-magic paste-finish pastefinish
#   }}}
#   Complete for brew installed formulaes ----------------------------------{{{
        fpath=(/usr/local/share/zsh/site-functions $fpath)
        # The following lines were added by compinstall
        # End of lines added by compinstall
        zstyle :compinstall filename '/Users/nerd/.zshrc'

        autoload -Uz compinit
        compinit
#   }}}
# }}}
# Functions ----------------------------------------------------------------{{{
#   Extract ----------------------------------------------------------------{{{
#       From alias.sh
        extract () {
            if [ -f $1 ] ; then
              case $1 in
                *.tar.bz2)   tar xjf $1             ;;
                *.tar.gz)    tar xzf $1             ;;
                *.tar.xz)    tar xvf $1             ;;
                *.bz2)       bunzip2 $1             ;;
                *.rar)       unrar e $1             ;;
                *.gz)        gunzip $1              ;;
                *.tar)       tar xf $1              ;;
                *.tbz2)      tar xjf $1             ;;
                *.tgz)       tar xzf $1             ;;
                *.zip)       unzip -O GB18030 $1    ;;
                *.Z)         uncompress $1          ;;
                *.7z)        7z x $1                ;;
                *)     echo "'$1' cannot be extracted via extract()" ;;
                 esac
             else
                 echo "'$1' is not a valid file"
             fi
        }
#   }}}
#   Ltree ------------------------------------------------------------------{{{
        ltree()
        {
            tree -C $* | less -FXRS
        }
#   }}}
#   Psg --------------------------------------------------------------------{{{
        psg () {
            ps -o pid,pmem,pcpu,command -A |grep -v grep|grep $1\
                |awk '{printf "%-7s%-5s%-5s%-7s\n", $1,$2,$3,$4" "$5" "$6}'
        }
#   }}}
#   Run the previous cmd and grep the output then pip to less --------------{{{
        ge () {
            if [ $# -ne 0 ] ; then
                CURRENT_COMMAND="`echo $LAST_COMMAND` | grep $*"
                eval $CURRENT_COMMAND
            fi
        }
#   }}}
#   Expand alias------------------------------------------------------------{{{
        # When input space, expand alias -----------------------------------{{{
        expand_alias_space () {
            zle _expand_alias
            zle self-insert
        }
        zle -N expand_alias_space
        bindkey " " expand_alias_space
        # }}}
        # When input enter, expand alias -----------------------------------{{{
        expand_alias_enter () {
            if [[ -z $BUFFER ]]
            then
                zle clear-screen
            else
                zle _expand_alias
                zle accept-line
                # Remember the last command, useful in some alias
                # Add space at the beginning of a command, this command won't
                # show up in history, so use variables to store the command
                LAST_COMMAND=$CURRENT_COMMAND
                CURRENT_COMMAND=$BUFFER
            fi
        }
        zle -N expand_alias_enter
        bindkey "^M" expand_alias_enter
        # Suggestion will clear when press enter, or suggestion will be shown
        # as part to previous cmmands
        ZSH_AUTOSUGGEST_CLEAR_WIDGETS=expand_alias_enter
        # }}}
#   }}}
#   Enter a dir contains $1-------------------------------------------------{{{
    # Stolen from https://github.com/fcoury/dotfiles-1/blob/master/.zshrc
        function cdf () {
            cd *$1*/
        }
#   }}}
#   Less with highlith or run the last command and pip to less--------------{{{
        le() {
            if [ $# -eq 0 ]
            then
                CURRENT_COMMAND="`echo $LAST_COMMAND` | less -FXRS"
                eval $CURRENT_COMMAND
                # Pipe to less didn't change anything and may case some problem
                # when run this command twice. So we delete that part.
                CURRENT_COMMAND="`echo $LAST_COMMAND`"
            else
                pygmentize -O bg=dark $1|less -FXRS
            fi
        }
#   }}}
#   Get the Xst column of clipboard ----------------------------------------{{{
        cl() {
            if [ -z "$2" ]
            then
                pbpaste | awk '{print $'$1'}'
            else
                pbpaste | awk -F $2 '{print $'$1'}'
            fi
        }
        # And copy back to clipboack
        ccl() {
            if [ -z "$2" ]
            then
                pbpaste | awk '{print $'$1'}' | pbcopy
            else
                pbpaste | awk -F $2 '{print $'$1'}' | pbcopy
            fi
        }
#   }}}
#   Cd to the path of the front Finder window ------------------------------{{{
        cdf() {
            target=`osascript -e 'tell application "Finder" to \
                if (count of Finder windows) > 0 \
                then get POSIX path of (target of front Finder window as text)'`
            if [ "$target" != "" ]; then
                cd "$target"; pwd
            else
                echo 'No Finder window found' >&2
            fi
        }
#   }}}
# }}}
# Alias --------------------------------------------------------------------{{{
#   Source & edit zshrc ----------------------------------------------------{{{
        alias sz="source ~/.zshrc"
        alias ez="vim ~/.zshrc"
#   }}}
#   Source & edit vimrc ----------------------------------------------------{{{
        alias ev="vim ~/.vimrc"
#   }}}
#   Git --------------------------------------------------------------------{{{
        alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset \
        %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
        alias gfl="git log -p -M --follow --stat --"
#   }}}
#   Show the top 15 progress that gobbling the memory and CPU---------------{{{
        alias psm="ps -o pid,pmem,pcpu,command -A | sort -n -r -k 2 | head -15 | awk '{printf \"%-7s%-5s%-5s%-7s\\n\", \$1,\$2,\$3,\$4\" \"\$5\" \"\$6}'"
        alias psu="ps -o pid,pmem,pcpu,command -A | sort -n -r -k 3 | head -15 | awk '{printf \"%-7s%-5s%-5s%-7s\\n\", \$1,\$2,\$3,\$4\" \"\$5\" \"\$6}'"
#   }}}
#   Colorfull cat ----------------------------------------------------------{{{
        alias ccat='pygmentize -O bg=dark'
#   }}}
#   Fasd -------------------------------------------------------------------{{{
        alias v='fasd -f -e vim'
        alias o='fasd -f -e xdg-open'
        alias sv='fasd -sif -e vim'
        alias so='fasd -sif -e xdg-open'
#   }}}
#   P ----------------------------------------------------------------------{{{
        alias p="percol"
#   }}}
#   Psk --------------------------------------------------------------------{{{
        alias psk="ps aux | percol | awk '{ print \$2 }' | xargs kill -9"
#   }}}
#   brew & brew cask -------------------------------------------------------{{{
        if [[ `uname` == "Darwin"  ]]; then
            alias bi="brew install"
            alias br="brew uninstall"
            alias bs="brew search"
            alias bl="brew list"
            alias bu="brew upgrade"
            alias bud="brew update"
            alias bug="brew upgrade"
            alias bci="brew cask install"
            alias bcr="brew cask uninstall"
            alias bcs="brew cask search"
            alias bcl="brew cask list"
            alias bcu="brew cask upgrade"
            # force install cask to lastest even it's auto update
            alias bcif="brew cask outdated --greedy --verbose | grep -v latest | tee /dev/tty | awk '{print \$1}' | xargs brew cask install --force"
        fi
#   }}}
#   Curl -------------------------------------------------------------------{{{
        alias c='echo ;curl -w "\n
        http_code: %{http_code}
        time_namelookup: %{time_namelookup}
        time_connect: %{time_connect}
        time_appconnect: %{time_appconnect}
        time_pretransfer: %{time_pretransfer}
        time_starttransfer: %{time_starttransfer}
        size_request: %{size_request}
        size_download: %{size_download}
        speed_download: %{speed_download}
        time_total: %{time_total}\n\n" -i '
#   }}}
# }}}
