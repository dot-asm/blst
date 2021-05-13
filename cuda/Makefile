ARCH ?= sm_75

NVFLAGS = -I.. -O2 -arch=$(ARCH) --relocatable-device-code=true

all:	ptx_test

ptx_test:	ptx_test.cu mul_fp.o Makefile
	nvcc -I../src $(NVFLAGS) -o $@ ptx_test.cu mul_fp.o

mul_fp.o:	mul_fp.ptx
	nvcc $(NVFLAGS) -c -o $@ $<

mul_fp.ptx:	mul_fp-ptx.pl
	perl $< > $@

clean:
	rm -f ptx_test mul_fp.o mul_fp.ptx
