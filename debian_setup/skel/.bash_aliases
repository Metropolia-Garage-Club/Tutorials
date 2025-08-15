#! /bin/bash

alias ls='ls -F --color=auto'
alias la='ls -alhF --color=auto'
alias ll='ls -lhF --color=auto'
alias du100m='du -hd1 -t100M'
alias du1g='du -hd1 -t1G'
alias apt='nala'

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

## Podman
pod-networks() {
    podman ps --format "{{.names}}" | xargs -I {} sh -c 'echo -n "{}: "; podman inspect {} --format "{{range \ $net, \$conf := .NetworkSettings.Networks}}{{\$net}} {{end}}"'
}

pod-autostart-service() {
    read -p "Give the name of the container you wish to autostart: " CONTAINER
    podman generate systemd --name "${CONTAINER}" > "$HOME/.config/systemd/user/container_${CONTAINER}.service"
}
# Archives
alias tarnow='tar -acf'
alias untar='-zxvf'

# Configs
alias cfish='"$EDITOR" "$HOME"/.config/fish/config.fish'
alias cbash='"$EDITOR" "$HOME"/.bashrc'
alias cbash_a='"$EDITOR" "$HOME"/.bash_aliases'
alias cfast='"$EDITOR" "$HOME"/.config/fastfetch/config.jsonc'
alias cstar='"$EDITOR" "$HOME"/.config/starship.toml'
alias csnano='sudo "$EDITOR" /etc/nanorc'
alias cnano="$EDITOR" "$HOME/.config/nano/nanorc"
alias cyazi='"$EDITOR" "$HOME"/.config/yazi/yazi.toml'
alias cpacman='sudo "$EDITOR" /etc/pacman.conf'
alias sbash='source "$HOME"/.bashrc'
