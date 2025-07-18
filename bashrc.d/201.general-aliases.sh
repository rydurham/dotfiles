alias vim=nvim
alias gedit=gnome-text-editor
alias ld=lazydocker
alias lg=lazygit

toggleTheme() {
    if test "$(gsettings get org.gnome.desktop.interface color-scheme)" = "'prefer-light'"; then
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    else
        gsettings set org.gnome.desktop.interface color-scheme prefer-light
    fi
}

alias theme=toggleTheme

# https://unix.stackexchange.com/questions/22615/how-can-i-get-my-external-ip-address-in-a-shell-script/81699#81699
alias ip='dig @resolver4.opendns.com myip.opendns.com +short'
