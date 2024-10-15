if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

[[ $- == *i* ]] || return

env TMOUT="" /bin/bash --rcfile ~/.bashrc1
#exec /bin/zsh
#export LD_LIBRARY_PATH=$HOME/.local/lib:$LD_LIBRARY_PATH
#exec ~/.local/bin/zsh
