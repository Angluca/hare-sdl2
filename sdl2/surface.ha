// A collection of pixels used in software blitting.
//
// This structure should be treated as read-only, except for 'pixels', which, if
// not null, contains the raw pixel data for the surface.
export type SDL_Surface = struct {
	flags: u32,
	format: *SDL_PixelFormat,
	w: int,
	h: int,
	pitch: int,
	pixels: nullable *opaque,

	userdata: *opaque,

	locked: int,
	lock_data: *opaque,

	clip_rect: SDL_Rect,

	map: *SDL_BlitMap,

	refcount: int,
};

export type SDL_BlitMap = opaque;

@symbol("SDL_CreateRGBSurface") fn _SDL_CreateRGBSurface(flags: u32,
	width: int, height: int, depth: int, Rmask: u32, Gmask: u32, Bmask: u32,
	Amask: u32) *SDL_Surface;

// Allocate a new RGB surface.
export fn SDL_CreateRGBSurface(flags: u32,
	width: int, height: int, depth: int, Rmask: u32, Gmask: u32, Bmask: u32,
	Amask: u32) (*SDL_Surface | error) = {
	return wrapptr(_SDL_CreateRGBSurface(flags, width, height, depth, Rmask,
	Gmask, Bmask, Amask))?: *SDL_Surface;
};
