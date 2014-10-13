# Oh-my-zsh things-----------------------------------------------------------{{{
    # Path to your oh-my-zsh installation.
    export ZSH=$HOME/.oh-my-zsh

    # Set name of the theme to load.
    # Look in ~/.oh-my-zsh/themes/
    # Optionally, if you set this to "random", it'll load a random theme each
    # time that oh-my-zsh is loaded.
    ZSH_THEME="robbyrussell"

    # Uncomment the following line to use case-sensitive completion.
    # CASE_SENSITIVE="true"

    # Uncomment the following line to disable bi-weekly auto-update checks.
    # DISABLE_AUTO_UPDATE="true"

    # Uncomment the following line to change how often to auto-update (in days).
    # export UPDATE_ZSH_DAYS=13

    # Uncomment the following line to disable colors in ls.
    # DISABLE_LS_COLORS="true"

    # Uncomment the following line to disable auto-setting terminal title.
    # DISABLE_AUTO_TITLE="true"

    # Uncomment the following line to enable command auto-correction.
    # ENABLE_CORRECTION="true"

    # Uncomment the following line to display red dots whilst waiting for completion.
    # COMPLETION_WAITING_DOTS="true"

    # Uncomment the following line if you want to disable marking untracked files
    # under VCS as dirty. This makes repository status check for large repositories
    # much, much faster.
    # DISABLE_UNTRACKED_FILES_DIRTY="true"

    # Uncomment the following line if you want to change the command execution time
    # stamp shown in the history command output.
    # The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
    # HIST_STAMPS="mm/dd/yyyy"

    # Would you like to use another custom folder than $ZSH/custom?
    # ZSH_CUSTOM=/path/to/new-custom-folder

    # Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
    # Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
    # Example format: plugins=(rails git textmate ruby lighthouse)
    # Add wisely, as too many plugins slow down shell startup.
    plugins=(git)

    source $ZSH/oh-my-zsh.sh

    # User configuration

    export PATH="/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games=/usr/local/cuda-5.5/bin:/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/gamesi"
    # export MANPATH="/usr/local/man:$MANPATH"

    # You may need to manually set your language environment
    # export LANG=en_US.UTF-8

    # Preferred editor for local and remote sessions
    # if [[ -n $SSH_CONNECTION ]]; then
    #   export EDITOR='vim'
    # else
    #   export EDITOR='mvim'
    # fi

    # Compilation flags
    # export ARCHFLAGS="-arch x86_64"

    # ssh
    # export SSH_KEY_PATH="~/.ssh/dsa_id"

    # Set personal aliases, overriding those provided by oh-my-zsh libs,
    # plugins, and themes. Aliases can be placed here, though oh-my-zsh
    # users are encouraged to define aliases within the ZSH_CUSTOM folder.
    # For a full list of active aliases, run `alias`.
    #
    # Example aliases
    # alias zshconfig="mate ~/.zshrc"
    # alias ohmyzsh="mate ~/.oh-my-zsh"
# }}}
# AutoJump -----------------------------------------------------------------{{{
    [[ -s /usr/share/autojump/autojump.zsh ]] & . /usr/share/autojump/autojump.zsh
# }}}
# Functions ----------------------------------------------------------------{{{
#   Extract ----------------------------------------------------------------{{{
#       From alias.sh
        extract () {
            if [ -f $1 ] ; then
              case $1 in
                *.tar.bz2)   tar xjf $1             ;;
                *.tar.gz)    tar xzf $1             ;;
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
            tree -C $* | less -R
        }
#   }}}
#   Psg --------------------------------------------------------------------{{{
        psg () {
            ps -o pid,pmem,pcpu,command -A |grep -v grep|grep $1\
                |awk '{printf "%-7s%-5s%-5s%-7s\n", $1,$2,$3,$4" "$5" "$6}'
        
        }
#   }}}
#   Lc ---------------------------------------------------------------------{{{
        lc () {
            pygmentize -O bg=dark $1|less
        }
#   }}}
#   Mydict -----------------------------------------------------------------{{{
        mydict () {
            # Show usage
            if [ $# = 1 ]; then
                if [[ $1 == -h || $1 == "--help" ]]; then
                    echo "Usage: add any numbers of words as parameters"
                    echo "Or:    just run mydict and input any numbers of words"
                    echo "  It will translate every words to Chinese and pronounce it"
                    echo "  You need have dict installed"
                    return
                fi
            fi
            # If any parameters, translate them and pronounce them first
            for param in $@; do
                echo "-----------------------------------------------------"
                dict $param
                mplayer http://dict.youdao.com/dictvoice\?audio\=$param > /dev/null 2>&1
                return
            done
            # Translate every word user input which separated by spaces 
            while true; do
                echo -n ">>>"
                read words
                for word in $(echo $words); do
                    echo "-----------------------------------------------------"
                    dict $word
                    mplayer http://dict.youdao.com/dictvoice\?audio\=$word   > /dev/null 2>&1 >&- 
                done
            done
        }
#   }}}
# }}}
# Alias --------------------------------------------------------------------{{{
#   Source & edit zshrc ----------------------------------------------------{{{
        alias sz="source ~/.zshrc"
        alias ez="vim ~/.zshrc"
#   }}}
#   Source & edit vimrc ----------------------------------------------------{{{
        alias sv="source ~/.vimrc"
        alias ev="vim ~/.vimrc"
#   }}}
#   Compact, colorized git log    From alias.sh ----------------------------{{{
        alias gl="git log --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset \
        %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
#   }}}
#   Apt --------------------------------------------------------------------{{{
        alias agd="sudo apt-get update"
        alias agg="sudo apt-get upgrade"
        alias agi="sudo apt-get install"
        alias agr="sudo apt-get remove"
        alias agar="sudo apt-get autoremove"
        alias agac="sudo apt-get autoclean"
        alias acs="apt-cache search"
#   }}}
#   Dpkg -------------------------------------------------------------------{{{
        alias di="sudo dpkg -i"
        alias dr="sudo dpkg -r"
        alias dl="dpkg -l"
#   }}}
#   Show the top 15 progress that gobbling the memory and CPU---------------{{{
        alias psm="ps -o pid,pmem,pcpu,command -A | sort -n -r -k 2 | head -15 \
            | awk '{printf \"%-7s%-5s%-5s%-7s\\n\", \$1,\$2,\$3,\$4\" \"\$5\" \"\$6}'"
        alias psu="ps -o pid,pmem,pcpu,command -A | sort -n -r -k 3 | head -15 \
            | awk '{printf \"%-7s%-5s%-5s%-7s\\n\", \$1,\$2,\$3,\$4\" \"\$5\" \"\$6}'"
#   }}}
#   Just for fun -----------------------------------------------------------{{{
        alias please="sudo"
#   }}}
#   Colorfull cat ----------------------------------------------------------{{{
        alias ccat='pygmentize -O bg=dark'
#   }}}
#   Clear ------------------------------------------------------------------{{{
        alias c="clear"
#   }}}
# }}} 
