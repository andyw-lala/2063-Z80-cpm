TOP=..
include $(TOP)/Make.default

FLASH_TYPE := SST39SF020

all: firmware.bin

clean:
	rm -f ldr
	rm -f *.lst *.bin *.hex *.sym

DATE := $(shell date +"%Y-%m-%d %H:%M:%S%z")
GIT_VERSION := $(shell git describe --long --dirty --always; git show -s --format='%ci')
%.bin: %.asm
	cat $< | sed -e "s/@@DATE@@/$(DATE)/g" -e "s/@@GIT_VERSION@@/$(GIT_VERSION)/g" -e "s/@@BOOT_MSG@@/$(BOOT_MSG)/g" | $(CROSS_AS) - -o $@ --list=$(basename $@).lst --label=$(basename $@).sym $(CROSS_AS_FLAGS)


world: clean all

flash:	firmware.bin
	minipro -p $(FLASH_TYPE) -w $< -S
