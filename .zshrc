# Export ZSH-related variables
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="spaceship"

export DEFAULT_USER=$(whoami)
export COMPLETION_WAITING_DOGS="true"

export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# Configure ZSH
plugins=(
  dotenv
  git
  node
  npm
  zsh-autosuggestions
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

source ~/.zsh_aliases
source ~/.zsh_functions

# Amend PATH with additional directories
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:$HOME/.npm-packages/bin
export PATH=$PATH:$HOME/gradle/bin
export PATH=$PATH:$HOME/mongodb/bin
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    # intentionally empty
  fi
}

aws_whoami() {
  aws sts get-caller-identity|jq -r ".Account"
}

unset zle_bracketed_paste

export PATH="/usr/local/sbin:$PATH"

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

SPACESHIP_CHAR_SYMBOL="λ "

export HOMEBREW_NO_ENV_HINTS=1
