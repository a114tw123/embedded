KerneVer=linux-3.18.131
workDir=/usr/src
[ ! -f $workDir/$KerneVer.tar.xz ] && echo "NotFoundFile Downloading" &&  wget -P $workDir https://cdn.kernel.org/pub/linux/kernel/v3.x/$KerneVer.tar.xz 
tar xfva  $workDir/$KerneVer.tar.xz -C /usr/src/
#cp ./kernelCompileCfg $workDir/$KerneVer/.config

make -C $workDir/$KerneVer ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- vexpress_defconfig -j 8
make -C $workDir/$KerneVer ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig  -j 8
make -C $workDir/$KerneVer ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- uImage LOADADDR=0x60000000 -j 8
make -C $workDir/$KerneVer ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs modules -j 8
make -C $workDir/$KerneVer -s ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules -j 8
make -C $workDir/$KerneVer -s ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- modules_install INSTALL_MOD_PATH=./Cmodules/ -j 8
cp $workDir/$KerneVer/arch/arm/boot/zImage /mnt/sdcard1
cp $workDir/$KerneVer/arch/arm/boot/uImage /mnt/sdcard1
rsync -av $workDir/$KerneVer/Cmodules/lib/modules /mnt/sdcard2/lib
