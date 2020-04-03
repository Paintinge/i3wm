mkdir -pv /mnt/gentoo
mount -t btrfs -o defaults,noatime,autodefrag,compress=zstd,space_cache=v2,subvol=vol_root /dev/nvme0n1p2 /mnt/gentoo/
mount -t btrfs -o defaults,noatime,subvol=vol_boot /dev/nvme0n1p2 /mnt/gentoo/boot/
mount -t btrfs -o defaults,noatime,subvol=vol_home /dev/nvme0n1p2 /mnt/gentoo/home/
mount -t btrfs -o defaults,noatime,subvol=vol_distfiles /dev/nvme0n1p2 /mnt/gentoo/var/cache/distfiles/
mount -t btrfs -o defaults,noatime,subvol=vol_snapshot /dev/nvme0n1p2 /mnt/gentoo/.snapshot/
#cp --dereference /etc/resolv.conf /mnt/gentoo/etc/
cd /mnt/gentoo/
mount --types proc /proc proc
mount --rbind /sys sys && mount --rbind /dev dev
env -i HOME=/root TERM=$TERM $(which chroot) . bash -l
