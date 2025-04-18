# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# bash prompt w/ git settings (see .git-config.sh for details)
# tl;dr - set these to a non-empty value to enable them
GIT_PS1_SHOWCOLORHINTS="yes pls"
GIT_PS1_SHOWDIRTYSTATE="yes pls"
GIT_PS1_SHOWSTASHSTATE="yes pls"
# GIT_PS1_SHOWUNTRACKEDFILES='y'
# GIT_PS1_DESCRIBE_STYLE='describe'
GIT_PS1_SHOWUPSTREAM='auto'

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/home/hnut/.juliaup/bin:*)
        ;;

    *)
        export PATH=/home/hnut/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<
