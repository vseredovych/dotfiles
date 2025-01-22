# ======================
# Set up the prompt
# ======================

autoload -Uz promptinit
promptinit
prompt adam1

# TODO: remove ? Some bindings
# ================================
# =================
# Use emacs keybindings even if our EDITOR is set to vi
# bindkey -e
# bindkey '\e[1;3C' forward-word
# bindkey '\e[1;3D' backward-word
# bindkey '^[[1;5C' forward-word   # Ctrl + Right Arrow
# bindkey '^[[1;5D' backward-word  # Ctrl + Left Arrow
#
# ================================

# Use modern completion system
autoload -Uz compinit
compinit

# ================================
# Zinit installer
# ================================
### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Init miniconda
# source ~/miniconda3/bin/activate  # commented out by conda initialize
export PATH="$PATH:$HOME/.local/bin/"
eval "$(oh-my-posh init zsh --config /home/vs/.config/ohmyposh-catpucin-mocha.omp.json)"

# nvim
export PATH="$PATH:/opt/nvim-linux64/bin/"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::command-not-found

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# ================================
# Aliases
# ================================
alias ls='ls --color'
alias vim='nvim'
# alias c='clear'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias d='pwd'

alias c="xclip"
alias cc="xclip -selection clipboard"
alias v="xclip -o"

# ================================
# Fuzzy Finder 💜
# ================================
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Shell integrations
eval "$(fzf --zsh)"
source ~/zsh/.z.sh

unalias z 2> /dev/null
z() {
  local dir=$(
    _z 2>&1 |
    fzf --height 40% --layout reverse --info inline \
        --nth 2.. --tac --no-sort --query "$*" \
        --bind 'enter:become:echo {2..}'
  ) && cd "$dir"
}

# ================================
# Miscellaneous
# ================================

# Run command through editor
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

export ALTERNATE_EDITOR=vim
export EDITOR=vim
export VISUAL=vim


# ================================
# TODO: remove from here
# bash exports
source ~/.toshiba/bash/exports.bash


# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/vs/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/vs/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/vs/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/vs/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


# TODO: remove ?

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

