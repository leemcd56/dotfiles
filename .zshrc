# Export ZSH-related variables
export ZSH=$HOME/.oh-my-zsh
export ZSH_THEME="spaceship"

export DEFAULT_USER=$(whoami)
export COMPLETION_WAITING_DOGS="true"

export ANSIBLE_HOSTS=~/ansible/hosts
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

PATH=$PATH:~/bin:~/go/bin

HB_CNF_HANDLER="$(brew --repository)/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
if [ -f "$HB_CNF_HANDLER" ]; then
source "$HB_CNF_HANDLER";
fi

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
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Amend PATH
export PATH="/usr/local/opt/ruby/bin:$PATH"
export PATH=$PATH:/opt/homebrew/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.yarn/bin
export PATH=$PATH:$HOME/.composer/vendor/bin
export PATH=$PATH:$HOME/.npm-packages/bin
export PATH=$PATH:$HOME/gradle/bin
export PATH=$PATH:$HOME/mongodb/bin
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH"

# Create aliases and functions
alias amend="git commit --amend"
alias clean="git reset --hard"
alias fetch="git fetch"
alias fix="git add . && git commit -m \"Fix merge issues on prior commit\""
alias graph="git log --graph -10 --branches --remotes --tags  --format=format:'%Cgreen%h %Creset• %<(75,trunc)%s (%cN, %cr) %Cred%d' --date-order"
alias logs="git log --oneline --graph --pretty --author=\"$(whoami)\" --after=\"1 week ago\""
alias nah="git reset --hard HEAD && git clean -df"
alias pipupdate="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
alias precommit="git diff --cached --diff-algorithm=minimal -w"
alias pull="git pull"
alias push="git push"
alias sites="cd ~/Sites"
alias status="git status"
alias unstage="git reset -q HEAD --"

alias fixaudio="sudo killall coreaudiod"

if [ -x /usr/bin/dircolors ]; then
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# grep but with color!
alias grep='grep --color=always'

alias ungrep='grep -v'
alias grep-min='grep --exclude=\*.min.\*'
alias grep-pyc='grep --exclude=\*.{min.\*,pyc} --exclude=\*/coverage/'
alias grep-less='grep-pyc --exclude=\*/{css,plugins,log,logs}/\*'
alias @='grep-less -nri'

alias chrome='open -a "Google Chrome"'
alias firefox='open -a "Firefox"'
alias safari='open -a "Safari"'

alias rosetta_brew='/usr/local/bin/brew'
alias murder='sudo killall -KILL SIGINT'
alias sail='bash vendor/bin/sail'

alias dirtree='tree -v --charset utf-8'

if [ -x /usr/bin/dircolors ]; then
  alias ls='ls --color=auto'
fi

alias .='ls -A'
alias la='ls -1A'
alias ll='ls -alF'
alias l='ls -CF'

function change-branch() { git checkout $@ ;}
function create-branch() { git checkout -b $@ ;}
function change-url() { git remote set-url origin $@ ;}
function clone-repo() { git clone https://github.com/$@ ;}
function commit-all() { git add -A && git commit -m "$@" && git push ;}
function brew-deps() { brew list | while read cask; do echo -n $fg[blue] $cask $fg[white]; brew deps $cask | awk '{printf(" %s ", $0)}'; echo ""; done }
function homestead() { ( cd ~/Homestead && vagrant $* ) ;}

function create-branch-base () {
  base_branch=$(git remote show origin | grep "HEAD branch" | cut -d ":" -f 2 | awk '{print $1}')

  if [ -n "$base_branch" ]; then
    git checkout -b $@ $base_branch
  else
    echo "Cannot create $base_branch outside of git repository"
  fi
}

function cleanup-deps () {
  /usr/bin/find "$(brew --prefix)/Caskroom/"*'/.metadata' -type f -name '*.rb' -print0 |
  /usr/bin/xargs -0 /usr/bin/perl -i -pe 's/depends_on macos: \[.*?\]//gsm;s/depends_on macos: .*//g'
}

prompt_context() {
  if [[ "$USER" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    # intentionally empty
  fi
}

aws_whoami() {
  aws sts get-caller-identity|jq -r ".Account"
}

unset zle_bracketed_paste

alias dir='tree -d -L 1'

export PATH="/usr/local/sbin:$PATH"
# [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

SPACESHIP_CHAR_SYMBOL="λ "

export HOMEBREW_NO_ENV_HINTS=1
