# set PATH to include a local "global" npm folder, if it exists
if [ -d "$HOME/.npm/bin" ] ; then
    PATH="$HOME/.npm/bin:$PATH"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
if [ -d "$HOME/.local/share/pnpm" ] ; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    case ":$PATH:" in
      ":$PNPM_HOME/bin:"*) ;;
      *) export PATH="$PNPM_HOME/bin:$PATH" ;;
    esac
fi
# pnpm end
