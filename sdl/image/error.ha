use types::c;
use sdl;
use sdl::v2c::*;

// Returned when an error occurs in an IMG function.
export type error = !str;

// Converts an IMG error into a human-friendly string.
export fn strerror(err: error) str = {
	return err: str;
};

fn get_error() error = c::tostr(SDL_GetError()): error;

fn wrapvoid(ret: int) (void | error) = {
	wrapint(ret)?;
};

fn wrapint(ret: int) (int | error) = {
	if (ret < 0) {
		return get_error();
	};
	return ret;
};

fn wrapptr(ret: nullable *opaque) (*opaque | error) = {
	return match (ret) {
	case let v: *opaque =>
		yield v;
	case null =>
		yield get_error();
	};
};
