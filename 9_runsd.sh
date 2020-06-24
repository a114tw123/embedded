qemu-system-arm -machine vexpress-a9 \
	-serial stdio \
	-no-reboot \
	-kernel u-boot \
	-drive file=sdcard.img,if=sd,format=raw,index=0 \
	-net nic,macaddr=52:54:00:12:34:56 -net bridge,br=br10

