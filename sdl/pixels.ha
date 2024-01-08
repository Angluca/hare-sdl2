// The bits of this structure can be directly reinterpreted as an integer-packed
// color which uses the pixel_format::RGBA32 format.
export type color = struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
};

// Everything in the pixel format structure is read-only.
export type pixel_format = struct {
	format: u32,
	palette: *palette,
	bits_per_pixel: u8,
	bytes_per_pixel: u8,
	padding: [2]u8,
	Rmask: u32,
	Gmask: u32,
	Bmask: u32,
	Amask: u32,
	Rloss: u8,
	Gloss: u8,
	Bloss: u8,
	Aloss: u8,
	Rshift: u8,
	Gshift: u8,
	Bshift: u8,
	Ashift: u8,
	refcount: int,
	next: nullable *pixel_format,
};

export type palette = struct {
	ncolors: int,
	colors: *color,
	version: u32,
	refcount: int,
};
