// TODO: Flesh me out

export type SDL_Color = struct {
	r: u8,
	g: u8,
	b: u8,
	a: u8,
};

export type SDL_Palette = struct {
	ncolors: int,
	colors: *SDL_Color,
	version: u32,
	refcount: int,
};

// Note: Everything in the pixel format structure is read-only.
export type SDL_PixelFormat = struct {
	format: u32, // TODO
	palette: *SDL_Palette,
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
	next: nullable *SDL_PixelFormat,
};

export def SDL_PIXELFORMAT_ARGB8888: u32 = 0x16362004;
