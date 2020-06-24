
#dpkg --add-architecture armhf
#apt update
#apt install xorg icewm vim net-tools gcin libappindicator3-dev \
       	fonts-noto bridge-utils gcc cpp g++ gcc-arm-linux-gnueabihf \
       	cpp-arm-linux-gnueabihf g++-arm-linux-gnueabihf u-boot-tools \
        qemu qemu-kvm qemu-system:armhf qemu-user:armhf qemu-user-static \
      	debootstrap rsync git nautilus -y
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i ./google-chrome-stable_current_amd64.deb
apt install -f
