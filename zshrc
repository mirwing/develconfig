# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export WORKSPACE="$HOME/Workspace"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

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
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions docker)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=ko_KR.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
# -------------------------------------------------------------------
# Aliases
# -------------------------------------------------------------------
alias sudo='sudo '
alias reload='source ~/.zshrc'

# --- eza (Modern ls replacement) ---
if (( $+commands[eza] )); then
  alias ls='eza'
  alias l='eza -lF'
  alias ll='eza -la --git'
  alias la='eza -a'
  alias lt='eza --tree --level=2'
  alias lta='eza --tree'
  alias lm='eza -l --sort=modified'
  alias lS='eza -l --sort=size'
else
  alias ls='ls -G'
  alias ll='ls -lh'
  alias la='ls -lah'
fi

# --- tmux (한글/UTF-8 와이드 문자 깨짐 방지 -u 옵션 추가) ---
alias tmux='tmux -u'
alias tml='tmux -u ls'
alias tmk='tmux kill-session -t'

# 세션이 있으면 attach, 없으면 새로 생성 후 진입
tma() {
  if [ -n "$1" ]; then
    tmux -u new-session -A -s "$1"
  else
    tmux -u attach 2>/dev/null || tmux -u new-session
  fi
}

# --- emacs / emacs 31 (-nw 모드 전용) ---
alias em='emacs -nw'
alias emacs='emacs -nw'
alias ec='emacsclient -t'
alias emacs-daemon='emacs --daemon'
alias emacs-kill='emacsclient -e "(kill-emacs)"'

# --- Navigation & Utilities ---
alias path='echo -e ${PATH//:/\\n}'
alias ports='lsof -iTCP -sTCP:LISTEN -P -n'
alias fix-nfd="python3 -c \"import os, unicodedata; [os.rename(os.path.join(r, n), os.path.join(r, unicodedata.normalize('NFC', n))) or print('변환:', unicodedata.normalize('NFC', n)) for r, ds, fs in os.walk('.', topdown=False) for n in fs + ds if n != unicodedata.normalize('NFC', n)]\""

# -------------------------------------------------------------------
# Environment & PATH Configuration
# -------------------------------------------------------------------
# Prevent duplicate PATH entries
typeset -U path PATH

export FLUTTERPATH="$HOME/Workspace/mirwing/flutter"
export ANDROID_HOME="$HOME/Library/Android/sdk"
export GOROOT="$HOME/Library/go"
export GOPATH="$WORKSPACE/go"
export GOROOT_BOOTSTRAP="$HOME/Library/go-bootstrap"

# Priority PATH: Local user bins -> MacPorts -> Toolchains -> System
path=(
  "$HOME/.local/bin"
  /opt/local/bin
  /opt/local/sbin
  "$GOROOT/bin"
  "$GOPATH/bin"
  "$FLUTTERPATH/bin"
  "$ANDROID_HOME/platform-tools"
  "$ANDROID_HOME/tools"
  $path
)
export PATH

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Google Cloud SDK (if installed)
if [ -f "$WORKSPACE/Library/google-cloud-sdk/path.zsh.inc" ]; then
  . "$WORKSPACE/Library/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$WORKSPACE/Library/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$WORKSPACE/Library/google-cloud-sdk/completion.zsh.inc"
fi


