# directory changing
cd() { command cd "$@" && echo -e "\033[2m${OLDPWD}\033[0m -> ${PWD}"; }
alias wk='cd ${HOME}/workspace/code'

# Listing shortcuts
alias ll='ls -lha'
alias la='ls -A'
alias l='ls -CF'

# Makes file commands verbose.
alias cp='cp -v'
alias mv='mv -v'

# Displays drives and space in human readable format.
alias df='df -h'

# Colorizes the `grep` output.
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# customize 'tree', if available
if command -v tree 2>&1 >/dev/null
then
    alias tree="tree"
fi
