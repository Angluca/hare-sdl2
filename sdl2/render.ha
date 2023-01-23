// TODO: Flesh me out

// A structure representing rendering state. (Opaque)
export type SDL_Renderer = void;

// An efficient driver-specific representation of pixel data. (Opaque)
export type SDL_Texture = void;

export type SDLPixelFormatValues = enum u32 {
    SDL_PIXELFORMAT_UNKNOWN,
    SDL_PIXELFORMAT_INDEX1LSB,
    SDL_PIXELFORMAT_INDEX1MSB,
    SDL_PIXELFORMAT_INDEX4LSB,
    SDL_PIXELFORMAT_INDEX4MSB,
    SDL_PIXELFORMAT_INDEX8,
    SDL_PIXELFORMAT_RGB332,
    SDL_PIXELFORMAT_RGB444,
    SDL_PIXELFORMAT_RGB555,
    SDL_PIXELFORMAT_BGR555,
    SDL_PIXELFORMAT_ARGB4444,
    SDL_PIXELFORMAT_RGBA4444,
    SDL_PIXELFORMAT_ABGR4444,
    SDL_PIXELFORMAT_BGRA4444,
    SDL_PIXELFORMAT_ARGB1555,
    SDL_PIXELFORMAT_RGBA5551,
    SDL_PIXELFORMAT_ABGR1555,
    SDL_PIXELFORMAT_BGRA5551,
    SDL_PIXELFORMAT_RGB565,
    SDL_PIXELFORMAT_BGR565,
    SDL_PIXELFORMAT_RGB24,
    SDL_PIXELFORMAT_BGR24,
    SDL_PIXELFORMAT_RGB888,
    SDL_PIXELFORMAT_RGBX8888,
    SDL_PIXELFORMAT_BGR888,
    SDL_PIXELFORMAT_BGRX8888,
    SDL_PIXELFORMAT_ARGB8888,
    SDL_PIXELFORMAT_RGBA8888,
    SDL_PIXELFORMAT_ABGR8888,
    SDL_PIXELFORMAT_BGRA8888,
};

// Flags used when creating a rendering context.
export type SDL_RendererFlags = enum u32 {
	NONE = 0,
	SOFTWARE = 0x00000001,
	ACCELERATED = 0x00000002,
	PRESENTVSYNC = 0x00000004,
	TARGETTEXTURE = 0x00000008,
};

export type SDL_RendererFlip = enum u32 {
    SDL_FLIP_NONE,
    SDL_FLIP_HORIZONTAL,
    SDL_FLIP_VERTICAL,
    SDL_FLIP_BOTH,
};

export type SDL_TextureAccess = enum {
    SDL_TEXTUREACCESS_STATIC,
    SDL_TEXTUREACCESS_STREAMING,
	SDL_TEXTUREACCESS_TARGET,
};

@symbol("SDL_CreateWindowAndRenderer") fn _SDL_CreateWindowAndRenderer(
	width: int, height: int, SDL_WindowFlags: SDL_WindowFlags,
	window: nullable **SDL_Window, renderer: nullable **SDL_Renderer) int;

// Create a window and default renderer.
//
// 'width' and 'height' set the width and height of the window, in screen
// coordinates. 'SDL_WindowFlags' configure additional window parameters.
//
// 'window' and 'renderer' are out parameters, or null, which are filled in with
// the created window and renderer respectively.
export fn SDL_CreateWindowAndRenderer(
	width: int,
	height: int,
	SDL_WindowFlags: SDL_WindowFlags,
	window: nullable **SDL_Window,
	renderer: nullable **SDL_Renderer,
) (void | error) = wrapvoid(_SDL_CreateWindowAndRenderer(width, height,
	SDL_WindowFlags, window, renderer));

@symbol("SDL_CreateRenderer") fn _SDL_CreateRenderer(window: *SDL_Window,
	index: int, flags: SDL_RendererFlags) nullable *SDL_Renderer;

// Create a 2D rendering context for a window.
//
// 'window' is the window where rendering is displayed. 'index' is the index of
// the rendering driver to initialize, or -1 to initialize the first one
// supporting the requested flags.
//
// See also: [[create_software_renderer]], [[get_renderer_info]],
// [[SDL_DestroyRenderer]].
export fn SDL_CreateRenderer(
	window: *SDL_Window,
	index: int,
	flags: SDL_RendererFlags,
) (*SDL_Renderer | error) =
	wrapptr(_SDL_CreateRenderer(window, index, flags))?: *SDL_Renderer;

// Destroy the rendering context for a window and free associated textures.
//
// See also: [[SDL_CreateRenderer]].
export @symbol("SDL_DestroyRenderer") fn SDL_DestroyRenderer(renderer: *SDL_Renderer) void;

// Opaque value for the alpha channel (255).
export def ALPHA_OPAQUE: u8 = 255;

@symbol("SDL_SetRenderDrawColor") fn _SDL_SetRenderDrawColor(renderer: *SDL_Renderer,
	r: u8, g: u8, b: u8, a: u8) int;

// Set the color used for drawing operations (Rect, Line and Clear).
//
// 'renderer' is the renderer for which drawing color should be set. 'r', 'g',
// 'b', and 'a' respectively set the red, gree, blue, and alpha channels.
export fn SDL_SetRenderDrawColor(
	renderer: *SDL_Renderer,
	r: u8, g: u8, b: u8, a: u8,
) (void | error) = wrapvoid(_SDL_SetRenderDrawColor(renderer, r, g, b, a));

@symbol("SDL_RenderClear") fn _SDL_RenderClear(renderer: *SDL_Renderer) int;

// Clear the current rendering target with the drawing color
//
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
export fn SDL_RenderClear(renderer: *SDL_Renderer) (void | error) = {
	return wrapvoid(_SDL_RenderClear(renderer));
};

// Update the screen with rendering performed.
export @symbol("SDL_RenderPresent") fn SDL_RenderPresent(renderer: *SDL_Renderer) void;

// Destroy the specified texture.
export @symbol("SDL_DestroyTexture") fn SDL_DestroyTexture(texture: *SDL_Texture) void;

@symbol("SDL_QueryTexture") fn _SDL_QueryTexture(texture: *SDL_Texture,
	format: nullable *u32, access: nullable *int,
	w: nullable *int, h: nullable *int) int;

// Query the attributes of a texture
export fn SDL_QueryTexture(
	texture: *SDL_Texture,
	format: nullable *u32,
	access: nullable *int,
	w: nullable *int, h: nullable *int,
) (void | error) = {
	return wrapvoid(_SDL_QueryTexture(texture, format, access, w, h));
};

@symbol("SDL_SetTextureColorMod") fn _SDL_SetTextureColorMod(
	texture: *SDL_Texture, r: u8, g: u8, b: u8) int;

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
export fn SDL_SetTextureColorMod(
	texture: *SDL_Texture,
	r: u8, g: u8, b: u8,
) (void | error) = {
	return wrapvoid(_SDL_SetTextureColorMod(texture, r, g, b));
};

@symbol("SDL_SetTextureAlphaMod") fn _SDL_SetTextureAlphaMod(texture: *SDL_Texture, a: u8) int;

// Set an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
// `srcA = srcA * (alpha / 255)`
//
// Alpha modulation is not always supported by the renderer; it will return an
// error if alpha modulation is not supported.
export fn SDL_SetTextureAlphaMod(texture: *SDL_Texture, a: u8) (void | error) = {
	// TODO: Double check errors
	return wrapvoid(_SDL_SetTextureAlphaMod(texture, a));
};

@symbol("SDL_SetTextureBlendMode") fn _SDL_SetTextureBlendMode(
	texture: *SDL_Texture, mode: SDL_BlendMode) int;

// Set the blend mode for a texture, used by SDL_RenderCopy().
export fn SDL_SetTextureBlendMode(
	texture: *SDL_Texture,
	mode: SDL_BlendMode,
) (void | error) = {
	return wrapvoid(_SDL_SetTextureBlendMode(texture, mode));
};

@symbol("SDL_SetRenderDrawBlendMode") fn _SDL_SetRenderDrawBlendMode(
	renderer: *SDL_Renderer, mode: SDL_BlendMode) int;

// Set the blend mode used for drawing operations (fill and line).
export fn SDL_SetRenderDrawBlendMode(
	renderer: *SDL_Renderer,
	mode: SDL_BlendMode,
) (void | error) = {
	return wrapvoid(_SDL_SetRenderDrawBlendMode(renderer, mode));
};

@symbol("SDL_RenderDrawPoint") fn _SDL_RenderDrawPoint(
    renderer: *SDL_Renderer,
    x: int,
    y: int,
) int;

// Draws a point (pixel) at the given coordinates
export fn SDL_RenderDrawPoint(
    renderer: *SDL_Renderer,
    x: int,
    y: int,
) (void | error) = {
	return wrapvoid(_SDL_RenderDrawPoint(renderer, x, y));
};

@symbol("SDL_RenderCopy") fn _SDL_RenderCopy(renderer: *SDL_Renderer,
	texture: *SDL_Texture, srcrect: nullable *SDL_Rect, dstrect: nullable *SDL_Rect) int;

// Copy a portion of the texture to the current rendering target.
export fn SDL_RenderCopy(
	renderer: *SDL_Renderer,
	texture: *SDL_Texture,
	srcrect: nullable *SDL_Rect,
	dstrect: nullable *SDL_Rect,
) (void | error) = {
	return wrapvoid(_SDL_RenderCopy(renderer, texture, srcrect, dstrect));
};

@symbol("SDL_RenderCopyEx") fn _SDL_RenderCopyEx(
    renderer: *SDL_Renderer,
    texture: *SDL_Texture,
    srcrect: nullable *SDL_Rect,
    dstrect: nullable *SDL_Rect,
    angle  : f64,
    center: nullable *SDL_Point,
    flip: SDL_RendererFlip,
) int;

// Sets the rendering pixel scale
export fn SDL_RenderCopyEx(
    renderer: *SDL_Renderer,
    texture: *SDL_Texture,
    srcrect: nullable *SDL_Rect,
    dstrect: nullable *SDL_Rect,
    angle  : f64,
    center: nullable *SDL_Point,
    flip: SDL_RendererFlip,
) (void | error) = {
	return wrapvoid(_SDL_RenderCopyEx(
        renderer, texture, srcrect, dstrect, angle, center, flip)
    );
};

@symbol("SDL_RenderDrawRect") fn _SDL_RenderDrawRect(
	renderer: *SDL_Renderer, rect: const nullable *SDL_Rect) int;

// Draw a rectangle on the current rendering target.
export fn SDL_RenderDrawRect(
	renderer: *SDL_Renderer,
	rect: const nullable *SDL_Rect,
) (void | error) = {
	return wrapvoid(_SDL_RenderDrawRect(renderer, rect));
};

@symbol("SDL_RenderFillRect") fn _SDL_RenderFillRect(
	renderer: *SDL_Renderer, rect: const nullable *SDL_Rect) int;

// Fills a rectangle on the current rendering target.
export fn SDL_RenderFillRect(
	renderer: *SDL_Renderer,
	rect: const nullable *SDL_Rect,
) (void | error) = {
	return wrapvoid(_SDL_RenderFillRect(renderer, rect));
};

@symbol("SDL_RenderSetLogicalSize") fn _SDL_RenderSetLogicalSize(
    renderer: *SDL_Renderer, w: int, h: int) int;

// Sets the rendering pixel scale
export fn SDL_RenderSetLogicalSize(
    renderer: *SDL_Renderer, 
    w: int, 
    h: int,
) (void | error) = {
	return wrapvoid(_SDL_RenderSetLogicalSize(
        renderer, w, h)
    );
};

@symbol("SDL_CreateTexture") fn _SDL_CreateTexture(
    renderer: *SDL_Renderer,
    format: u32,
    access: int,
    w: int,
    h: int) nullable *SDL_Texture;

export fn SDL_CreateTexture(
    renderer: *SDL_Renderer,
    format: u32,
    access: int,
    w: int,
    h: int
) (*SDL_Texture | error) = {
    return wrapptr(_SDL_CreateTexture(
        renderer, format, access, w, h)
    )?: *SDL_Texture;
};

@symbol("SDL_UpdateTexture") fn _SDL_UpdateTexture(texture: *SDL_Texture,
	rect: const nullable *SDL_Rect, pixels: const nullable *void, pitch: int) int;

// Update the given texture rectangle with new pixel data.
export fn SDL_UpdateTexture(texture: *SDL_Texture,
	rect: const nullable *SDL_Rect, pixels: const nullable *void, pitch: int)
	(int | error) = {
	return wrapint(_SDL_UpdateTexture(texture, rect, pixels, pitch))?: int;
};

@symbol("SDL_LockTexture") fn _SDL_LockTexture(texture: *SDL_Texture,
	rect: const nullable *SDL_Rect, pixels: nullable * nullable *void, pitch: *int) int;

// Lock a portion of the texture for write-only pixel access.
export fn SDL_LockTexture(texture: *SDL_Texture,
	rect: const nullable *SDL_Rect, pixels: nullable * nullable *void, pitch: *int)
	(int | error) = {
	return wrapint(_SDL_LockTexture(texture, rect, pixels, pitch))?: int;
};

// Unlock a texture, uploading the changes to video memory, if needed.
export @symbol("SDL_UnlockTexture") fn SDL_UnlockTexture(texture: *SDL_Texture) void;

@symbol("SDL_RenderSetScale") fn _SDL_RenderSetScale(
    renderer: *SDL_Renderer, scaleX: f32, scaleY: f32) int;

// Sets the rendering pixel scale
export fn SDL_RenderSetScale(
    renderer: *SDL_Renderer, 
    scaleX: f32, 
    scaleY: f32,
) (void | error) = {
	return wrapvoid(_SDL_RenderSetScale(renderer, scaleX, scaleY));
};