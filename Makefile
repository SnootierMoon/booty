.PHONY: build clean run

build: out/boot.bin out/vgabios.bin out/bios.bin

run: build
	temu boot-loader.cfg

clean:
	rm -rf out

out/vgabios.bin out/bios.bin: out/%: | out
	curl -o $@ https://bellard.org/jslinux/$* -s

out/boot.bin: out/boot.o | out
	$(LD) -o $@ $< --oformat binary -Ttext 0x7C00

out/boot.o: src/boot.s | out
	$(AS) -o $@ $< 

out:
	mkdir $@
