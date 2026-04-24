# ── Exports ───────────────────────────────────────────────────────────────────
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_RUNTIME_DIR="${XDG_RUNTIME_DIR:-/run/user/$UID}"
export XDG_DOWNLOAD_DIR="${XDG_DOWNLOAD_DIR:-$HOME/Downloads}"

export PATH=$PATH:$HOME/.local/bin

export ALTERNATE_EDITOR=vim
export EDITOR=vim
export VISUAL=vim

# ── Keybindings ───────────────────────────────────────────────────────────────
bindkey -e                         # emacs key bindings (even when EDITOR=vim)

# Edit current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey '\C-x\C-e' edit-command-line

# ── Completion ────────────────────────────────────────────────────────────────
autoload -Uz compinit
compinit

# ── Zinit ─────────────────────────────────────────────────────────────────────
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

# Plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# OMZ snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
# zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# ── Prompt ────────────────────────────────────────────────────────────────────
eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/ohmyposh-catpucin-mocha.omp.json)"

# ── History ───────────────────────────────────────────────────────────────────
HISTSIZE=20000
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

# ── Aliases ───────────────────────────────────────────────────────────────────
alias ls='ls --color'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias d='pwd'
alias vim='nvim'
alias pvim='poetry run nvim .'

alias c='xclip -selection clipboard'
alias cc='xclip -selection clipboard'
alias v='xclip -selection clipboard -o'

# ── Functions ─────────────────────────────────────────────────────────────────
# View image inline (requires kitty)
iv() {
    kitty +kitten icat --scale-up --clear "$*"
}

# ── Shell integrations ────────────────────────────────────────────────────────
eval "$(fzf --zsh)"

# ── Keybinding overrides (after fzf to take precedence) ───────────────────────
# Ctrl+F: sessionizer if buffer empty, else accept autosuggestion
_ctrl_f() {
  if [[ -z $BUFFER ]]; then
    BUFFER="tmux-sessionizer"
    zle accept-line
  else
    zle autosuggest-accept
  fi
}
zle -N _ctrl_f
bindkey '^f' _ctrl_f

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --bind 'ctrl-y:accept'"

# z — frecency-based directory jumping
eval "$(zoxide init zsh)"

# z with no args opens interactive fzf picker; z <query> jumps directly
z() {
  if [[ $# -eq 0 ]]; then
    __zoxide_zi
  else
    __zoxide_z "$@"
  fi
}

# ── Python ────────────────────────────────────────────────────────────────────
export PYTHONDONTWRITEBYTECODE=1
export PYTHONIOENCODING=UTF-8

eval -- "$(pyenv init --path)"
# source -- "$(command -v virtualenvwrapper.sh)" 2>/dev/null

# ── Work ──────────────────────────────────────────────────────────────────────
# Sourced from a separate untracked file (credentials, work-specific env vars)
[[ -f ~/.zshrc.work ]] && source ~/.zshrc.work
