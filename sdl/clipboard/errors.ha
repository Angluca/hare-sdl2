use sdl;
use types::c;
use sdl::v2c::*;

fn get_error() sdl::error = c::tostr(SDL_GetError()): sdl::error;

fn wrapvoid(ret: int) (void | sdl::error) = {
	wrapint(ret)?;
};

fn wrapint(ret: int) (int | sdl::error) = if (ret < 0) get_error() else ret;

fn wrapptr(ret: nullable *opaque) (*opaque | sdl::error) = match (ret) {
case let v: *opaque =>
	yield v;
case null =>
	yield get_error();
};
