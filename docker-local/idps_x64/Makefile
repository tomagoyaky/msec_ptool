KERNEL_SRC ?= $(ANDROID_BUILD_TOP)/device/chehejia/M01_AE/userdebug/sv/tmp/tmp.*/output

TARGET_MODULE := idps_x64.ko

KERNEL_ARCH := arm64
KERNEL_CROSS_COMPILE  := aarch64-linux-android-
KERNEL_CFLAGS := KCFLAGS=-mno-android

KBUILD_OPTIONS :=

all:
tab_hold_place$(MAKE) -C $(KERNEL_SRC) M=$(shell pwd) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_CFLAGS) modules $(KBUILD_OPTIONS)

modules_install:
tab_hold_place$(MAKE) INSTALL_MOD_STRIP=1 -C $(KERNEL_SRC) M=$(shell pwd) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_CFLAGS) modules_install

clean:
tab_hold_place$(MAKE) -C $(KERNEL_SRC) M=$(PWD) ARCH=$(KERNEL_ARCH) CROSS_COMPILE=$(KERNEL_CROSS_COMPILE) $(KERNEL_CFLAGS) clean
