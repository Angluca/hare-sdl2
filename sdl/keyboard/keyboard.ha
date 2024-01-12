use sdl = sdl::keycode;
use sdl = sdl::scancode;

export type keysym = struct {
	scancode: sdl::scancode,
	sym: sdl::keycode,
	mod: sdl::keymod,
};

// TODO functions
