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
	pixels: nullable *void,

	userdata: *void,

	locked: int,
	lock_data: *void,

	clip_rect: SDL_Rect,

	map: *SDL_BlitMap,

	refcount: int,
};

export type SDL_BlitMap = void;
