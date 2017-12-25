include common.mk

all: build

clean:
	if test -d "$(UBOOT_SRC)" ; then $(MAKE) ARCH=arm CROSS_COMPILE=${CC} -C $(UBOOT_SRC) clean ; fi
	rm -f $(UBOOT_BIN)
	rm -f $(UBOOT_SPL)
	rm -rf $(wildcard $(UBOOT_OUT))

distclean: clean
	rm -rf $(wildcard $(UBOOT_SRC))

$(UBOOT_BIN): $(UBOOT_SRC)
	mkdir -p $(UBOOT_OUT)
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=${CC} -C $(UBOOT_SRC) KBUILD_OUTPUT=$(UBOOT_OUT) $(UBOOT_DEFCONFIG)
	$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=${CC} -C $(UBOOT_SRC) KBUILD_OUTPUT=$(UBOOT_OUT) -j$(CPUS) all u-boot.img

$(UBOOT_SRC):
	git clone $(UBOOT_REPO) -b $(UBOOT_BRANCH) u-boot

u-boot: $(UBOOT_BIN)
	mkenvimage -r -s 131072  -o $(GADGET_DIR)/uboot.env $(GADGET_DIR)/uEnv.txt
	@if [ ! -f $(GADGET_DIR)/uboot.conf ]; then ln -s uboot.env $(GADGET_DIR)/uboot.conf; fi

build: u-boot

.PHONY: u-boot build
