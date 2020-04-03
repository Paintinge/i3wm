sudo eselect kernel list

sudo eselect kernel set x

#genkernel --menuconfig all

cd /usr/src/linux/

make oldconfig

sudo make menuconfig

sudo make -j9 && sudo make modules_install && sudo make install 

sudo genkernel --install initramfs

sudo make modules_prepare

sudo emerge --ask --verbose @module-rebuild

sudo emerge --ask --depclean

sudo emerge --ask --verbose @preserved-rebuild

sudo revdep-rebuild

sudo emerge --ask --verbose --deep --update --newuse --with-bdeps=y @world

sudo etc-update || sudo dispatch-conf

sudo rm -r /usr/src/linux-xxx

sudo rm -r /lib/modules/xxx

sudo rm -r /boot/initramfs-xxx

sudo rm -r /boot/kernel-xxx

sudo rm -r /boot/System.map-xxx

sudo rm -r /boot/vmlinuz-xx

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo env-update && source /etc/profile
