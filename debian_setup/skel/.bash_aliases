#! /bin/bash

alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias ll='ls -l --color=auto'
alias du100m='du -h -t100M'
alias du1g='du -h -t1G'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias diff='diff --color=auto'

# Power
alias shutdown='sudo shutdown now'
alias sdn='sudo shutdown now'
alias reboot='sudo reboot now'

# DEV
alias drebuild='docker-compose up -d --force-recreate'
alias docker-clean='docker container prune -f && docker image prune -f && docker network prune -f && docker volume prune -f '
alias jctl='journalctl -p 3 -xb'
alias nvi='nvim'
alias isaacsim='"$HOME"/isaacsim/isaac-sim.selector.sh'
alias isaaclab='"$HOME"/IsaacLab/isaaclab.sh'
alias ip='ip -c'



# Archives
alias tarnow='tar -acf'
alias untar='-zxvf'

# Configs
alias cfish='"$EDITOR" "$HOME"/.config/fish/config.fish'
alias cbash='"$EDITOR" "$HOME"/.bashrc'
alias cbash_a='"$EDITOR" "$HOME"/.bash_aliases'
alias cfast='"$EDITOR" "$HOME"/.config/fastfetch/config.jsonc'
alias cstar='"$EDITOR" "$HOME"/.config/starship.toml'
alias cnano='sudo "$EDITOR" /etc/nanorc'
alias cyazi='"$EDITOR" "$HOME"/.config/yazi/yazi.toml'
alias cpacman='sudo "$EDITOR" /etc/pacman.conf'
# alias capt='sudo "$EDITOR" /'

