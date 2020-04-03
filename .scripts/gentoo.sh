# Git Clone
git clone -b Gentoo --depth=1 https://github.com/Paintinge/i3wm.git

# Gentoo format
mkfs.vfat -F 32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
swapon /dev/nvme0n1p2
mkfs.btrfs -f -n 4k -L BTREE -O no-holes /dev/nvme0n1p3

# Gentoo btrfs subvol
mount /dev/nvme0n1p3 /mnt/
btrfs subvol create /mnt/vol_root/
btrfs subvol create /mnt/vol_boot/
btrfs subvol create /mnt/vol_home/
btrfs subvol create /mnt/vol_distfiles/
btrfs subvol create /mnt/vol_snapshot/
btrfs subvol list /mnt/
umount /mnt/

# Gentoo mount btrfs directory
mkdir -v /mnt/gentoo/
mount -t btrfs -o defaults,noatime,autodefrag,compress=zstd,space_cache=v2,subvol=vol_root /dev/nvme0n1p3 /mnt/gentoo/
mkdir -pv /mnt/gentoo/{boot,home,.snapshot,var/cache/distfiles}
mount -t btrfs -o defaults,noatime,subvol=vol_boot /dev/nvme0n1p3 /mnt/gentoo/boot/
mount -t btrfs -o defaults,noatime,subvol=vol_home /dev/nvme0n1p3 /mnt/gentoo/home/
mount -t btrfs -o defaults,noatime,subvol=vol_distfiles /dev/nvme0n1p3 /mnt/gentoo/var/cache/distfiles/
mount -t btrfs -o defaults,noatime,subvol=vol_snapshot /dev/nvme0n1p3 /mnt/gentoo/.snapshot/
df -Th
mount

# Gentoo Stage3
cd /mnt/gentoo/
elinks https://mirrors.tuna.tsinghua.edu.cn/gentoo/releases/amd64/autobuilds/current-stage3-amd64/
sha512sum stage3-amd64-nomultilib-YYYYMMDDhhmmssZ.tar.xz
time tar xpf stage3-amd64-nomultilib-YYYYMMDDhhmmssZ.tar.xz --xattrs-include='*.*' --numeric-owner
ls -lA /mnt/gentoo/
rm stage3-amd64-nomultilib-YYYYMMDDhhmmssZ.tar.xz*
cp -rv ~/i3wm/ root/

# Gentoo mount
cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
mount --types proc /proc proc
mount --rbind /sys sys && mount --rbind /dev dev

# Gentoo Chroot
env -i HOME=/root TERM=$TERM $(which chroot) . bash -l
env-update && source /etc/profile
export PS1="(chroot) $PS1"

# Gentoo mount efi
mkdir /boot/efi/
mount -t vfat -o defaults,noatime /dev/nvme0n1p1 /boot/efi/
lsblk -f
mount
cd /root/i3wm/

# Gentoo Base Configure
cp etc/portage/make.conf /etc/portage/make.conf
mkdir -pv /etc/portage/repos.conf/
cp -v /usr/share/portage/config/repos.conf /etc/portage/repos.conf/gentoo.conf
echo "sync-uri = rsync://mirrors.tuna.tsinghua.edu.cn/gentoo-portage/" >>/etc/portage/repos.conf/gentoo.conf
emerge-webrsync
chown --recursive --verbose portage:portage /var/db/repos/gentoo/
emerge --sync
eselect profile list
emerge --ask --verbose vim bash-completion
eselect editor list
eselect editor set 3
eselect editor list
eselect vi list
emerge --ask --verbose --update --deep --newuse @world
echo 'Asia/Shanghai' > /etc/timezone
emerge --config sys-libs/timezone-data
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
echo "zh_CN.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
eselect locale list
eselect locale set en_US.utf8
env-update && source /etc/profile && export PS1="(chroot) ${PS1}"
hwclock --systohc --utc
cp etc/fstab /etc/fstab
vim /etc/fstab

# Gentoo Install Tools
emerge --ask --verbose linux-firmware gentoo-sources intel-microcode btrfs-progs grub mlocate gentoo-zsh-completions logrotate syslog-ng cronie dhcpcd wpa_supplicant iw zsh genkernel elogv gentoolkit eix
dispatch-conf

# Gentoo Kernel Configure
cp .scripts/.config /usr/src/linux/
cd /usr/src/linux/
make oldconfig
make menuconfig
make -j9 && make modules_install && make install
make modules_prepare
emerge --ask --verbose @module-rebuild
emerge --ask --verbose @preserved-rebuild
revdep-rebuild
emerge --ask --verbose --deep --update --newuse --with-bdeps=y @world
dispatch-conf
env-update && source /etc/profile
#genkernel --menuconfig all

# Gentoo Grub Configure
grub-install --target=x86_64-efi --efi-directory=/boot/efi/ --bootloader-id=Gentoo
unzip .themes/Aurora-Penguinis-GRUB2.zip -d /boot/grub/themes/
find /boot/grub/themes/Aurora-Penguinis-GRUB2/ -type f | xargs chmod 644
find /boot/grub/themes/Aurora-Penguinis-GRUB2/ -type d | xargs chmod 755
ls -R /boot/grub/themes/Aurora-Penguinis-GRUB2/
echo "GRUB_THEME="/boot/grub/themes/Aurora-Penguinis-GRUB2/theme.txt"" >> /etc/default/grub
echo "GRUB_BACKGROUND="/boot/grub/themes/Aurora-Penguinis-GRUB2/background.png"" >> /etc/default/grub
vim /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg

# Gentoo Service Update
emerge --ask --verbose dosfstools ntfs3g acpid
cp etc/syslog-ng/syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
vim /etc/conf.d/hostname
vim /etc/hosts
vim /etc/rc.conf
vim /etc/issue
rc-update add acpid default
rc-update add syslog-ng default
rc-update add cronie default
rc-update add fuse default
passwd
exit

# Gentoo reboot
umount -Rl /mnt/gentoo/
reboot
dmesg | grep "btrfs|micro|zswap"
grep -R . /sys/module/zswap/parameters/
reboot


# user add
useradd -m -s /bin/zsh -G users,wheel,audio,portage,usb,video painting
passwd painting 
emerge --ask --verbose sudo
vim /etc/sudoers
su - painting
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
exit

# file copy
cp -r .* /home/painting/
chown -R painting:painting /home/painting/
cp usr/local/bin/* /usr/local/bin/
chmod +x /usr/local/bin/*
cp etc/pam.d/i3lock /etc/pam.d/
mkdir /etc/portage/package.accept_keywords/
mkdir /etc/portage/package.use/
cp -r etc/portage/package.accept_keywords/* /etc/portage/package.accept_keywords/
cp -r etc/portage/package.use/* /etc/portage/package.use/
su - painting
cd .config/i3blocks/
git clone --depth=1 https://github.com/vivien/i3blocks-contrib.git
mv i3blocks-contrib/ blocks/

# xorg install
sudo tee -a /etc/eixrc/00-eixrc <<EOF
COLOR_INST_VERSION="white,1;blue|33,1;%{BG1}|black;green|30,1;%{BG3}"
BG0=none;
BG1=none;
BG2=none;
BG3=none;
COLORSCHEME0=0;
COLORSCHEME1=0;
COLORSCHEME2=0;
COLORSCHEME3=0;
EOF

sudo tee -a /etc/portage/package.use/sys-devel <<EOF
sys-devel/gcc graphite lto pgo
EOF

sudo emerge --ask --verbose xorg-server
sudo env-update && source /etc/profile
sudo emerge --ask --resume

# i3wm install
sudo emerge --ask --verbose i3blocks i3-gaps vlc dev-vcs/git primus neofetch rofi compton feh xbindkeys alacritty bat cmus ranger lsd tmux
sudo emerge --ask --resume
sudo dispatch-conf

# bumblebee configure
sudo tee -a /etc/modprobe.d/bbswitch.conf << EOF
options bbswitch load_state=0
EOF

sudo tee -a /etc/modprobe.d/nvidia.conf << EOF
blacklist nvidia
blacklist nvidiafb
blacklist nvidia_drm
EOF

sudo gpasswd -a painting bumblebee
sudo rc-update add bumblebee default
sudo vim /etc/init.d/bumblebee
sudo gpasswd -a painting plugdev
sudo rc-update add dbus default
sudo rc-update add consolekit default


# soft install
sudo chmod u+s /sbin/shutdown
sudo chmod u+s /sbin/reboot 
sudo emerge --ask --verbose setxkbmap arandr chromium gcc wps-office wqy-microhei fcitx fcitx-configtool fcitx-cloudpinyin numlockx you-get aria2 virtualbox virtualbox-extpack-oracle layman sublime-text dpkg exfat-utils fuse-exfat wireless-tools lxappearance gtk-theme-switch
sudo emerge --ask --resume
sudo emerge --ask --verbose --deep --newuse --update @world
sudo dispatch-conf
sudo revdep-rebuild

# btrfs snapshot
sudo mount /mnt
sudo btrfs subvolume snapshot /mnt/vol_boot/ /.snapshot/boot_i3_pure@2020.3.29
sudo btrfs subvolume snapshot /mnt/vol_home/ /.snapshot/home_i3_pure@2020.3.29
sudo btrf subvolume snapshot /mnt/vol_root/ /.snapshot/root_i3_pure@2020.3.29
sudo btrfs subvolume list /
sudo umount  /mnt

# configure
mkdir ~/.local/share/applications/
sudo mkdir -pv /opt/soft/
sudo chown -R painting:painting /opt/soft/
sudo emerge --ask --depclean 
sudo emerge --ask --verbose --newuse --update --deep @world
sudo emerge --ask @preserved-rebuild
sudo revdep-rebuild
sudo dispatch-conf


# MacOS Theme
cd .icons/
tar -Jxvf MacOSX-cursors.tar.xz
tar -Jxvf MacOSX-dark-icon-theme.tar.xz
tar -Jxvf MacOSX-icon-theme.tar.xz
cd ../.themes/
tar -Jxvf Sierra-dark.tar.xz
tar -Jxvf Sierra-light.tar.xz
