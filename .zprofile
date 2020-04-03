# startx when logged in
#if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
#    exec ssh-agent startx
#fi
[ -z "$DISPLAY" -a "$(fgconsole)" -eq 1 ] && exec startx
