use sdl;
use types::c;
use sdl::v2c::*;

fn get_error() sdl::error = c::tostr(SDL_GetError()): sdl::error;

fn wrapptr(ret: nullable *opaque) (*opaque | sdl::error) = match (ret) {
case let v: *opaque =>
	yield v;
case null =>
	yield get_error();
};
