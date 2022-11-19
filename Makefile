.PHONY: clean all

all: instant-veins.pkr.hcl
	./build.sh

clean:
	rm -fr output

