// TODO: Flesh me out

// A structure representing rendering state. (Opaque)
export type renderer = void;

// An efficient driver-specific representation of pixel data. (Opaque)
export type texture = void;

// Flags used when creating a rendering context.
export type renderer_flags = enum u32 {
	NONE = 0,
	SOFTWARE = 0x00000001,
	ACCELERATED = 0x00000002,
	PRESENTVSYNC = 0x00000004,
	TARGETTEXTURE = 0x00000008,
};

@symbol("SDL_CreateWindowAndRenderer") fn _create_window_and_renderer(
	width: int, height: int, window_flags: window_flags,
	window: nullable **window, renderer: nullable **renderer) int;

// Create a window and default renderer.
//
// 'width' and 'height' set the width and height of the window, in screen
// coordinates. 'window_flags' configure additional window parameters.
//
// 'window' and 'renderer' are out parameters, or null, which are filled in with
// the created window and renderer respectively.
export fn create_window_and_renderer(
	width: int,
	height: int,
	window_flags: window_flags,
	window: nullable **window,
	renderer: nullable **renderer,
) (void | error) = wrapvoid(_create_window_and_renderer(width, height,
	window_flags, window, renderer));

@symbol("SDL_CreateRenderer") fn _create_renderer(window: *window,
	index: int, flags: renderer_flags) nullable *renderer;

// Create a 2D rendering context for a window.
// 
// 'window' is the window where rendering is displayed. 'index' is the index of
// the rendering driver to initialize, or -1 to initialize the first one
// supporting the requested flags.
// 
// See also: [[create_software_renderer]], [[get_renderer_info]],
// [[destroy_renderer]].
export fn create_renderer(
	window: *window,
	index: int,
	flags: renderer_flags,
) (*renderer | error) =
	wrapptr(_create_renderer(window, index, flags))?: *renderer;

// Destroy the rendering context for a window and free associated textures.
//
// See also: [[create_renderer]].
export @symbol("SDL_DestroyRenderer") fn destroy_renderer(renderer: *renderer) void;

// Opaque value for the alpha channel (255).
export def ALPHA_OPAQUE: u8 = 255;

@symbol("SDL_SetRenderDrawColor") fn _set_render_draw_color(renderer: *renderer,
	r: u8, g: u8, b: u8, a: u8) int;

// Set the color used for drawing operations (Rect, Line and Clear).
// 
// 'renderer' is the renderer for which drawing color should be set. 'r', 'g',
// 'b', and 'a' respectively set the red, gree, blue, and alpha channels.
export fn set_render_draw_color(
	renderer: *renderer,
	r: u8, g: u8, b: u8, a: u8,
) (void | error) = wrapvoid(_set_render_draw_color(renderer, r, g, b, a));

@symbol("SDL_RenderClear") fn _render_clear(renderer: *renderer) int;

// Clear the current rendering target with the drawing color
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
export fn render_clear(renderer: *renderer) (void | error) = {
	return wrapvoid(_render_clear(renderer));
};

// Update the screen with rendering performed.
export @symbol("SDL_RenderPresent") fn render_present(renderer: *renderer) void;

// Destroy the specified texture.
export @symbol("SDL_DestroyTexture") fn destroy_texture(texture: *texture) void;

@symbol("SDL_QueryTexture") fn _query_texture(texture: *texture,
	format: nullable *u32, access: nullable *int,
	w: nullable *int, h: nullable *int) int;

// Query the attributes of a texture
export fn query_texture(
	texture: *texture,
	format: nullable *u32,
	access: nullable *int,
	w: nullable *int, h: nullable *int,
) (void | error) = {
	return wrapvoid(_query_texture(texture, format, access, w, h));
};

@symbol("SDL_SetTextureColorMod") fn _set_texture_color_mod(
	texture: *texture, r: u8, g: u8, b: u8) int;

// Set an additional color value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
// 	srcC = srcC * (color / 255)
//
// Color modulation is not always supported by the renderer; it will return -1
// if color modulation is not supported.
export fn set_texture_color_mod(
	texture: *texture,
	r: u8, g: u8, b: u8,
) (void | error) = {
	return wrapvoid(_set_texture_color_mod(texture, r, g, b));
};

@symbol("SDL_SetTextureAlphaMod") fn _set_texture_alpha_mod(texture: *texture, a: u8) int;

// Set an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// Alpha modulation is not always supported by the renderer; it will return an
// error if alpha modulation is not supported.
export fn set_texture_alpha_mod(texture: *texture, a: u8) (void | error) = {
	// TODO: Double check errors
	return wrapvoid(_set_texture_alpha_mod(texture, a));
};

@symbol("SDL_RenderCopy") fn _render_copy(renderer: *renderer,
	texture: *texture, srcrect: nullable *rect, dstrect: nullable *rect) int;

// Copy a portion of the texture to the current rendering target.
export fn render_copy(
	renderer: *renderer,
	texture: *texture,
	srcrect: nullable *rect,
	dstrect: nullable *rect,
) (void | error) = {
	return wrapvoid(_render_copy(renderer, texture, srcrect, dstrect));
};
