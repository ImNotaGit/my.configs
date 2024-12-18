# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME=""

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

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
#plugins=(vi-mode zsh-autopair zsh-autocomplete git-prompt)
plugins=(zsh-autopair zsh-autocomplete git-prompt)

# set $TERM
export TERM=xterm-256color

# this is to make zsh-autocomplete not show autocomplete menu unless the user triggers it with Tab, etc.; this needs to be before sourcing zsh-autocomplete (i.e. via oh-my-zsh.sh)
# zstyle ':autocomplete:async' enabled no

# load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# color prompt
PS1='${debian_chroot:+($debian_chroot)}%n@%m: %F{012}%~%f %{$reset_color%}$(git_super_status)'$'\n''%{$fg_bold[yellow]%}%B$%b%{$reset_color%} '
# by default git-prompt (i.e. $(git_super_status)) is placed to the right, instead I make it part of the main prompt and reset RPROMPT
RPROMPT=''


### Settings for plugins and tools

# vi-mode
# change cursor shape depending on vi mode
# VI_MODE_SET_CURSOR=true

# zsh-autocomplete and other completion settings
# make Tab go directly to completion menu and cycle there
bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete
# Enter to directly execute command
bindkey -M menuselect '\r' .accept-line
# Esc to abort
bindkey -M menuselect '^[' send-break
# Backspace to undo completion
bindkey -M menuselect '^?' undo
# use cdr for recent folders
autoload -Uz cdr
# reset default zsh behaviors of up and down for command history (i.e. do not use zsh-autocomplete for command history)
bindkey '^[OA' up-line-or-history
bindkey '^[OB' down-line-or-history
# fix breaking of up and down in zsh-autocomplete command history with vi-mode
# bindkey -M main '^[OA' up-line-or-search
# bindkey -M isearch '^[OA' up-history
# bindkey -M menuselect '^[OA' up-history
# bindkey -M main '^[OB' down-line-or-select
# bindkey -M isearch '^[OB' down-history
# bindkey -M menuselect '^[OB' down-history
# left and right just for moving cursor
bindkey -M menuselect '^[OD' .backward-char
bindkey -M menuselect '^[OC'  .forward-char
# hide files matching specific patterns unless you type something that matches only those file
zstyle ':completion:*:*:(less|le|vi|vim|nvim):*' ignored-patterns '*.'{RDS,RData,xls,xlsx,pdf,png,html} '*-pratend'
# disable autocompletion at command position (this includes commands, aliases, functions, etc.)
zstyle ':completion:*:-command-:*' ignored-patterns '*'
# hide warning messages
zstyle ':completion:*:warnings' format ''
# re-enable a/b/c -> abc/bcd/cde autocompletion
zstyle ':completion:*:paths' path-completion yes
# Ctrl-Backspace to undo completion (works even after a completion has been confirmed and completion menu is not being displayed); if I set this simply to Backspace, deleting character will stop working after a whole-line autocompletion is accepted
bindkey '^H' undo
# press only a single tab to do partial completion and show further completion suggestions
unsetopt listambiguous

# custom autocompletion
# autocomplete folder names under ${sm} for snake clone
export sm=$HOME/snakemake_pipelines
_snake()
{
    if [[ ${COMP_WORDS[1]} == clone ]]; then
        COMPREPLY=( $(compgen -W "$(cd ${sm} && ls -d */ | cut -f1 -d'/')" ${COMP_WORDS[1]}) )
    fi
}

complete -F _snake snake


### Aliases

alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lal='ls -lhA'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
#alias lessh='LESSOPEN="| /usr/share/source-highlight/src-hilite-lesspipe.sh %s" less'
alias le='LESSOPEN="| highlight --out-format=truecolor --style jellybeans %s" less'
alias tn='tmux new-session -s'
alias tls='tmux list-sessions'
alias ta='tmux attach-session -t'
alias ma='module add'
alias mr='module rm'
alias mls='module list'
alias mav='module avail'
alias r='module add R/4.4.1'
alias rr='module rm R'
alias ra=radian
alias ca='conda activate'
alias cda='conda deactivate'
alias nf='conda activate nextflow && module add singularity'
alias svr='Rscript -e "servr::httd(port=4321)"'
alias vi=nvim


### Environment variables

# paths
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH
#export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
#export PYTHONPATH=$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH
#export MANPATH=$HOME/.local/man:$MANPATH

# ssh
#export SSH_KEY_PATH="~/.ssh/dsa_id"

# may need to manually set language environment
#export LANG=en_US.UTF-8

export SGE_LONG_JOB_NAMES=-1
export NXF_HOME=$HOME/.nextflow
export NXF_SINGULARITY_CACHEDIR=$HOME/.nextflow/singularity
export NXF_CONDA_CACHEDIR=$HOME/.nextflow/conda
export BCFTOOLS_PLUGINS=$HOME/bcftools-1.14/libexec/bcftools


### Scripts

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# ...
# <<< conda initialize <<<

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# -e: exact match
export FZF_DEFAULT_OPTS='-e --height=50%'
# trigger with //<Tab>
export FZF_COMPLETION_TRIGGER='//'
# used for files after //<Tab>
_fzf_compgen_path() {
  find -L "$1" \
    -name .git -prune -o -name .hg -prune -o -name '.snakemake*' -prune -o -name tmp -prune -o \( -type d -o -type f -o -type l \) \
    -a -not -path "$1" -print 2> /dev/null
}
# used for dirs after cd //<Tab>
_fzf_compgen_dir() {
  find -L "$1" \
    -name .git -prune -o -name .hg -prune -o -name '.snakemake*' -prune -o -name tmp -prune -o -type d \
    -a -not -path "$1" -print 2> /dev/null
}

