use sdl;
use sdl::v2c::*;
use sdl::mixer::v2c::*;

// Query the version of SDL_mixer that the program is linked against.
//
// This returns static internal data; do not free or modify it!
export fn linked_version() *sdl::version = Mix_Linked_Version(): *sdl::version;
