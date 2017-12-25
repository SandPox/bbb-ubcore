CPUS := $(shell getconf _NPROCESSORS_ONLN)

include .config

OUTPUT_DIR := $(PWD)
GADGET_DIR := $(OUTPUT_DIR)/gadget
GADGET_VERSION := `grep version $(GADGET_DIR)/meta/snap.yaml | awk '{print $$2}'`

# VENDOR: toolchain from BSP ; DEB: toolchain from deb
TOOLCHAIN := DEB

ARCH := arm
KERNEL_DTS := am335x-boneblue
UBOOT_DEFCONFIG := am335x_evm_defconfig

KERNEL_BUILD := $(PWD)/kernel

UBOOT_REPO := https://github.com/SandPox/u-boot.git
UBOOT_BRANCH := master
UBOOT_SRC := $(PWD)/u-boot
UBOOT_OUT := $(PWD)/u-boot-build
UBOOT_BIN := $(UBOOT_OUT)/u-boot.img
UBOOT_SPL := $(UBOOT_OUT)/MLO

ifeq ($(TOOLCHAIN),VENDOR)
CC :=
else
#CC := arm-linux-gnueabihf-
CC := /opt/toolchains/gcc-linaro-7.2.1-2017.11-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
endif
