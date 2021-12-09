use sdl2;
use os;

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO);
	defer sdl2::quit();
	os::exit(0);
};
