# do not edit this file. put files in the dir below.
for FN in $HOME/Workbench/dotfiles/bashrc.d/*.sh ; do
    source "$FN"
done

export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
