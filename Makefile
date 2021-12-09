.POSIX:
.SUFFIXES:

LIBS=-lc -lSDL2_image -lSDL2

demo:
	hare build $(LIBS) -T+libc cmd/demo

run:
	hare run $(LIBS) -T+libc cmd/demo

.PHONY: demo run
