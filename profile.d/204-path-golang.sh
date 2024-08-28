# add golang bin to path if it exists
if [ -d "/usr/local/go/bin" ] ; then
    PATH="/usr/local/go/bin:$PATH"
fi

if [ -d "/home/ryan/go/bin" ] ; then
    PATH="/home/ryan/go/bin:$PATH"
fi
