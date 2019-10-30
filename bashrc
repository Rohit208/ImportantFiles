# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
#HISTSIZE=1000
HISTSIZE=-1
#HISTFILESIZE=2000
HISTFILESIZE=-1
# Record timestamps
HISTTIMEFORMAT='%F %T '
# Don’t store specific lines
HISTIGNORE='t:bg:fg:history'
# Store history immediately
PROMPT_COMMAND='history -a'

alias dblogs='tail -f /var/log/postgresql/postgresql-11-main.log';
alias mdmlog='tail -f /home/rohit/log/mdm.log';

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# get current branch in git repo                                                                                                               
function parse_git_branch() {                                                                                                                  
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`                                                                   
    if [ ! "${BRANCH}" == "" ]                                                                                                                 
    then                                                                                                                                       
        STAT=`parse_git_dirty`                                                                                                                 
        #echo "[${BRANCH}${STAT}]"                                                                                                             
        echo "[${BRANCH}]"                                                                                                                     
    else                                                                                                                                       
        echo ""                                                                                                                                
    fi                                                                                                                                         
} 

# get current status of git repo                                                                                                               
function parse_git_dirty {                                                                                                                     
    status=`git status 2>&1 | tee`                                                                                                             
    dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`                                                        
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`                                              
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`                                          
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`                                                      
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`                                                       
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`                                                       
    bits=''                                                                                                                                    
    if [ "${renamed}" == "0" ]; then                                                                                                           
        bits=">${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ "${ahead}" == "0" ]; then                                                                                                             
        bits="*${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ "${newfile}" == "0" ]; then                                                                                                           
        bits="+${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ "${untracked}" == "0" ]; then                                                                                                         
        bits="?${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ "${deleted}" == "0" ]; then                                                                                                           
        bits="x${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ "${dirty}" == "0" ]; then                                                                                                             
        bits="!${bits}"                                                                                                                        
    fi                                                                                                                                         
    if [ ! "${bits}" == "" ]; then                                                                                                             
        echo " ${bits}"                                                                                                                        
    else                                                                                                                                       
        echo ""    
	fi                                                                                                                                         
}             
export PS1="\[\e[31m\]\[\e[m\]\[\e[32m\]@\[\e[m\]\[\e[33m\]\w\[\e[m\]\[\e[37m\]\`parse_git_branch\`\[\e[m\]\[\e[31m\] >\[\e[m\]\[\e[36m\]<\[\e[m\] "

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
#alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias sync='NOW=/home/abhinickz/test/rsync_$(date +"%F_%H_%M_%S").log; echo $NOW;sh /home/abhinickz/test/clear_logs.sh && rsync -razP --delete -e '"'"'ssh -p 22'"'"' --progress /home/abhinickz/test/. abhinickz@abhinickz_remote:/home/abhinickz/Backup_Local/test/. > $NOW';

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

alias dockerup="docker container run --rm -it --name posgresql11 posgresql11";
alias postgres='sudo -u postgres -i';
alias ipwifi="ip addr show wlp4s0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'";
alias ram='free -m';
alias ack='rg';
alias disco='perl ../Dispatcher/bin/pams-dispatcher';

# User specific aliases and functions

#source ~/.git-completion.bash

#
export AUTH_DB_OWNER=rohit
export PAMS_COMMON_ROOT=/home/rohit/Projects/PAMS-Common/
export PAMS_WWW_ROOT=/home/rohit/Projects/PAMS-WWW/
export PAMS_COMMON_CONFD=/home/rohit/Projects/PAMS-Common/conf/
export PAMS_MDM_CONFD=/home/rohit/Projects/PAMS-MDM/conf/
export PAMS_AUTHENTICATION_ROOT=/home/rohit/Projects/PAMS-Authentication/

#Config information
export PAMS_COMMON_MAIN_CONFIG=/home/rohit/Projects/PAMS-Common/conf/main.pl
export PAMS_COMMON_DB_CONFIG=/home/rohit/Projects/PAMS-Common/conf/db.pl
export PAMS_AUTHENTICATION_CONFIG=/home/rohit/Projects/PAMS-Authentication/conf/main.pl
export PAMS_RISK_DATABASE_DAMAGE=1

export PAMS_AUTHENTICATION_TEST=1
export PAMS_AUTHENTICATION_URL=http://localhost:7778
export PAMS_AUTHENTICATION_PG_SERVICE=pams-authentication

export PERL5LIB=/home/rohit/Projects/PAMS-Authentication/lib:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/PAMS-Authentication/t/lib:${PERL5LIB}

export PERL5LIB=/home/rohit/Projects/PAMS-MDM/t/unit:${PERL5LIB}

# MDM, Common
export PERL5LIB=/home/rohit/Projects/PAMS-Common/lib/:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/PAMS-MDM/lib/:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/PAMS-Alerts/lib/:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/PAMS-WWW/lib/:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/PAMS-WWW/t/tests/:${PERL5LIB}
export PERL5LIB=/home/rohit/Projects/Dispatcher/lib:${PERL5LIB}

export PGSERVICEFILE=/home/rohit/Projects/PAMS-Common/pg_service.conf
export PAMS_WWW_MODULES='/home/rohit/Projects/PAMS-WWW /home/rohit/Projects/PAMS-MDM /home/rohit/Projects/PAMS-Alerts /home/rohit/Projects/PAMS-Authentication'

PATH="/home/rohit/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/rohit/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/rohit/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/rohit/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/rohit/perl5"; export PERL_MM_OPT;

alias new='byobu new-window'
alias com='cd /home/rohit/Projects/PAMS-Common/'
alias mdm='cd /home/rohit/Projects/PAMS-MDM/'
alias www='cd /home/rohit/Projects/PAMS-WWW/'
alias alerts='cd /home/rohit/Projects/PAMS-Alerts/'
alias auth='cd /home/rohit/Projects/PAMS-Authentication/'
alias ll='ls -lrthF -N --color=tty -T 0'
alias perm='stat -c "%A %a %n"'
alias psqldev01='psql -h 10.10.10.88 -U rohit -d'
alias psqllog='tail -f /var/log/postgresql/postgresql-11-main.log'
alias vpn='cd /home/rohit/Documents/vpn/rohit/'
alias excelvpn='sudo openvpn rohit.ovpn'
alias rust='cd /home/rohit/Documents/Rust/'
alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get dist-upgrade'

export PATH=/home/rohit/Projects/PAMS-Common/bin:$PATH

alias www_server='perl /home/rohit/Projects/PAMS-WWW/script/pams_www_server.pl -d -p 7777'
alias auth_server='perl /home/rohit/Projects/PAMS-Authentication/script/pams_authentication_server.pl -d -p 7778'
alias killchrome='for i in `pgrep chrome` ; do kill $i ;  sleep .33 ; done'
# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
