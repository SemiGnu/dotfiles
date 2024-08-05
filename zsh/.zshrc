# export WSL='true' # Uncomment if running in WSL
export USE_NAME_HOST='true' # Show username and hostname in prompt, comment to hide
export K8S_MAIN_CONTEXT='docker-desktop' # Set main k8s context, will be green
export ZSH_CONFIG_PATH="$XDG_CONFIG_HOME/zsh"
export AZ_CONFIG_PATH="$HOME/.azure" # Path to az config

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE="$ZSH_CONFIG_PATH/.zsh_history"
setopt HIST_IGNORE_SPACE

# Use modern completion system
autoload -Uz compinit
compinit
zle_highlight+=(paste:none)

source "$ZSH_CONFIG_PATH/zsh-functions"

if [[ $WSL = 'true' ]] ; then
    zsh_add_file 'zsh-wsl'
fi    
if (command -v dotnet &> /dev/null) ; then
    export PATH="$HOME/.dotnet/tools:$PATH"
fi


zsh_add_file 'zsh-aliases'
zsh_add_file 'zsh-prompt'
zsh_add_file 'zsh-keybinds'


zsh_add_plugin 'zsh-users/zsh-autosuggestions'
zsh_add_plugin 'zsh-users/zsh-syntax-highlighting'

[ -f "/home/twinj/.ghcup/env" ] && . "/home/twinj/.ghcup/env" # ghcup-env