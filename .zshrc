# ~~~~~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

setopt extended_glob null_glob

path=(
    $path
    $HOME/bin
    $SCRIPTS
    $HOME/.local/bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $HOME/.npm-global/bin
)

# Remove duplicates and non-entries
typeset -U path
path=($^path(N-/))

export PATH

# ~~~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

set -o vi

export EDITOR='nvim'

export WORK="$HOME/ensodata"
export BROWSER='arc'
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$DOTFILES/scripts"

export MANPATH=$(manpath)

export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"

export WORKENV="$WORK/.environ"
export XDG_CONFIG_HOME="$HOME"/.config


# ~~~~~~~~~~~~~~~~~~~~~~ OMZ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# ZSH_THEME="arrow" # set by `omz`

zstyle ':omz:update' mode auto      # update automatically without asking

plugins=(git thefuck python zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ~~~~~~~~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# ~~~~~~~~~~~~~~~~~~~~~~ Pyenv ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"


# ~~~~~~~~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

PURE_GIT_PULL=0


if [[ "$OSTYPE" == darwin* ]]; then
  fpath+=("$(brew --prefix)/share/zsh/site-functions")
else
  fpath+=($HOME/.zsh/pure)
fi

autoload -U promptinit; promptinit
prompt pure


# ~~~~~~~~~~~~~~~~~~~~~~ Alias ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

alias v="nvim"
alias py="python"
alias c="clear"

# Enso Alias 

alias enso='cd ~/ensodata'

# Python package managers and virtual environement creation

alias vnv='source venv/bin/activate'
alias vn3='source venv3/bin/activate'
alias penv='pipenv shell'
alias psh='poetry shell'
alias pu='poetry update'

# Directory Navigation

alias la='ls -a'
alias ll='ls -FGlAhp'
alias mem='top -o mem'
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stpat,vsize,rss,time,command | head -10'
alias ~="cd ~"                              # ~:            Go Home
alias rmgz="~/ensodata/scripts/remove_gz.sh" # Remove the gz extension
alias dl='cd ~/Downloads'
alias dt='cd ~/Desktop'

bd () {
    CD_NUM=1
    if [ ! -z ${1} ]; then
        CD_NUM=$1
        if [[ -z "${CD_NUM}" || ! "${CD_NUM}" =~ ^[0-9]+$ ]]; then
            echo "Usage: bd <number of dirs>"
            return 1
        fi
    fi
    bd_cmd=""
    for ((i=0; i<${CD_NUM}; i++)); do
        bd_cmd="${bd_cmd}""../"
    done
    cd "${bd_cmd}" && ls
}

# Christian's bad ass prompt for opening any file, previewing and then launching nvim

vif () {
   VFILE=$(fzf --preview='bat --color=always {}')
   [[ -n ${VFILE} ]] && echo "${VFILE}" && nvim "${VFILE}"
}

# Brew

alias bu='brew update && brew upgrade && brew cleanup'

# Git

alias gcb='git branch --merged | egrep -v "(^\*|trunk)" | xargs git branch -d;'
alias gl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all
"
alias gr="git rebase -i"
alias gc="git checkout"

#   extract:  Extract most know archives with one command
extract () {
    if [ -f $1 ] ; then
        case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
            esac
        else
            echo "'$1' is not a valid file"
        fi
}

# ~~~~~~~~~~~~~~~~~~~~~~ gsutil ~~~~~~~~~~~~~~~~~~~~~~~~~~

if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# ~~~~~~~~~~~~~~~~~~~~~ Homebrew ~~~~~~~~~~~~~~~~~~~~~~~~~~

eval "$(/opt/homebrew/bin/brew shellenv)"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ FZF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
