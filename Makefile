.POSIX:
.SUFFIXES:

demo:
	hare build -lSDL2 -lc -T+libc cmd/demo

run:
	hare run -lSDL2 -lc -T+libc cmd/demo

.PHONY: demo run
