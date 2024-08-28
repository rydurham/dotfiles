# set PATH to include a local "global" npm folder, if it exists
if [ -d "$HOME/.npm/bin" ] ; then
    PATH="$HOME/.npm/bin:$PATH"
fi
