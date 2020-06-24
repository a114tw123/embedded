ARCH=armhf
ROOTFS_DIR=./rootfs
DEBIAN_VERSION=buster
#DEBIAN_MIRROR=file:///home/ftp/debian
DEBIAN_MIRROR=http://120.117.72.30/debian

[ -d $ROOTFS_DIR.OLD ] && rm -rf $ROOTFS_DIR.OLD
[ -d $ROOTFS_DIR ] && mv $ROOTFS_DIR  $ROOTFS_DIR.OLD

debootstrap \
  --arch=$ARCH \
  --keyring=/usr/share/keyrings/debian-archive-keyring.gpg \
  --verbose \
  --foreign \
  $DEBIAN_VERSION \
  $ROOTFS_DIR \
  $DEBIAN_MIRROR

cp /usr/bin/qemu-arm-static $ROOTFS_DIR/usr/bin

chroot $ROOTFS_DIR /debootstrap/debootstrap --second-stage


echo "Create apt sources"

cat > $ROOTFS_DIR/etc/apt/sources.list << EOF
deb http://120.117.72.71/debian/ $DEBIAN_VERSION main contrib
deb http://opensource.nchc.org.tw/debian/ $DEBIAN_VERSION main contrib
# deb http://security.debian.org/ $DEBIAN_VERSION/updates main
EOF

echo "Edit hostname"
cat > $ROOTFS_DIR/etc/hostname<<EOF
arm
EOF

echo "Edit network"
cat > $ROOTFS_DIR/etc/network/interfaces<<EOF
# interfaces(5) file used by ifup(8) and ifdown(8)
# Include files from /etc/network/interfaces.d:
source-directory /etc/network/interfaces.d
auto lo
iface lo inet loopback

auto eth0 
iface eth0 inet static
address 192.168.10.20
netmask 255.255.255.0
gateway 120.117.72.44
EOF

cat >$ROOTFS_DIR/root/addUser.sh <<EOF
echo root:leenix | chpasswd
useradd -m -d /home/leenix -s /bin/bash leenix
echo leenix:leenix | chpasswd
EOF
chroot $ROOTFS_DIR sh /root/addUser.sh

rm $ROOTFS_DIR/root/addUser.sh


cat >$ROOTFS_DIR/root/update.sh<<EOF
apt-get update -y
EOF

chroot $ROOTFS_DIR sh /root/update.sh 

cat > $ROOTFS_DIR/root/clean.sh <<EOF
echo "Clean storge"
apt-get clean
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /var/log/*
rm -f  /var/cache/debconf/*old
rm -f /var/lib/apt/lists/*
EOF
chroot $ROOTFS_DIR sh /root/clean.sh



# cat > $ROOTFS_DIR/root/install.sh <<EOF
# #  echo "Install apache%vim"
# apt-get update 
# # apt-get upgrade -y
# # apt install apache2 vim -y
# apt install lighttpd -y

# echo "Clean storge"
# apt-get clean
# rm -rf /usr/share/doc/*
# rm -rf /usr/share/locale/*
# rm -rf /usr/share/man/*
# rm -rf /var/log/*
# rm -f  /var/cache/debconf/*old
# rm -f /var/lib/apt/lists/*
# EOF
# chroot $ROOTFS_DIR sh /root/install.sh 


rm $ROOTFS_DIR/root/install.sh 
rm $ROOTFS_DIR/root/update.sh

# rsync -av $ROOTFS_DIR/ /mnt/sdcard2
