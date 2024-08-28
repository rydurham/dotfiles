# add cargo bin to path if it exists
if [ -d "$HOME/.cargo/bin" ] ; then
   PATH="$HOME/.cargo/bin:$PATH"
fi
