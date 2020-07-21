
# 这里也必须导入
include /opt/theos/makefiles/common.mk
include /opt/theos/makefiles/tweak.mk

THEOS_DEVICE_IP = 172.16.115.147
ARCHS = arm64
TARGET = iphone:latest:9.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = motherwc
motherwc_FILES = Tweak.xm

# 这里必须是 motherwc 开头.. 上面的名字就是motherwc
motherwc_FRAMEWORKS = UIKit CoreTelephony CoreAudio AVFoundation MediaPlayer
motherwc_PRIVATE_FRAMEWORKS = BaseBoard
motherwc_LDFLAGS = -lz -BaseBoard
motherwc_CFLAGS = -std=c++11 -stdlib=libc++
motherwc_LDFLAGS = -stdlib=libc++

include $(THEOS_MAKE_PATH)/tweak.mk


after-install::
	install.exec "killall -9 WeChat"




# make packge 报错，需要安装 ： sudo cpan -I IO::Compress::Lzma

	# 编译 make
	# 打包 make package （相当于make dpkg-deb）
	# 	com.test.characountfornotes8_1.0-1+debug_iphoneos-arm.deb 就是要安装的文件
	# 安装 
	# 	1、使用iFunBox把deb拖到iOS中，然后用 iFile安装，最后重启
	# 	2、make package install （因为在Makefile中已经指定了 设备的 ip）