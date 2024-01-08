use types::c;

export def SDL_ALPHA_OPAQUE = 255u8;
export def SDL_ALPHA_TRANSPARENT = 0u8;

export type SDL_PixelType = enum {
	SDL_PIXELTYPE_UNKNOWN,
	SDL_PIXELTYPE_INDEX1,
	SDL_PIXELTYPE_INDEX4,
	SDL_PIXELTYPE_INDEX8,
	SDL_PIXELTYPE_PACKED8,
	SDL_PIXELTYPE_PACKED16,
	SDL_PIXELTYPE_PACKED32,
	SDL_PIXELTYPE_ARRAYU8,
	SDL_PIXELTYPE_ARRAYU16,
	SDL_PIXELTYPE_ARRAYU32,
	SDL_PIXELTYPE_ARRAYF16,
	SDL_PIXELTYPE_ARRAYF32,
	SDL_PIXELTYPE_INDEX2,
};

export type SDL_BitmapOrder = enum {
	SDL_BITMAPORDER_NONE,
	SDL_BITMAPORDER_4321,
	SDL_BITMAPORDER_1234,
};

export type SDL_PackedOrder = enum {
	SDL_PACKEDORDER_NONE,
	SDL_PACKEDORDER_XRGB,
	SDL_PACKEDORDER_RGBX,
	SDL_PACKEDORDER_ARGB,
	SDL_PACKEDORDER_RGBA,
	SDL_PACKEDORDER_XBGR,
	SDL_PACKEDORDER_BGRX,
	SDL_PACKEDORDER_ABGR,
	SDL_PACKEDORDER_BGRA,
};

export type SDL_ArrayOrder = enum {
	SDL_ARRAYORDER_NONE,
	SDL_ARRAYORDER_RGB,
	SDL_ARRAYORDER_RGBA,
	SDL_ARRAYORDER_ARGB,
	SDL_ARRAYORDER_BGR,
	SDL_ARRAYORDER_BGRA,
	SDL_ARRAYORDER_ABGR,
};

export type SDL_PackedLayout = enum {
	SDL_PACKEDLAYOUT_NONE,
	SDL_PACKEDLAYOUT_332,
	SDL_PACKEDLAYOUT_4444,
	SDL_PACKEDLAYOUT_1555,
	SDL_PACKEDLAYOUT_5551,
	SDL_PACKEDLAYOUT_565,
	SDL_PACKEDLAYOUT_8888,
	SDL_PACKEDLAYOUT_2101010,
	SDL_PACKEDLAYOUT_1010102,
};

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

export type SDL_PixelFormat = struct {
	format: u32,
	palette: *SDL_Palette,
	BitsPerPixel: u8,
	BytesPerPixel: u8,
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
	next: nullable *SDL_PixelFormat,
};

// TODO long pixelformat enum with values that depend on endianness.

export def SDL_PIXELFORMAT_ARGB8888: u32 = 0x16362004;

export @symbol("SDL_GetPixelFormatName") fn SDL_GetPixelFormatName(format: u32) *c::char;
export @symbol("SDL_PixelFormatEnumToMasks") fn SDL_PixelFormatEnumToMasks(format: u32, bpp: *int, Rmask: *u32, Gmask: *u32, Bmask: *u32, Amask: *u32) bool;
export @symbol("SDL_MasksToPixelFormatEnum") fn SDL_MasksToPixelFormatEnum(bpp: int, Rmask: u32, Gmask: u32, Bmask: u32, Amask: u32) u32;
export @symbol("SDL_AllocFormat") fn SDL_AllocFormat(pixel_format: u32) nullable *SDL_PixelFormat;
export @symbol("SDL_FreeFormat") fn SDL_FreeFormat(format: *SDL_PixelFormat) void;
export @symbol("SDL_AllocPalette") fn SDL_AllocPalette(ncolors: int) nullable *SDL_Palette;
export @symbol("SDL_SetPixelFormatPalette") fn SDL_SetPixelFormatPalette(format: *SDL_PixelFormat, palette: *SDL_Palette) int;
export @symbol("SDL_SetPaletteColors") fn SDL_SetPaletteColors(palette: *SDL_Palette, colors: *SDL_Color, firstcolor: int, ncolors: int) int;
export @symbol("SDL_FreePalette") fn SDL_FreePalette(palette: *SDL_Palette) void;
export @symbol("SDL_MapRGB") fn SDL_MapRGB(format: *SDL_PixelFormat, r: u8, g: u8, b: u8) u32;
export @symbol("SDL_MapRGBA") fn SDL_MapRGBA(format: *SDL_PixelFormat, r: u8, g: u8, b: u8, a: u8) u32;
export @symbol("SDL_GetRGB") fn SDL_GetRGB(pixel: u32, format: *SDL_PixelFormat, r: *u8, g: *u8, b: *u8) void;
export @symbol("SDL_GetRGBA") fn SDL_GetRGBA(pixel: u32, format: *SDL_PixelFormat, r: *u8, g: *u8, b: *u8, a: *u8) void;
export @symbol("SDL_CalculateGammaRamp") fn SDL_CalculateGammaRamp(gamma: f32, ramp: *u16) void;
