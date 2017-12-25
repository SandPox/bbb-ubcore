include common.mk

SNAPPY_IMAGE := $(shell i="0"; while ls beaglebone-blue-`date +%Y%m%d`-$${i}.img* 1> /dev/null 2>&1; do i=$$((i+1)); done; echo "beaglebone-blue-`date +%Y%m%d`-$${i}.img")
# yes for latest version; no for the specific revision of edge/stable channel
UBUNTU_CORE_CH := beta
GADGET_MODEL := beaglebone-blue.model
GADGET_SNAP := beaglebone-blue_$(GADGET_VERSION)_armhf.snap
KERNEL_SNAP_VERSION := `grep version: $(KERNEL_BUILD)/prime/meta/snap.yaml | awk '{print $$2}'`
KERNEL_SNAP := beaglebone-blue-kernel_$(KERNEL_SNAP_VERSION)_armhf.snap
SNAPPY_WORKAROUND := no
UBUNTU_IMAGE=/snap/bin/ubuntu-image

all: build

clean:
	rm -f $(OUTPUT_DIR)/*.img.xz
distclean: clean

build-snappy:
	@echo "build snappy..."
	$(UBUNTU_IMAGE) \
		-c $(UBUNTU_CORE_CH) \
		--image-size 3.5G \
		--extra-snaps $(GADGET_SNAP) \
		--extra-snaps $(KERNEL_SNAP) \
		--extra-snaps snapweb \
		-o $(SNAPPY_IMAGE) \
		$(GADGET_MODEL)


pack:
	pxz -9 $(SNAPPY_IMAGE)

build: build-snappy pack

.PHONY: build-snappy pack build
