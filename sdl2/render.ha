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

// Create a window and default renderer.
//
// 'width' and 'height' set the width and height of the window, in screen
// coordinates. 'window_flags' configure additional window parameters.
//
// 'window' and 'renderer' are out parameters, or null, which are filled in with
// the created window and renderer respectively.
//
// Returns 0 on success, or -1 on error.
export @symbol("SDL_CreateWindowAndRenderer") fn create_window_and_renderer(
	width: int, height: int, window_flags: window_flags,
	window: nullable **window, renderer: nullable **renderer) int;

// Create a 2D rendering context for a window.
// 
// 'window' is the window where rendering is displayed. 'index' is the index of
// the rendering driver to initialize, or -1 to initialize the first one
// supporting the requested flags.
// 
// Returns a valid rendering context, or NULL if there was an error.
// 
// See also: [[create_software_renderer]], [[get_renderer_info]],
// [[destroy_renderer]].
export @symbol("SDL_CreateRenderer") fn create_renderer(window: *window,
	index: int, flags: renderer_flags) nullable *renderer;

// Destroy the rendering context for a window and free associated textures.
//
// See also: [[create_renderer]].
export @symbol("SDL_DestroyRenderer") fn destroy_renderer(renderer: *renderer) void;

// Opaque value for the alpha channel (255).
export def ALPHA_OPAQUE: u8 = 255;

// Set the color used for drawing operations (Rect, Line and Clear).
// 
// 'renderer' is the renderer for which drawing color should be set. 'r', 'g',
// 'b', and 'a' respectively set the red, gree, blue, and alpha channels.
// 
// Returns 0 on success, or -1 on error
export @symbol("SDL_SetRenderDrawColor") fn set_render_draw_color(renderer: *renderer,
	r: u8, g: u8, b: u8, a: u8) int;

// Clear the current rendering target with the drawing color
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
//
// Returns 0 on success, or -1 on error
export @symbol("SDL_RenderClear") fn render_clear(renderer: *renderer) int;

// Update the screen with rendering performed.
export @symbol("SDL_RenderPresent") fn render_present(renderer: *renderer) void;
