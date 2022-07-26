.PHONY: clean all

all: instant-veins.pkr.hcl
	./build.sh $(USER)

clean:
	rm -fr output

