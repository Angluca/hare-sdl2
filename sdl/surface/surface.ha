use sdl;
use sdl = sdl::blendmode;
use sdl = sdl::pixels;
use sdl = sdl::rect;
use sdl::v2c::*;

// Flags for the surface. Used interally, read-only.
export type surface_flags = enum u32 {
	SWSURFACE = 0, // For compatibility.
	PREALLOC = 1, // Uses preallocated memory.
	RLEALLOC = 2, // Is RLE encoded.
	DONTFREE = 4, // Is referenced internally.
	SIMD_ALIGNED = 8, // Uses aligned memory.
};

// A collection of pixels used in software blitting.
//
// This structure should be treated as read-only, except for pixels, which, if
// not null, contains the raw pixel data for the surface.
export type surface = struct {
	flags: surface_flags, // Read-only.
	format: sdl::pixel_format, // Read-only.
	w: int, // Read-only.
	h: int, // Read-only.
	pitch: int, // Read-only.
	pixels: nullable *opaque, // Read-write.

	// Application data associated with the surface.
	userdata: nullable *opaque, // Read-write.

	// Information needed for surfaces requiring locks.
	locked: int, // Read-only.

	// List of BlitMaps that hold a reference to this surface.
	list_blitmap: *opaque, // Private.

	// Clipping information.
	clip_rect: sdl::rect, // Read-only.

	// Info for fast blit mapping to other surfaces.
	map: *opaque, // Private.

	// Reference count -- used when freeing surface.
	refcount: int, // Read-mostly.
};

// Allocate a new RGB surface.
//
// If depth is 4 or 8 bits, an empty palette is allocated for the surface.
// If depth is greater than 8 bits, the pixel format is set using the
// [RGBA]mask parameters.
//
// The [RGBA]mask parameters are the bitmasks used to extract that color from a
// pixel. For instance, Rmask being 0xFF000000 means the red data is stored in
// the most significant byte. Using zeros for the RGB masks sets a default
// value, based on the depth. For example:
//
//	create_rgb_surface(w, h, 32, 0, 0, 0, 0);
//
// However, using zero for the Amask results in an Amask of 0.
//
// By default surfaces with an alpha mask are set up for blending as with:
//
//	set_surface_blend_mode(surface, sdl::blend_mode::BLEND)
//
// You can change this by calling [[set_surface_blend_mode]] and selecting a
// different blendMode.
export fn create_rgb_surface(
	width: int,
	height: int,
	depth: int,
	Rmask: u32,
	Gmask: u32,
	Bmask: u32,
	Amask: u32,
) (*surface | sdl::error) = {
	return wrapptr(SDL_CreateRGBSurface(0, width, height, depth,
		Rmask, Gmask, Bmask, Amask))?: *surface;
};

// Allocate a new RGB surface with with a specific pixel format and existing
// pixel data.
//
// This function operates mostly like [[create_rgb_surface_from]], except
// instead of providing pixel color masks, you provide it with a predefined
// pixel format.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
export fn create_rgb_surface_with_format(
	width: int,
	height: int,
	depth: int,
	format: u32,
) (*surface | sdl::error) = {
	return wrapptr(SDL_CreateRGBSurfaceWithFormat(0, width, height, depth,
		format))?: *surface;
};

// Allocate a new RGB surface with existing pixel data.
//
// This function operates mostly like [[create_rgb_surface]], except it does
// not allocate memory for the pixel data, instead the caller provides an
// existing buffer of data for the surface to use.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
export fn create_rgb_surface_from(
	pixels: *opaque,
	width: int,
	height: int,
	depth: int,
	pitch: int,
	Rmask: u32,
	Gmask: u32,
	Bmask: u32,
	Amask: u32,
) (*surface | sdl::error) = {
	return wrapptr(SDL_CreateRGBSurfaceFrom(pixels, width, height, depth,
		pitch, Rmask, Gmask, Bmask, Amask))?: *surface;
};

// Allocate a new RGB surface with with a specific pixel format and existing
// pixel data.
//
// This function operates mostly like [[create_rgb_surface_from]], except
// instead of providing pixel color masks, you provide it with a predefined
// pixel format.
//
// No copy is made of the pixel data. Pixel data is not managed automatically;
// you must free the surface before you free the pixel data.
export fn create_rgb_surface_with_format_from(
	pixels: *opaque,
	width: int,
	height: int,
	depth: int,
	pitch: int,
	format: u32,
) (*surface | sdl::error) = {
	return wrapptr(SDL_CreateRGBSurfaceWithFormatFrom(pixels, width, height,
		depth, pitch, format))?: *surface;
};

// Free an RGB surface.
export fn free_surface(surface: nullable *surface) void =
	SDL_FreeSurface(surface: nullable *SDL_Surface);

// Set the palette used by a surface.
//
// A single palette can be shared with many surfaces.
export fn set_surface_palette(
	surface: *surface,
	palette: *sdl::palette,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetSurfacePalette(surface: *SDL_Surface,
		palette: *SDL_Palette));
};

// Set up a surface for directly accessing the pixels.
//
// Between calls to [[lock_surface]] / [[unlock_surface]], you can write to
// and read from surface.pixels, using the pixel format stored in
// surface.format. Once you are done accessing the surface, you should use
// [[unlock_surface]] to release it.
//
// TODO: SDL_MUSTLOCK macro.
export fn lock_surface(surface: *surface) (void | sdl::error) = {
	return wrapvoid(SDL_LockSurface(surface: *SDL_Surface));
};

// Release a surface after directly accessing the pixels.
export fn unlock_surface(surface: *surface) void = {
	return SDL_UnlockSurface(surface: *SDL_Surface);
};

// XXX: I have removed LoadBMP and SaveBMP. Should I add them back?

// Set the RLE acceleration hint for a surface.
//
// If RLE is enabled, color key and alpha blending blits are much faster, but
// the surface must be locked before directly accessing the pixels.
export fn set_surface_rle(surface: *surface, enable: bool) (void | sdl::error) = {
	return wrapvoid(SDL_SetSurfaceRLE(surface: *SDL_Surface,
		if (enable) 1 else 0));
};

// Returns whether the surface is RLE enabled.
export fn has_surface_rle(surface: nullable *surface) bool = {
	return SDL_HasSurfaceRLE(surface: nullable *SDL_Surface);
};

// Set the color key (transparent pixel) in a surface.
//
// The color key defines a pixel value that will be treated as transparent in
// a blit. For example, one can use this to specify that cyan pixels should be
// considered transparent, and therefore not rendered.
//
// It is a pixel of the format used by the surface, as generated by map_rgb.
//
// RLE acceleration can substantially speed up blitting of images with large
// horizontal runs of transparent pixels. See [[set_surface_rle]] for details.
export fn set_color_key(
	surface: *surface,
	enable: bool,
	key: u32,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetColorKey(surface: *SDL_Surface,
		if (enable) 1 else 0, key));
};

// Returns whether the surface has a color key
export fn has_color_key(surface: nullable *surface) bool = {
	return SDL_HasColorKey(surface: *SDL_Surface);
};

// Get the color key (transparent pixel) for a surface.
//
// The color key is a pixel of the format used by the surface, as generated by
// map_rgb.
export fn get_color_key(surface: *surface) (u32 | sdl::error) = {
	let k = 0u32;
	wrapvoid(SDL_GetColorKey(surface: *SDL_Surface, &k))?;
	return k;
};

// Set an additional color value multiplied into blit operations.
//
// When this surface is blitted, during the blit operation each source color
// channel is modulated by the appropriate color value according to the
// following formula: srcC = srcC * (color / 255)
export fn set_surface_color_mod(
	surface: *surface,
	r: u8,
	g: u8,
	b: u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetSurfaceColorMod(surface: *SDL_Surface, r, g, b));
};

// Get the additional color value multiplied into blit operations.
export fn get_surface_color_mod(
	surface: *surface,
	r: *u8,
	g: *u8,
	b: *u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_GetSurfaceColorMod(surface: *SDL_Surface, r, g, b));
};

// Set an additional alpha value used in blit operations.
//
// When this surface is blitted, during the blit operation the source alpha
// value is modulated by this alpha value according to the following formula:
// srcA = srcA * (alpha / 255)
export fn set_surface_alpha_mod(surface: *surface, alpha: u8) (void | sdl::error) =
	wrapvoid(SDL_SetSurfaceAlphaMod(surface: *SDL_Surface, alpha));

// Get the additional alpha value used in blit operations.
export fn get_surface_alpha_mod(surface: *surface, alpha: *u8) (void | sdl::error) =
	wrapvoid(SDL_GetSurfaceAlphaMod(surface: *SDL_Surface, alpha));

// Set the blend mode used for blit operations.
//
// To copy a surface to another surface (or texture) without blending with the
// existing data, the blendmode of the SOURCE surface should be set to
// blend_mode::NONE.
// TODO check blend_mode name in comments
export fn set_surface_blend_mode(
	surface: *surface,
	blendMode: sdl::blend_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetSurfaceBlendMode(surface: *SDL_Surface,
		blendMode: SDL_BlendMode));
};

// Get the blend mode used for blit operations.
export fn get_surface_blend_mode(surface: *surface) (sdl::blend_mode | sdl::error) = {
	let bm = sdl::blend_mode::NONE;
	wrapvoid(SDL_GetSurfaceBlendMode(surface: *SDL_Surface,
		&bm: *SDL_BlendMode))?;
	return bm;
};

// Set the clipping rectangle for a surface.
//
// When surface is the destination of a blit, only the area within the clip
// rectangle is drawn into.
//
// Note that blits are automatically clipped to the edges of the source and
// destination surfaces.
//
// rect can be null to disable clipping.
// Returns true if the rectangle intersects the surface, otherwise false and
// blits will be completely clipped.
export fn set_clip_rect(surface: *surface, rect: nullable *sdl::rect) bool = {
	return SDL_SetClipRect(surface: *SDL_Surface, rect: nullable *SDL_Rect);
};

// Get the clipping rectangle for a surface.
//
// When surface is the destination of a blit, only the area within the clip
// rectangle is drawn into.
export fn get_clip_rect(surface: *surface, rect: *sdl::rect) void =
	SDL_GetClipRect(surface: *SDL_Surface, rect: *SDL_Rect);

// Creates a new surface identical to the existing surface.
//
// The returned surface should be freed with [[free_surface]].
export fn duplicate_surface(sfc: *surface) (*surface | sdl::error) =
	wrapptr(SDL_DuplicateSurface(sfc: *SDL_Surface))?: *surface;

// Copy an existing surface to a new surface of the specified format enum.
//
// This function operates just like [[convert_surface]], but accepts a pixel
// format value instead of an [[sdl::pixel_format]] structure. As such, it might
// be easier to call but it doesn't have access to palette information for the
// destination surface, in case that would be important.
export fn convert_surface(
	src: *surface,
	fmt: *sdl::pixel_format,
) (*surface | sdl::error) = {
	return wrapptr(SDL_ConvertSurface(src: *SDL_Surface,
		fmt: *SDL_PixelFormat, 0))?: *surface;
};

// Copy an existing surface to a new surface of the specified format enum.
//
// This function operates just like [[convert_surface]], but accepts a pixel
// format value instead of an [[pixel_format]] structure. As such, it might be
// easier to call but it doesn't have access to palette information for the
// destination surface, in case that would be important.
export fn convert_surface_format(
	src: *surface,
	pixel_format: u32,
) (*surface | sdl::error) = {
	return wrapptr(SDL_ConvertSurfaceFormat(src: *SDL_Surface, pixel_format,
		0))?: *surface;
};

// Copy a block of pixels of one format to another format.
export fn convert_pixels(
	width: int,
	height: int,
	src_format: u32,
	src: *opaque,
	src_pitch: int,
	dst_format: u32,
	dst: *opaque,
	dst_pitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_ConvertPixels(width, height, src_format, src,
		src_pitch, dst_format, dst, dst_pitch));
};

// Premultiply the alpha on a block of pixels.
//
// This is safe to use with src == dst, but not for other overlapping areas.
//
// This function is currently only implemented for PIXELFORMAT_ARGB8888.
export fn premultiply_alpha(
	width: int,
	height: int,
	src_format: u32,
	src: *opaque,
	src_pitch: int,
	dst_format: u32,
	dst: *opaque,
	dst_pitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_PremultiplyAlpha(width, height, src_format, src,
		src_pitch, dst_format, dst, dst_pitch));
};

// Perform a fast fill of a set of rectangles with a specific color.
//
// color should be a pixel of the format used by the surface, and can be
// generated by map_rgb or map_rgba. If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// [[set_clip_rect]]), then this function will fill based on the intersection
// of the clip rectangle and rect.
export fn fill_rect(
	dst: *surface,
	rect: nullable *sdl::rect,
	color: u32,
) (void | sdl::error) = {
	return wrapvoid(SDL_FillRect(dst: *SDL_Surface,
		rect: nullable *SDL_Rect, color));
};

// Perform a fast fill of a set of rectangles with a specific color.
//
// color should be a pixel of the format used by the surface, and can be
// generated by map_rgb or map_rgba. If the color value contains an
// alpha component then the destination is simply filled with that alpha
// information, no blending takes place.
//
// If there is a clip rectangle set on the destination (set via
// [[set_clip_rect]]), then this function will fill based on the intersection
// of the clip rectangle and rect.
//
// TODO []rect
export fn fill_rects(
	dst: *surface,
	rects: *sdl::rect,
	count: int,
	color: u32,
) (void | sdl::error) = {
	return wrapvoid(SDL_FillRects(dst: *SDL_Surface, rects: *SDL_Rect,
		count, color));
};

// Performs a fast blit from the source surface to the destination surface.
//
// This assumes that the source and destination rectangles are
// the same size.  If either srcrect or  dstrect are null, the entire
// surface (src or dst) is copied.  The final blit rectangles are saved
// in srcrect and dstrect after all clipping is performed.
//
// See SDL docs for blit semantics regarding blending and colorkey.
export fn blit_surface(
	src: *surface,
	srcrect: nullable *sdl::rect,
	dst: *surface,
	dstrect: nullable *sdl::rect,
) int = {
	return SDL_BlitSurface(src: *SDL_Surface, srcrect: nullable *SDL_Rect,
		dst: *SDL_Surface, dstrect: nullable *SDL_Rect);
};

// Perform bilinear scaling between two surfaces of the same format, 32BPP.
export fn soft_stretch_linear(
	src: *surface,
	srcrect: nullable *sdl::rect,
	dst: *surface,
	dstrect: nullable *sdl::rect,
) int = {
	return SDL_SoftStretchLinear(src: *SDL_Surface,
		srcrect: nullable *SDL_Rect, dst: *SDL_Surface,
		dstrect: nullable *SDL_Rect);
};

// Perform a scaled surface copy to a destination surface.
export fn blit_scaled(
	src: *surface,
	srcrect: nullable *sdl::rect,
	dst: *surface,
	dstrect: nullable *sdl::rect,
) int = {
	return SDL_BlitScaled(src: *SDL_Surface, srcrect: nullable *SDL_Rect,
		dst: *SDL_Surface, dstrect: nullable *SDL_Rect);
};

// The formula used for converting between YUV and RGB.
export type yuv_conversion_mode = enum {
	JPEG, // Full range JPEG
	BT601, // BT.601 (the default)
	BT709, // BT.709
	AUTOMATIC, // BT.601 for SD content, BT.709 for HD content
};

// Set the YUV conversion mode
export fn set_yuvconversion_mode(mode: yuv_conversion_mode) void =
	SDL_SetYUVConversionMode(mode: SDL_YUV_CONVERSION_MODE);

// Get the YUV conversion mode, returning the correct mode for the resolution
// when the current conversion mode is yuv_conversion_mode::AUTOMATIC.
export fn get_yuvconversion_mode() yuv_conversion_mode =
	SDL_GetYUVConversionMode(): yuv_conversion_mode;

// Get the YUV conversion mode, returning the correct mode for the resolution
// when the current conversion mode is yuv_conversion_mode::AUTOMATIC.
export fn get_yuvconversion_mode_for_resolution(
	width: int,
	height: int,
) yuv_conversion_mode = {
	return SDL_GetYUVConversionModeForResolution(width,
		height): yuv_conversion_mode;
};
