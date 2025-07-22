## Set / export environment variables
## set -gx [key] [value]
set fish_greeting
# set -gx EDITOR nvim
set -gx EDITOR nano

## run if login
#if status --is-login
#end

## run if interactive
if status is-interactive
end

## run commands on shell exit
#function on_exit --on-event fish_exit
#    echo exiting fish
#end

## Fish plugin config (fzf)
set fzf_fd_opts --hidden --max-depth 5
set fzf_directory_opts --bind "ctrl-o:execute($EDITOR {} &> /dev/tty)"

## Source additional configuration files
source ~/config/fish/fish_aliases.fish

if test -e ~/.conda.fish
    source ~/.conda.fish
end

if test -e /opt/google-cloud-cli/path.fish.inc
    source /opt/google-cloud-cli/path.fish.inc
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f "$HOME/miniconda3/bin/conda"
    eval "$HOME/miniconda3/bin/conda" "shell.fish" "hook" $argv | source
else
    if test -f "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
        . "$HOME/miniconda3/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "$HOME/miniconda3/bin" $PATH
    end
end
# <<< conda initialize <<<

