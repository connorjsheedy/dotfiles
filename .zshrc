# ~~~~~~~~~~~~~~~~~~~ Path Configuration ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# zmodload zsh/zprof
autoload -U +X compinit && compinit

setopt extended_glob null_glob

path=(
    $path
    $HOME/bin
    $SCRIPTS
    $HOME/.local/bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $HOME/.pyenv/shims
    $HOME/.antigravity/antigravity/bin
    /opt/homebrew/bin
)


# Remove duplicates and non-entries
typeset -U path
path=($^path(N-/))

export PATH

# ~~~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
set -o vi

export EDITOR='nvim'
export SHELL="/bin/zsh"

export WORK="$HOME/ensodata"
export BROWSER='zen'
export DOTFILES="$HOME/dotfiles"
export SCRIPTS="$DOTFILES/scripts"
export NOTES="$WORK/projects"

export MANPATH=$(manpath)

export LIBRARY_PATH="$LIBRARY_PATH:/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/lib"

export WORKENV="$WORK/.environ"
export XDG_CONFIG_HOME="$HOME/.config"
export TMS_CONFIG_FILE="$DOTFILES/.config/tms/config.toml"

# ~~~~~~~~~~~~~~~~~~~~~~ pyenv ~~~~~~~~~~~~~~~~~~~~~~~~~~
eval "$(pyenv init - zsh)"

# ~~~~~~~~~~~~~~~~~~~~~~ nvm ~~~~~~~~~~~~~~~~~~~~~~~~~~
# Incredibly slow - Only use if necessary
# export NVM_DIR="$HOME/.config/nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ~~~~~~~~~~~~~~~~~~~~~ Homebrew ~~~~~~~~~~~~~~~~~~~~~~~~~~
eval "$(/opt/homebrew/bin/brew shellenv)"


# ~~~~~~~~~~~~~~~~~~~~~ Highlighting ~~~~~~~~~~~~~~~~~~~~~~~~~~
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# ~~~~~~~~~~~~~~~~~~~~~~ History ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY


# ~~~~~~~~~~~~~~~~~~~~~~ Prompt - Pure ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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
alias work="cd '$WORK'"

# Python package managers and virtual environment creation
alias vnv='source venv/bin/activate'
alias vn3='source venv3/bin/activate'

# Directory Navigation
alias la='ls -a'
alias ll='ls -FGlAhp'
alias mem='top -o mem'
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stpat,vsize,rss,time,command | head -10'
alias ~="cd ~"                              # ~:            Go Home
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
# Bitwarden

# Unlock Vault and set session env variable
bwss() {
 eval $(bw unlock | grep export | awk -F"\$" {'print $2'})
}

alias bwll="bw list items | jq '.[] | .name' | grep"
alias bwg="bw get item"

# Set environment variables from item
bwe(){
    eval $(bw get item $1 | jq -r '.notes')
}

# Set variables based on current .env file
bwce(){
  bw get template item | jq --arg a "$(cat .env)" --arg b "$1" '.type = 2 | .secureNote.type = 0 | .notes = $a | .name = $b' | bw  encode | bw create item
}

# Brew

alias bu='brew update && brew upgrade && brew cleanup'

# Git

alias gcb='git branch --merged | egrep -v "(^\*|trunk)" | xargs git branch -d;'
alias gl="git log --graph --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%an%C(reset)%C(bold yellow)%d%C(reset) %C(dim white)- %s%C(reset)' --all
"
alias gr="git rebase -i"
alias gc="git checkout"
alias gs="git status"

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

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ FZF ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ Zoxide ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
eval "$(zoxide init zsh)"

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ Yazi ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~ TMS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
source <(COMPLETE=zsh tms)
