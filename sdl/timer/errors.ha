use sdl;
use types::c;
use sdl::v2c::*;

fn get_error() sdl::error = c::tostr(SDL_GetError()): sdl::error;
