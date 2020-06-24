ROOTFS_DIR=./rootfs
Content="aaa"
cat > $ROOTFS_DIR/root/install.sh <<EOF
#  echo "Install apache%vim"
apt-get update 
# apt-get upgrade -y
# apt install apache2 vim -y
#apt install lighttpd  -y
#systemctl enable lighttpd

apt install webfs  -y
systemctl enable webfs
mkdir -p /var/www/html
echo $Content >> /var/www/html/index.html
echo "Clean storge"
apt-get clean
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /var/log/*
rm -f  /var/cache/debconf/*old
rm -f /var/lib/apt/lists/*
EOF
chroot $ROOTFS_DIR sh /root/install.sh 
cat > $ROOTFS_DIR/etc/fstab <<EOF
/dev/mmcblk0p1	/boot	vfat	defaults	0	0
/dev/mmcblk0p2	/	ext4	defaults	0	0
/dev/mmcblk0p3	none	swap	sw		0	0
EOF
cat > $ROOTFS_DIR/etc/webfsd.conf <<EOF
# debian config file for webfsd.  It is read by the start/stop script.

# document root
web_root="/var/www/html"

# hostname (default to the fqdn)
web_host=""

# ip address to bind to (default: any)
web_ip=""

# port to listen on (default: 8000)
web_port="80"

# virtual host support (default: false)
web_virtual="false"

# network timeout (default: 60 seconds)
web_timeout=""

# number of parallel connections (default: 32)
web_conn=""

# index file for directories (default: none, webfsd will send listings)
web_index="index.html"

# size of the directory cache (default: 128)
web_dircache=""

# access log (common log format, default: none)
web_accesslog=""

# use bufferred logging (default: true)
web_logbuffering="true"

# write start/stop/errors to the syslog (default: false)
web_syslog="false"

# user/group to use
web_user="www-data"
web_group="www-data"

# cgi path (below document root -- default: none)
web_cgipath=""

# extra options, including arguments
web_extras=""
EOF

rsync -av $ROOTFS_DIR/ /mnt/sdcard2 --delete
