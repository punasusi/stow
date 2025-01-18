
if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
eval "$(devbox global shellenv --init-hook)"
export XDG_CONFIG_HOME=~/.config
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"


eval "$(oh-my-posh init zsh)"
if [ "$TERM_PROGRAM" != "Apple_Terminal" ]; then
  eval "$(oh-my-posh init zsh --config /Users/andy/.config/ohmyposh/zen.toml)"
fi
# # Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

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

alias ls="eza --icons=always"
ccat () {
    /bin/cat "$1" | pbcopy
}

eval "$(fzf --zsh)"
# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# ---- Zoxide (better cd) ----
eval "$(zoxide init zsh)"

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias kg='kubecolor get '
alias kgp='kubecolor get po '
alias kgn='kubecolor get no '
alias kgd='kubecolor get deploy '
alias krmp='kubecolor delete po '
alias kdp='kubecolor describe po '
alias uek='unset KUBECONFIG'
alias kck='kubectl get po -A -o wide | grep -Ev "Running|Completed|trivy-system"'
alias uekns='unset KUBE_NAMESPACE'
alias kdrain="kubecolor drain --ignore-daemonsets --delete-emptydir-data"
alias cat="bat"
alias cd="z"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
# export kubeconfig
ek() {
    if [ -n "$1" ]; then
        CONFIG=$(rg --max-depth 3 -l '^kind: Config$' $HOME/.kube/ 2>/dev/null \
            | grep $1)
    else
        CONFIG=$(rg --max-depth 3 -l '^kind: Config$' $HOME/.kube/ $PWD 2>/dev/null | fzf --multi | tr '\n' ':')
    fi
    # Ensure the file has secure permissions (chmod 600)
    for file in $(echo ${CONFIG%:*} | tr ':' '\n'); do
        chmod 600 "$file"
    done
    # echo file and remove trailing :
    echo ${CONFIG%:*}
    export KUBECONFIG=${CONFIG%:*}
}


# main k function
fn k() {
  if [ -n "$KUBE_NAMESPACE" ]; then
      kubecolor --namespace "$KUBE_NAMESPACE" $@
  else
      kubecolor $@
  fi
}
 
# helper for setting a namespace
# List namespaces, preview the pods within, and save as variable
function ekns() {
  namespaces=$(kubectl get ns -o=custom-columns=:.metadata.name)
  export KUBE_NAMESPACE=$(echo $namespaces | fzf --select-1 --preview "kubectl --namespace {} get pods")
  echo "Set namespace to $KUBE_NAMESPACE"
}
export PATH="$PATH:$HOME/go/bin"
# Shell integrations
eval "$(zoxide init --cmd cd zsh)"
