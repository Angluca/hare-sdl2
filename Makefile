.POSIX:
.SUFFIXES:

demo:
	hare build -lSDL2 -lc -T+libc cmd/demo

run: demo
	./demo

.PHONY: demo run
