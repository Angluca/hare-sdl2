use io;
use sdl;
use sdl = sdl::pixels;
use sdl = sdl::surface;
use sdl::v2c::*;
use sdl::ttf::v2c::*;
use types::c;

// The internal structure containing font information. Opaque data!
export type font = opaque;

// Query the version of SDL_ttf that the program is linked against.
//
// This returns static internal data; do not free or modify it!
export fn linked_version() *sdl::version = TTF_Linked_Version(): *sdl::version;

// Query the version of the FreeType library in use.
//
// [[init]] should be called before calling this function.
export fn get_free_type_version(
	major: nullable *int,
	minor: nullable *int,
	patch: nullable *int,
) void = TTF_GetFreeTypeVersion(major, minor, patch);

// Query the version of the HarfBuzz library in use.
//
// If HarfBuzz is not available, the version reported is 0.0.0.
export fn get_harf_buzz_version(
	major: nullable *int,
	minor: nullable *int,
	patch: nullable *int,
) void = TTF_GetHarfBuzzVersion(major, minor, patch);

// Initialize SDL_ttf.
//
// You must successfully call this function before it is safe to call any
// other function in this library, with one exception: a human-readable error
// message can be retrieved from [[get_error]] if this function fails.
//
// SDL must be initialized before calls to functions in this library, because
// this library uses utility functions from the SDL library.
//
// It is safe to call this more than once; the library keeps a counter of init
// calls, and decrements it on each call to [[quit]], so you must pair your
// init and quit calls.
export fn init() (void | error) = wrapvoid(TTF_Init());

// Create a font from a file, using a specified point size.
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font(file: str, ptsize: int) (*font | error) = {
	const file_c = c::fromstr(file);
	defer free(file_c);
	return wrapptr(TTF_OpenFont(file_c, ptsize))?: *font;
};

// Create a font from a file, using a specified face index.
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// Some fonts have multiple "faces" included. The index specifies which face
// to use from the font file. Font files with only one face should specify
// zero for the index.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_index(
	file: str,
	ptsize: int,
	index: i32,
) (*font | error) = {
	const file_c = c::fromstr(file);
	defer free(file_c);
	return wrapptr(TTF_OpenFontIndex(file_c, ptsize, index))?: *font;
};

// Create a font from a file, using target resolutions (in DPI).
//
// DPI scaling only applies to scalable fonts (e.g. TrueType).
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_dpi(
	file: str,
	ptsize: int,
	hdpi: int,
	vdpi: int,
) (*font | error) = {
	const file_c = c::fromstr(file);
	defer free(file_c);
	return wrapptr(TTF_OpenFontDPI(file_c, ptsize, hdpi, vdpi))?: *font;
};

// Create a font from a file, using target resolutions (in DPI).
//
// DPI scaling only applies to scalable fonts (e.g. TrueType).
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// Some fonts have multiple "faces" included. The index specifies which face
// to use from the font file. Font files with only one face should specify
// zero for the index.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_index_dpi(
	file: str,
	ptsize: int,
	index: i32,
	hdpi: int,
	vdpi: int,
) (*font | error) = {
	const file_c = c::fromstr(file);
	defer free(file_c);
	return wrapptr(TTF_OpenFontIndexDPI(file_c, ptsize, index, hdpi, vdpi))?: *font;
};

// Set a font's size dynamically.
//
// This clears already-generated glyphs, if any, from the cache.
export fn set_font_size(font: *font, ptsize: int) (void | error) =
	wrapvoid(TTF_SetFontSize(font: *TTF_Font, ptsize));

// Set font size dynamically with target resolutions (in DPI).
//
// This clears already-generated glyphs, if any, from the cache.
export fn set_font_size_dpi(
	font: *font,
	ptsize: int,
	hdpi: int,
	vdpi: int,
) (void | error) = {
	return wrapvoid(TTF_SetFontSizeDPI(font: *TTF_Font, ptsize,
		hdpi, vdpi));
};

// Font style flags.
export type style = enum {
	NORMAL        = 0x00,
	BOLD          = 0x01,
	ITALIC        = 0x02,
	UNDERLINE     = 0x04,
	STRIKETHROUGH = 0x08,
};

// Query a font's current style.
//
// The font styles are a set of bit flags, OR'd together.
export fn get_font_style(font: *font) style =
	TTF_GetFontStyle(font: *TTF_Font): style;

// Set a font's current style.
//
// Setting the style clears already-generated glyphs, if any, from the cache.
//
// The font styles are a set of bit flags, OR'd together.
export fn set_font_style(font: *font, style: style) void =
	TTF_SetFontStyle(font: *TTF_Font, style);

// Query a font's current outline.
export fn get_font_outline(font: *font) int =
	TTF_GetFontOutline(font: *TTF_Font);

// Set a font's current outline, 0 to default.
export fn set_font_outline(font: *font, outline: int) void =
	TTF_SetFontOutline(font: *TTF_Font, outline);

// Hinting flags.
export type hinting = enum {
	NORMAL = 0,
	LIGHT  = 1,
	MONO   = 2,
	NONE   = 3,
	LIGHT_SUBPIXEL = 4,
};

// Query a font's current FreeType hinter setting.
export fn get_font_hinting(font: *font) hinting =
	return TTF_GetFontHinting(font: *TTF_Font): hinting;

// Set a font's current hinter setting.
//
// Setting it clears already-generated glyphs, if any, from the cache.
export fn set_font_hinting(font: *font, hinting: int) void =
	TTF_SetFontHinting(font: *TTF_Font, hinting);

// Special layout option for rendering wrapped text.
export type wrapped_align = enum {
	LEFT   = 0,
	CENTER = 1,
	RIGHT  = 2,
};

// Query a font's current wrap alignment option.
export fn get_font_wrapped_align(font: *font) wrapped_align =
	TTF_GetFontWrappedAlign(font: *TTF_Font): wrapped_align;

// Set a font's current wrap alignment option.
export fn set_font_wrapped_align(font: *font, align_: wrapped_align) void =
	TTF_SetFontWrappedAlign(font: *TTF_Font, align_);

// Query the total height of a font.
//
// This is usually equal to point size.
export fn font_height(font: *font) int =
	TTF_FontHeight(font: *TTF_Font);

// Query the offset from the baseline to the top of a font.
//
// This is a positive value, relative to the baseline.
export fn font_ascent(font: *font) int =
	TTF_FontAscent(font: *TTF_Font);

// Query the offset from the baseline to the bottom of a font.
//
// This is a negative value, relative to the baseline.
export fn font_descent(font: *font) int =
	TTF_FontDescent(font: *TTF_Font);

// Query the recommended spacing between lines of text for a font.
export fn font_line_skip(font: *font) int =
	TTF_FontLineSkip(font: *TTF_Font);

// Query whether or not kerning is allowed for a font.
export fn get_font_kerning(font: *font) bool =
	TTF_GetFontKerning(font: *TTF_Font) != 0;

// Set if kerning is allowed for a font.
//
// Newly-opened fonts default to allowing kerning. This is generally a good
// policy unless you have a strong reason to disable it, as it tends to
// produce better rendering (with kerning disabled, some fonts might render
// the word `kerning` as something that looks like `keming` for example).
export fn set_font_kerning(font: *font, allowed: bool) void =
	TTF_SetFontKerning(font: *TTF_Font, if (allowed) 1 else 0);

// Query the number of faces of a font.
export fn font_faces(font: *font) i32 =
	TTF_FontFaces(font: *TTF_Font);

// Query whether a font is fixed-width.
//
// A "fixed-width" font means all glyphs are the same width across; a
// lowercase 'i' will be the same size across as a capital 'W', for example.
// This is common for terminals and text editors, and other apps that treat
// text as a grid. Most other things (WYSIWYG word processors, web pages, etc)
// are more likely to not be fixed-width in most cases.
export fn font_face_is_fixed_width(font: *font) bool =
	TTF_FontFaceIsFixedWidth(font: *TTF_Font) != 0;

// Query a font's family name.
//
// This string is dictated by the contents of the font file.
//
// Note that the returned string is to internal storage, and should not be
// modifed or free'd by the caller. The string becomes invalid, with the rest
// of the font, when `font` is handed to [[close_font]].
export fn font_face_family_name(font: *font) str =
	c::tostr(TTF_FontFaceFamilyName(font: *TTF_Font))!;

// Query a font's style name.
//
// This string is dictated by the contents of the font file.
//
// Note that the returned string is to internal storage, and should not be
// modifed or free'd by the caller. The string becomes invalid, with the rest
// of the font, when `font` is handed to [[close_font]].
export fn font_face_style_name(font: *font) str =
	c::tostr(TTF_FontFaceStyleName(font: *TTF_Font))!;

// Check whether a glyph is provided by the font for a 32-bit codepoint.
export fn glyph_is_provided(font: *font, r: rune) bool =
	TTF_GlyphIsProvided32(font: *TTF_Font, r: u32) != 0;

// Query the metrics (dimensions) of a font's 32-bit glyph.
//
// To understand what these metrics mean, here is a useful link:
//
// https://freetype.sourceforge.net/freetype2/docs/tutorial/step2.html
export fn glyph_metrics32(
	font: *font,
	r: rune,
	minx: *int,
	maxx: *int,
	miny: *int,
	maxy: *int,
	advance: *int,
) (void | error) = {
	return wrapvoid(TTF_GlyphMetrics32(font: *TTF_Font, r: u32, minx, maxx,
		miny, maxy, advance));
};

// Calculate the dimensions of a rendered string of UTF-8 text.
//
// This will report the width and height, in pixels, of the space that the
// specified string will take to fully render.
//
// This does not need to render the string to do this calculation.
export fn size_utf8(
	font: *font,
	text: str,
	w: nullable *int,
	h: nullable *int,
) (void | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapvoid(TTF_SizeUTF8(font: *TTF_Font, text_c, w, h));
};

// Calculate how much of a UTF-8 string will fit in a given width.
//
// This reports the number of characters (count) and width in pixels (extent)
// that can be rendered before reaching measure_width.
//
// This does not need to render the string to do this calculation.
export fn measure_utf8(
	font: *font,
	text: str,
	measure_width: int,
	extent: nullable *int,
	count: nullable *int,
) (void | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapvoid(TTF_MeasureUTF8(font: *TTF_Font, text_c, measure_width,
		extent, count));
};

// Render UTF-8 text at fast quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
// will be set to the text color.
//
// This will not word-wrap the string; you'll get a surface with a single line
// of text, as long as the string requires. You can use
// [[render_solid_wrapped]] instead if you need to wrap the output to
// multiple lines.
//
// This will not wrap on newline characters.
//
// You can render at other quality levels with [[render_shaded]],
// [[render_blended]], and [[render_lcd]].
export fn render_solid(
	font: *font,
	text: str,
	fg: sdl::color,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Solid(font: *TTF_Font, text_c,
		fg: SDL_Color))?: *sdl::surface;
};

// Render word-wrapped UTF-8 text at fast quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
// will be set to the text color.
//
// Text is wrapped to multiple lines on line endings and on word boundaries if
// it extends beyond `wrapLength` in pixels.
//
// If wrapLength is 0, this function will only wrap on newline characters.
//
// You can render at other quality levels with [[render_shaded_wrapped]],
// [[render_blended_wrapped]], and [[render_lcd_wrapped]].
export fn render_solid_wrapped(
	font: *font,
	text: str,
	fg: sdl::color,
	wrapLength: u32,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Solid_Wrapped(font: *TTF_Font,
		text_c, fg: SDL_Color, wrapLength))?: *sdl::surface;
};

// Render a single 32-bit glyph at fast quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the colorkey, giving a transparent background. The 1 pixel
// will be set to the text color.
//
// The glyph is rendered without any padding or centering in the X direction,
// and aligned normally in the Y direction.
//
// You can render at other quality levels with [[render_glyph_shaded]],
// [[render_glyph_blended]], and [[render_glyph_lcd]].
export fn render_glyph_solid(
	font: *font,
	r: rune,
	fg: sdl::color,
) (*sdl::surface | error) = {
	return wrapptr(TTF_RenderGlyph32_Solid(font: *TTF_Font, r: u32,
		fg: SDL_Color))?: *sdl::surface;
};

// Render UTF-8 text at high quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the specified background color, while other pixels have
// varying degrees of the foreground color.
//
// This will not word-wrap the string; you'll get a surface with a single line
// of text, as long as the string requires. You can use
// [[render_shaded_wrapped]] instead if you need to wrap the output to
// multiple lines.
//
// This will not wrap on newline characters.
//
// You can render at other quality levels with [[render_solid]],
// [[render_blended]], and [[render_lcd]].
export fn render_shaded(
	font: *font,
	text: str,
	fg: sdl::color,
	bg: sdl::color,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Shaded(font: *TTF_Font, text_c,
		fg: SDL_Color, bg: SDL_Color))?: *sdl::surface;
};

// Render word-wrapped UTF-8 text at high quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the specified background color, while other pixels have
// varying degrees of the foreground color.
//
// Text is wrapped to multiple lines on line endings and on word boundaries if
// it extends beyond `wrapLength` in pixels.
//
// If wrapLength is 0, this function will only wrap on newline characters.
//
// You can render at other quality levels with [[render_solid_wrapped]],
// [[render_blended_wrapped]], and [[render_lcd_wrapped]].
export fn render_shaded_wrapped(
	font: *font,
	text: str,
	fg: sdl::color,
	bg: sdl::color,
	wrapLength: u32,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Shaded_Wrapped(font: *TTF_Font, text_c,
		fg: SDL_Color, bg: SDL_Color, wrapLength))?: *sdl::surface;
};

// Render a single 32-bit glyph at high quality to a new 8-bit surface.
//
// This function will allocate a new 8-bit, palettized surface. The surface's
// 0 pixel will be the specified background color, while other pixels have
// varying degrees of the foreground color.
//
// The glyph is rendered without any padding or centering in the X direction,
// and aligned normally in the Y direction.
//
// This is the same as [[render_glyph_shaded]], but takes a 32-bit character
// instead of 16-bit, and thus can render a larger range. If you are sure
// you'll have an SDL_ttf that's version 2.0.18 or newer, there's no reason
// not to use this function exclusively.
//
// You can render at other quality levels with [[render_glyph_solid]],
// [[render_glyph_blended]], and [[render_glyph_lcd]].
export fn render_glyph_shaded(
	font: *font,
	r: rune,
	fg: sdl::color,
	bg: sdl::color,
) (*sdl::surface | error) = {
	return wrapptr(TTF_RenderGlyph32_Shaded(font: *TTF_Font, r: u32,
		fg: SDL_Color, bg: SDL_Color))?: *sdl::surface;
};

// Render UTF-8 text at high quality to a new ARGB surface.
//
// This function will allocate a new 32-bit, ARGB surface, using alpha
// blending to dither the font with the given color.
//
// This will not word-wrap the string; you'll get a surface with a single line
// of text, as long as the string requires. You can use
// [[render_blended_wrapped]] instead if you need to wrap the output to
// multiple lines.
//
// This will not wrap on newline characters.
//
// You can render at other quality levels with [[render_solid]],
// [[render_shaded]], and [[render_lcd]].
export fn render_blended(
	font: *font,
	text: str,
	fg: sdl::color,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Blended(font: *TTF_Font, text_c,
		fg: SDL_Color))?: *sdl::surface;
};

// Render word-wrapped UTF-8 text at high quality to a new ARGB surface.
//
// This function will allocate a new 32-bit, ARGB surface, using alpha
// blending to dither the font with the given color.
//
// Text is wrapped to multiple lines on line endings and on word boundaries if
// it extends beyond `wrapLength` in pixels.
//
// If wrapLength is 0, this function will only wrap on newline characters.
//
// You can render at other quality levels with [[render_solid_wrapped]],
// [[render_shaded_wrapped]], and [[render_lcd_wrapped]].
export fn render_blended_wrapped(
	font: *font,
	text: str,
	fg: sdl::color,
	wrapLength: u32,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_Blended_Wrapped(font: *TTF_Font, text_c,
		fg: SDL_Color, wrapLength))?: *sdl::surface;
};

// Render a single 32-bit glyph at high quality to a new ARGB surface.
//
// This function will allocate a new 32-bit, ARGB surface, using alpha
// blending to dither the font with the given color.
//
// The glyph is rendered without any padding or centering in the X direction,
// and aligned normally in the Y direction.
//
// You can render at other quality levels with [[render_glyph_solid]],
// [[render_glyph_shaded]], and [[render_glyph_lcd]].
export fn render_glyph_blended(
	font: *font,
	r: rune,
	fg: sdl::color,
) (*sdl::surface | error) = {
	return wrapptr(TTF_RenderGlyph32_Blended(font: *TTF_Font, r: u32,
		fg: SDL_Color))?: *sdl::surface;
};

// Render UTF-8 text at LCD subpixel quality to a new ARGB surface.
//
// This function will allocate a new 32-bit, ARGB surface, and render
// alpha-blended text using FreeType's LCD subpixel rendering.
//
// This will not word-wrap the string; you'll get a surface with a single line
// of text, as long as the string requires. You can use
// [[render_lcd_wrapped]] instead if you need to wrap the output to
// multiple lines.
//
// This will not wrap on newline characters.
//
// You can render at other quality levels with [[render_solid]],
// [[render_shaded]], and [[render_blended]].
export fn render_lcd(
	font: *font,
	text: str,
	fg: sdl::color,
	bg: sdl::color,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_LCD(font: *TTF_Font, text_c,
		fg: SDL_Color, bg: SDL_Color))?: *sdl::surface;
};

// Render word-wrapped UTF-8 text at LCD subpixel quality to a new ARGB
// surface.
//
// This function will allocate a new 32-bit, ARGB surface, and render
// alpha-blended text using FreeType's LCD subpixel rendering.
//
// Text is wrapped to multiple lines on line endings and on word boundaries if
// it extends beyond `wrapLength` in pixels.
//
// If wrapLength is 0, this function will only wrap on newline characters.
//
// You can render at other quality levels with [[render_solid_wrapped]],
// [[render_shaded_wrapped]], and [[render_blended_wrapped]].
export fn render_lcd_wrapped(
	font: *font,
	text: str,
	fg: sdl::color,
	bg: sdl::color,
	wrapLength: u32,
) (*sdl::surface | error) = {
	const text_c = c::fromstr(text);
	defer free(text_c);
	return wrapptr(TTF_RenderUTF8_LCD_Wrapped(font: *TTF_Font, text_c,
		fg: SDL_Color, bg: SDL_Color, wrapLength))?: *sdl::surface;
};

// Render a single 32-bit glyph at LCD subpixel quality to a new ARGB surface.
//
// This function will allocate a new 32-bit, ARGB surface, and render
// alpha-blended text using FreeType's LCD subpixel rendering.
//
// The glyph is rendered without any padding or centering in the X direction,
// and aligned normally in the Y direction.
//
// You can render at other quality levels with [[render_glyph_solid]],
// [[render_glyph_shaded]], and [[render_glyph_blended]].
export fn render_glyph_lcd(
	font: *font,
	r: rune,
	fg: sdl::color,
	bg: sdl::color,
) (*sdl::surface | error) = {
	return wrapptr(TTF_RenderGlyph32_LCD(font: *TTF_Font, r: u32,
		fg: SDL_Color, bg: SDL_Color))?: *sdl::surface;
};

// Dispose of a previously-created font.
//
// Call this when done with a font. This function will free any resources
// associated with it. It is safe to call this function on null, for example
// on the result of a failed call to [[open_font]].
//
// The font is not valid after being passed to this function. String pointers
// from functions that return information on this font, such as
// [[font_face_family_name]] and [[font_face_style_name]], are no longer valid
// after this call, as well.
export fn close_font(font: nullable *font) void =
	TTF_CloseFont(font: *TTF_Font);

// Deinitialize SDL_ttf.
//
// You must call this when done with the library, to free internal resources.
// It is safe to call this when the library isn't initialized, as it will just
// return immediately.
//
// Once you have as many quit calls as you have had successful calls to
// [[init]], the library will actually deinitialize.
//
// Please note that this does not automatically close any fonts that are still
// open at the time of deinitialization, and it is possibly not safe to close
// them afterwards, as parts of the library will no longer be initialized to
// deal with it. A well-written program should call [[close_font]] on any
// open fonts before calling this function!
export fn quit() void = TTF_Quit();

// Check if SDL_ttf is initialized.
//
// This reports the number of times the library has been initialized by a call
// to [[init]], without a paired deinitialization request from [[quit]].
//
// In short: if it's greater than zero, the library is currently initialized
// and ready to work. If zero, it is not initialized.
//
// Despite the return value being a signed integer, this function should not
// return a negative number.
export fn was_init() int = TTF_WasInit();

// Set script to be used for text shaping by a font.
//
// Any value supplied here will override the global script set with the
// deprecated [[set_script]].
//
// The supplied script value must be a null-terminated string of exactly four
// characters.
//
// If SDL_ttf was not built with HarfBuzz support, this function returns error.
export fn set_font_script_name(font: *font, script: str) (void | error) = {
	const script_c = c::fromstr(script);
	defer free(script_c);
	return wrapvoid(TTF_SetFontScriptName(font: *TTF_Font, script_c));
};

// Create a font from an SDL_RWops, using a specified point size.
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_h(src: io::handle, ptsize: int) (*font | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(TTF_OpenFontRW(&src_rw, 0, ptsize))?: *font;
};

// Create a font from an SDL_RWops, using a specified face index.
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// Some fonts have multiple "faces" included. The index specifies which face
// to use from the font file. Font files with only one face should specify
// zero for the index.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_index_h(
	src: io::handle,
	ptsize: int,
	index: i32,
) (*font | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(TTF_OpenFontIndexRW(&src_rw, 0, ptsize, index))?: *font;
};

// Opens a font from an SDL_RWops with target resolutions (in DPI).
//
// DPI scaling only applies to scalable fonts (e.g. TrueType).
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_dpi_h(
	src: io::handle,
	ptsize: int,
	hdpi: int,
	vdpi: int,
) (*font | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(TTF_OpenFontDPIRW(&src_rw, 0, ptsize, hdpi,
		vdpi))?: *font;
};

// Opens a font from an io::handle with target resolutions (in DPI).
//
// DPI scaling only applies to scalable fonts (e.g. TrueType).
//
// Some .fon fonts will have several sizes embedded in the file, so the point
// size becomes the index of choosing which size. If the value is too high,
// the last indexed size will be the default.
//
// Some fonts have multiple "faces" included. The index specifies which face
// to use from the font file. Font files with only one face should specify
// zero for the index.
//
// When done with the returned [[font]], use [[close_font]] to dispose of it.
export fn open_font_index_dpi_h(
	src: io::handle,
	ptsize: int,
	index: i32,
	hdpi: int,
	vdpi: int,
) (*font | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(TTF_OpenFontIndexDPIRW(&src_rw, 0, ptsize, index,
		hdpi, vdpi))?: *font;
};
