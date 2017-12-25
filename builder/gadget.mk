include common.mk

GADGET_UBOOT_BIN := $(GADGET_DIR)/boot-assets/u-boot.img
GADGET_UBOOT_SPL := $(GADGET_DIR)/boot-assets/MLO
GADGET_SNAP := $(OUTPUT_DIR)/beaglebone-blue_$(GADGET_VERSION)*.snap

all: build

clean:
	rm -rf $(GADGET_DIR)/boot-assets
	rm -f $(GADGET_DIR)/uboot.conf
	rm -f $(GADGET_SNAP)

distclean: clean

u-boot:
	@if [ ! -d $(GADGET_DIR)/boot-assets ] ; then mkdir $(GADGET_DIR)/boot-assets; fi
	@if [ ! -f $(UBOOT_BIN) ] ; then echo "Build u-boot first."; exit 1; fi
	cp -f $(UBOOT_BIN) $(GADGET_UBOOT_BIN)
	cp -f $(UBOOT_SPL) $(GADGET_UBOOT_SPL)
	cp -f $(GADGET_DIR)/uEnv.txt $(GADGET_DIR)/boot-assets/uEnv.txt

snappy: u-boot
	snapcraft snap gadget

build: u-boot snappy

.PHONY: u-boot snappy gadget build
