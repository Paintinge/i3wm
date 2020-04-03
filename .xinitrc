#source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
#eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
#export SSH_AUTH_SOCK

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS="@im=fcitx"

setxkbmap -layout us -variant intl
xbindkeys
xset -b
numlockx &
#ck-launch-session dbus-launch --sh-syntax --exit-with-session xfce4-session
eval "$(dbus-launch --sh-syntax --exit-with-session)"
exec i3 &>~/.i3log
