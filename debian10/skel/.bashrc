# aliases
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ls='ls -ANF --color=auto --group-directories-first'
alias su='su -'
alias less='less -x4'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# umask
umask 022

# prompt
PS1="[\e[0;37m\u\e[m@\e[1;36m\w\e[m] \e[0;31m\D{%F %T}\e[m\n\$ "
trap 'echo -ne "\033[23;0t"' EXIT

# preserve history for concurrent sessions
HISTSIZE=10000
HISTFILESIZE=10000
HISTCONTROL=ignoredups:erasedups
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"
shopt -s histappend

# command completion
[[ -f /etc/bash_completion ]] && . /etc/bash_completion

# paths
export GOPATH="$HOME/go"
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
