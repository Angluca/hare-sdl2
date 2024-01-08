export type SDL_BlitMap = opaque;

export type SDL_Surface = struct {
	flags: u32,
	format: *SDL_PixelFormat,
	w: int,
	h: int,
	pitch: int,
	pixels: nullable *opaque,
	userdata: nullable *opaque,
	locked: int,
	list_blitmap: *opaque,
	clip_rect: SDL_Rect,
	map: *SDL_BlitMap,
	refcount: int,
};

export type SDL_YUV_CONVERSION_MODE = enum {
	SDL_YUV_CONVERSION_JPEG,
	SDL_YUV_CONVERSION_BT601,
	SDL_YUV_CONVERSION_BT709,
	SDL_YUV_CONVERSION_AUTOMATIC,
};

export @symbol("SDL_CreateRGBSurface") fn SDL_CreateRGBSurface(flags: u32, width: int, height: int, depth: int, Rmask: u32, Gmask: u32, Bmask: u32, Amask: u32) nullable *SDL_Surface;
export @symbol("SDL_CreateRGBSurfaceWithFormat") fn SDL_CreateRGBSurfaceWithFormat(flags: u32, width: int, height: int, depth: int, format: u32) nullable *SDL_Surface;
export @symbol("SDL_CreateRGBSurfaceFrom") fn SDL_CreateRGBSurfaceFrom(pixels: *opaque, width: int, height: int, depth: int, pitch: int, Rmask: u32, Gmask: u32, Bmask: u32, Amask: u32) nullable *SDL_Surface;
export @symbol("SDL_CreateRGBSurfaceWithFormatFrom") fn SDL_CreateRGBSurfaceWithFormatFrom(pixels: *opaque, width: int, height: int, depth: int, pitch: int, format: u32) nullable *SDL_Surface;
export @symbol("SDL_FreeSurface") fn SDL_FreeSurface(surface: nullable *SDL_Surface) void;
export @symbol("SDL_SetSurfacePalette") fn SDL_SetSurfacePalette(surface: *SDL_Surface, palette: *SDL_Palette) int;
export @symbol("SDL_LockSurface") fn SDL_LockSurface(surface: *SDL_Surface) int;
export @symbol("SDL_UnlockSurface") fn SDL_UnlockSurface(surface: *SDL_Surface) void;
export @symbol("SDL_LoadBMP_RW") fn SDL_LoadBMP_RW(src: *SDL_RWops, freesrc: int) nullable *SDL_Surface;
export @symbol("SDL_SaveBMP_RW") fn SDL_SaveBMP_RW(surface: *SDL_Surface, dst: *SDL_RWops, freedst: int) int;
export @symbol("SDL_SetSurfaceRLE") fn SDL_SetSurfaceRLE(surface: *SDL_Surface, flag: int) int;
export @symbol("SDL_HasSurfaceRLE") fn SDL_HasSurfaceRLE(surface: nullable *SDL_Surface) bool;
export @symbol("SDL_SetColorKey") fn SDL_SetColorKey(surface: *SDL_Surface, flag: int, key: u32) int;
export @symbol("SDL_HasColorKey") fn SDL_HasColorKey(surface: nullable *SDL_Surface) bool;
export @symbol("SDL_GetColorKey") fn SDL_GetColorKey(surface: *SDL_Surface, key: *u32) int;
export @symbol("SDL_SetSurfaceColorMod") fn SDL_SetSurfaceColorMod(surface: *SDL_Surface, r: u8, g: u8, b: u8) int;
export @symbol("SDL_GetSurfaceColorMod") fn SDL_GetSurfaceColorMod(surface: *SDL_Surface, r: *u8, g: *u8, b: *u8) int;
export @symbol("SDL_SetSurfaceAlphaMod") fn SDL_SetSurfaceAlphaMod(surface: *SDL_Surface, alpha: u8) int;
export @symbol("SDL_GetSurfaceAlphaMod") fn SDL_GetSurfaceAlphaMod(surface: *SDL_Surface, alpha: *u8) int;
export @symbol("SDL_SetSurfaceBlendMode") fn SDL_SetSurfaceBlendMode(surface: *SDL_Surface, blendMode: SDL_BlendMode) int;
export @symbol("SDL_GetSurfaceBlendMode") fn SDL_GetSurfaceBlendMode(surface: *SDL_Surface, blendMode: *SDL_BlendMode) int;
export @symbol("SDL_SetClipRect") fn SDL_SetClipRect(surface: *SDL_Surface, rect: nullable *SDL_Rect) bool;
export @symbol("SDL_GetClipRect") fn SDL_GetClipRect(surface: *SDL_Surface, rect: *SDL_Rect) void;
export @symbol("SDL_DuplicateSurface") fn SDL_DuplicateSurface(surface: *SDL_Surface) nullable *SDL_Surface;
export @symbol("SDL_ConvertSurface") fn SDL_ConvertSurface(src: *SDL_Surface, fmt: *SDL_PixelFormat, flags: u32) nullable *SDL_Surface;
export @symbol("SDL_ConvertSurfaceFormat") fn SDL_ConvertSurfaceFormat(src: *SDL_Surface, pixel_format: u32, flags: u32) nullable *SDL_Surface;
export @symbol("SDL_ConvertPixels") fn SDL_ConvertPixels(width: int, height: int, src_format: u32, src: *opaque, src_pitch: int, dst_format: u32, dst: *opaque, dst_pitch: int) int;
export @symbol("SDL_PremultiplyAlpha") fn SDL_PremultiplyAlpha(width: int, height: int, src_format: u32, src: *opaque, src_pitch: int, dst_format: u32, dst: *opaque, dst_pitch: int) int;
export @symbol("SDL_FillRect") fn SDL_FillRect(dst: *SDL_Surface, rect: nullable *SDL_Rect, color: u32) int;
export @symbol("SDL_FillRects") fn SDL_FillRects(dst: *SDL_Surface, rects: *SDL_Rect, count: int, color: u32) int;
export @symbol("SDL_UpperBlit") fn SDL_BlitSurface(src: *SDL_Surface, srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) int;
export @symbol("SDL_SoftStretch") fn SDL_SoftStretch(src: *SDL_Surface, srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) int;
export @symbol("SDL_SoftStretchLinear") fn SDL_SoftStretchLinear(src: *SDL_Surface, srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) int;
export @symbol("SDL_UpperBlitScaled") fn SDL_BlitScaled(src: *SDL_Surface, srcrect: nullable *SDL_Rect, dst: *SDL_Surface, dstrect: nullable *SDL_Rect) int;
export @symbol("SDL_SetYUVConversionMode") fn SDL_SetYUVConversionMode(mode: SDL_YUV_CONVERSION_MODE) void;
export @symbol("SDL_GetYUVConversionMode") fn SDL_GetYUVConversionMode() SDL_YUV_CONVERSION_MODE;
export @symbol("SDL_GetYUVConversionModeForResolution") fn SDL_GetYUVConversionModeForResolution(width: int, height: int) SDL_YUV_CONVERSION_MODE;
