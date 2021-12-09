// A collection of pixels used in software blitting.
// 
// This structure should be treated as read-only, except for 'pixels', which, if
// not null, contains the raw pixel data for the surface.
export type surface = struct {
	flags: u32,
	format: *pixelformat,
	w: int,
	h: int,
	pitch: int,
	pixels: nullable *void,

	userdata: *void,

	locked: int,
	lock_data: *void,

	clip_rect: rect,

	map: *blitmap,

	refcount: int,
};

export type blitmap = void;
