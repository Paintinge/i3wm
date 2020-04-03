#useradd -m -s /bin/bash -G users,wheel,audio,portage,usb,video painting

#passwd painting

#emerge --ask --verbose sudo

#vim /etc/sudoers

#su - painting

#sudo emerge --ask --verbose xorg-server

#sudo env-update && source /etc/profile

#sudo su - root

#echo XSESSION="Xfce4" > /etc/env.d/90xsession

#exit

#sudo emerge --ask --verbose xfce4-meta

#sudo env-update && source /etc/profile

#sudo emerge --ask --verbose xfce4-terminal

#sudo emerge --ask --verbose networkmanager networkmanager-openconnect networkmanager-openvpn networkmanager-pptp networkmanager-vpnc

#sudo rc-update add NetworkManager default

#sudo emerge --ask --verbose vlc dev-ruby/git primus

#echo "options bbswitch load_state=0" >>/etc/modprobe.d/bbswitch.conf

#echo "
#blacklist nvidia
#blacklist nvidiafb
#blacklist nvidia_drm" >>/etc/modprobe.d/nvidia.conf

#sudo gpasswd -a painting bumblebee

#sudo rc-update add bumblebee default

#git clone https://github.com/ssrbackup/shadowsocksr

#vim /etc/ssr.json
{
    "server": "47.91.234.253",
    "local_address": "127.0.0.1",
    "local_port": 1080,
    "timeout": 300,
    "workers": 1,
    "server_port": 50000,
    "password": "8$EIZjt",
    "method": "chacha20-ietf",
    "obfs": "plain",
    "obfs_param": "",
    "protocol": "origin",
    "protocol_param": ""
}

#cp /Backup/Gentoo/.xinitrc /home/painting/

#sudo emerge --ask --verbose notification-daemon wps-office alsa-utils firefox wqy-microhei adobe-flash fcitx fcitx-configtool fcitx-cloudpinyin fcitx-rime remmina simplescreenrecorder

#sudo emerge --ask --verbose gvfs numlockx you-get aria2 virtualbox virtualbox-extpack-oracle proxychains tigervnc neofetch wqy-zenhei layman unzip unrar file-roller mpc mpd ncmpcpp evince app-editors/atom xfce4-taskmanager xfwm4-themes orage mousepad xfce4-power-manager thunar-archive-plugin thunar-volman thunderbird xfce4-battery-plugin xfce4-sensors-plugin pavucontrol xfce4-pulseaudio-plugin tumbler

#mkdir -pv /home/painting/.mpd

#mkdir -pv /home/painting/.mpd/playlists

#touch /home/painting/.mpd/log

#touch /home/painting/.mpd/mpd.pid

#touch /home/painting/.mpd/mpd.db

#touch /home/painting/.mpd/mpdstate

#sudo cp /Backup/Gentoo/.mpdconf /home/painting/

#sudo gpasswd -a painting vboxusers

#sudo gpasswd -a painting plugdev

#sudo layman -L && sudo layman -a gentoo-zh

#sudo layman -a stefantalpalaru

#sudo emerge --ask vmware-workstation

#sudo emerge --config vmware-workstation

#sudo cp -r /Backup/Gentoo/windows_fonts/ /usr/share/fonts/

#sudo mkfontscale && sudo mkfontdir

#sudo fc-cache -fv

#sudo emerge --ask xfce4-notifyd

#sudo emerge --ask --deselect=y xfce4-notifyd


#emerge --ask xfce-extra/xfce4-volumed-pulse

##emerge --ask xfce-base/xfce4-appfinder

##emerge --ask  media-sound/volumeicon

#!!sudo emerge --ask deepin-screenshot

#sudo rc-update add dbus default

#sudo rc-update add consolekit default

#sudo rc-update add fuse


#sudo emerge --ask --verbose --with-bdeps=y --deep --newuse --update @world

#sudo emerge --ask  --depclean

#sudo emerge --ask --verbose @preserved-rebuild

#sudo revdep-rebuild

#sudo emerge --ask --verbose @module-rebuild

#sudo etc-update || dispatch-conf

#sudo env-update && source /etc/profile


#sudo eclean -d distfiles

#sudo eclean-dist

#sudo eclean-pkg

#sudo chmod u+s /sbin/unix_chkpwd
