.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2_image -lSDL2_mixer -lSDL2

demo:
	hare build $(LIBS) cmd/demo

run:
	hare run $(LIBS) cmd/demo

docs:
	mkdir -p docs/sdl2/image
	haredoc -Fhtml sdl2 > docs/sdl2/index.html
	haredoc -Fhtml sdl2::image > docs/sdl2/image/index.html
	mkdir -p docs/sdl2/mixer
	haredoc -Fhtml sdl2::mixer > docs/sdl2/mixer/index.html

.PHONY: demo docs run
