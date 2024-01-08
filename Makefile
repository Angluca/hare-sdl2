.POSIX:
.SUFFIXES:

LIBS=-lSDL2 -lSDL2_image -lSDL2_mixer -lSDL2_ttf

all: bins

bins:
	hare build $(LIBS) -o bin/version examples/version.ha
	hare build $(LIBS) -o bin/demo examples/demo.ha
	hare build $(LIBS) -o bin/sdl2c examples/sdl2c.ha
	hare build $(LIBS) -o bin/videoinfo examples/videoinfo.ha
	hare build $(LIBS) -o bin/gen_ha cmd/gen_ha.ha

info: bins
	./bin/version
	./bin/videoinfo

demo: bins 
	./bin/demo

clean:
	rm -f ./bin/*

.PHONY: all bins info
