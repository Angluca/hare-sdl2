// TODO: Flesh me out

export type color = struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
};

export type palette = struct {
	ncolors: int,
	colors: *color,
	version: u32,
	refcount: int,
};

// Note: Everything in the pixel format structure is read-only.
export type pixelformat = struct {
	format: u32, // TODO
	palette: *palette,
	bitsperpixel: u8,
	bytesperpixel: u8,
	padding: [2]u8,
	rmask: u32,
	gmask: u32,
	bmask: u32,
	amask: u32,
	rloss: u8,
	gloss: u8,
	bloss: u8,
	aloss: u8,
	rshift: u8,
	gshift: u8,
	bshift: u8,
	ashift: u8,
	refcount: int,
	next: nullable *pixelformat,
};
