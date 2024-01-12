use sdl;
use sdl = sdl::blendmode;
use sdl = sdl::rect;
use sdl = sdl::pixels;
use sdl = sdl::surface;
use sdl = sdl::video;
use sdl::v2c::*;
use types;
use types::c;

// Flags used when creating a rendering context.
export type renderer_flags = enum u32 {
	SOFTWARE = 0x00000001, // The renderer is a software fallback.
	ACCELERATED = 0x00000002, // The renderer uses hardware acceleration.
	PRESENTVSYNC = 0x00000004, // Present is synchronized with the refresh rate.
	TARGETTEXTURE = 0x00000008, // The renderer supports rendering to texture.
};

// Information on the capabilities of a render driver or context.
export type renderer_info = struct {
	name: str, // The name of the renderer.
	flags: renderer_flags, // Supported renderer flags.
	texture_formats: []u32, // The available texture formats.
	max_texture_width: int, // The maximum texture width.
	max_texture_height: int, // The maximum texture height.
};

// The scaling mode for a texture.
export type scale_mode = enum  {
	NEAREST, // Nearest pixel sampling.
	LINEAR, // Linear filtering.
	BEST, // Anisotropic filtering.
};

// The access pattern allowed for a texture.
export type texture_access = enum  {
	STATIC, // Changes rarely, not lockable.
	STREAMING, // Changes frequently, lockable.
	TARGET, // Can be used as a render target.
};

// The texture channel modulation used in [[render_copy]].
export type texture_modulate = enum  {
	NONE = 0x00000000, // No modulation.
	COLOR = 0x00000001, // srcC = srcC * color.
	ALPHA = 0x00000002, // srcA = srcA * alpha.
};

// Flip constants for [[render_copy_ex]].
export type renderer_flip = enum u32 {
	NONE, // Do not flip.
	HORIZONTAL, // Flip horizontally.
	VERTICAL, // Flip vertically.
};

// Vertex structure.
export type vertex = struct {
	position: sdl::fpoint, // Vertex position in renderer coordinates.
	color: sdl::color, // Vertex color.
	tex_coord: sdl::fpoint, // Normalized texture coordinates, if needed.
};

// A structure representing rendering state.
export type renderer = opaque;

// An efficient driver-specific representation of pixel data.
export type texture = opaque;

// Get the number of 2D rendering drivers available for the current display.
// 
// A render driver is a set of code that handles rendering and texture
// management on a particular display. Normally there is only one, but some
// drivers may have several available with different capabilities.
// 
// There may be none if SDL was compiled without render support.
export fn get_num_render_drivers() (int | sdl::error) =
	wrapint(SDL_GetNumRenderDrivers());

fn sdl_ri_to_ri(ri: *SDL_RendererInfo) renderer_info = {
	// name and texture_formats are static, so okay to just copy refs.
	const formats = &types::slice {
		data = &ri.texture_formats,
		length = ri.num_texture_formats: size,
		capacity = ri.num_texture_formats: size,
	};
	return renderer_info {
		name = c::tostr(ri.name: *c::char)!,
		flags = ri.flags: renderer_flags,
		texture_formats = *(formats: *[]u32),
		max_texture_width = ri.max_texture_width,
		max_texture_height = ri.max_texture_height,
	};
};

// Get info about a specific 2D rendering driver for the current display.
export fn get_render_driver_info(index: int) (renderer_info | sdl::error) = {
	const ri = SDL_RendererInfo { ... };
	wrapint(SDL_GetRenderDriverInfo(index, &ri))?;
	return sdl_ri_to_ri(&ri);
};

// Create a window and default renderer.
export fn create_window_and_renderer(
	width: int,
	height: int,
	flags: sdl::window_flags,
) ((*sdl::window, *renderer) | sdl::error) = {
	let w: nullable *SDL_Window = null;
	let r: nullable *SDL_Renderer = null;
	wrapint(SDL_CreateWindowAndRenderer(width, height,
		flags: SDL_WindowFlags, &w, &r))?;
	// SDL claims that these should not be null at this point.
	return (w: *sdl::window, r: *renderer);
};

// Create a 2D rendering context for a window.
//
// index is the index of the rendering driver, or -1 for the first one
// supporting the requested flags.
export fn create_renderer(
	window: *sdl::window,
	index: int,
	flags: renderer_flags,
) (*renderer | sdl::error) = wrapptr(SDL_CreateRenderer(
	window: *SDL_Window, index, flags: SDL_RendererFlags))?: *renderer;

// Create a 2D software rendering context for a surface.
// 
// Two other API which can be used to create [[renderer]]: [[create_renderer]]
// and [[create_window_and_renderer]]. These can also create a software
// renderer, but they are intended to be used with a [[window]] as the final
// destination and not a [[surface]].
export fn create_software_renderer(surface: *sdl::surface) (*renderer | sdl::error) =
	wrapptr(SDL_CreateSoftwareRenderer(surface: *SDL_Surface))?: *renderer;

// Get the renderer associated with a window.
export fn get_renderer(window: *sdl::window) (*renderer | sdl::error) =
	wrapptr(SDL_GetRenderer(window: *SDL_Window))?: *renderer;

// Get the window associated with a renderer.
export fn render_get_window(renderer: *renderer) (*sdl::window | sdl::error) =
	wrapptr(SDL_RenderGetWindow(renderer: *SDL_Renderer))?: *sdl::window;

// Get information about a rendering context.
export fn get_renderer_info(renderer: *renderer) (renderer_info | sdl::error) = {
	const ri = SDL_RendererInfo { ... };
	wrapint(SDL_GetRendererInfo(renderer: *SDL_Renderer, &ri))?;
	return sdl_ri_to_ri(&ri);
};

// Get the output size in pixels of a rendering context.
// 
// Due to high-dpi displays, you might end up with a rendering context that
// has more pixels than the window that contains it, so use this instead of
// [[get_window_size]] to decide how much drawing area you have.
export fn get_renderer_output_size(
	renderer: *renderer,
	w: nullable *int,
	h: nullable *int,
) (void | sdl::error) = {
	wrapvoid(SDL_GetRendererOutputSize(renderer: *SDL_Renderer, w, h))?;
};

// Clear the current rendering target with the drawing color.
// 
// This function clears the entire rendering target, ignoring the viewport and
// the clip rectangle.
export fn render_clear(renderer: *renderer) (void | sdl::error) =
	wrapvoid(SDL_RenderClear(renderer: *SDL_Renderer));

// Update the screen with any rendering performed since the previous call.
// 
// SDL's rendering functions operate on a backbuffer; that is, calling a
// rendering function such as [[render_draw_line]] does not directly put a line
// on the screen, but rather updates the backbuffer. As such, you compose your
// entire scene and *present* the composed backbuffer to the screen as a
// complete picture.
// 
// Therefore, when using SDL's rendering API, one does all drawing intended
// for the frame, and then calls this function once per frame to present the
// final drawing to the user.
// 
// The backbuffer should be considered invalidated after each present; do not
// assume that previous contents will exist between frames. You are strongly
// encouraged to call [[render_clear]] to initialize the backbuffer before
// starting each new frame's drawing, even if you plan to overwrite every
// pixel.
// You may only call this function on the main thread. If this happens to work
// on a background thread on any given platform or backend, it's purely by luck
// and you should not rely on it to work next time.
export fn render_present(renderer: *renderer) void =
	SDL_RenderPresent(renderer: *SDL_Renderer);

// Create a texture for a rendering context.
//
// You can set the texture scaling method by setting
// [[hints::RENDER_SCALE_QUALITY]] before creating the texture.
export fn create_texture(
	renderer: *renderer,
	format: u32, // TODO
	access: int, // TODO
	w: int,
	h: int,
) (*texture | sdl::error) = {
	return wrapptr(SDL_CreateTexture(renderer: *SDL_Renderer, format,
		access, w, h))?: *texture;
};

// Create a texture from an existing surface.
//
// The surface is not modified or freed by this function.
//
// The pixel format of the created texture may be different from the pixel
// format of the surface. Use [[query_texture]] to query the pixel format of
// the texture.
export fn create_texture_from_surface(
	renderer: *renderer,
	surface: *sdl::surface,
) (*texture | sdl::error) = {
	return wrapptr(SDL_CreateTextureFromSurface(renderer: *SDL_Renderer,
		surface: *SDL_Surface))?: *texture;
};

// Query the attributes of a texture.
export fn query_texture(
	texture: *texture,
	format: nullable *u32,
	access: nullable *int,
	w: nullable *int,
	h: nullable *int,
) (void | sdl::error) = {
	return wrapvoid(SDL_QueryTexture(texture: *SDL_Texture, format, access,
		w, h));
};

// Set an additional color value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation each source color
// channel is modulated by the appropriate color value according to the
// following formula:
//
//	srcC = srcC * (color / 255)
//
// Color modulation is not always supported by the renderer; it will return an
// error if color modulation is not supported.
export fn set_texture_color_mod(
	texture: *texture,
	r: u8,
	g: u8,
	b: u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetTextureColorMod(texture: *SDL_Texture, r, g, b));
};

// Get the additional color value multiplied into render copy operations.
export fn get_texture_color_mod(
	texture: *texture,
	r: *u8,
	g: *u8,
	b: *u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_GetTextureColorMod(texture: *SDL_Texture, r, g, b));
};

// Set an additional alpha value multiplied into render copy operations.
//
// When this texture is rendered, during the copy operation the source alpha
// value is modulated by this alpha value according to the following formula:
//
//	srcA = srcA * (alpha / 255)
//
// Alpha modulation is not always supported by the renderer; it will return -1
// if alpha modulation is not supported.
export fn set_texture_alpha_mod(texture: *texture, alpha: u8) (void | sdl::error) =
	wrapvoid(SDL_SetTextureAlphaMod(texture: *SDL_Texture, alpha));

// Get the additional alpha value multiplied into render copy operations.
export fn get_texture_alpha_mod(texture: *texture, alpha: *u8) (void | sdl::error) =
	wrapvoid(SDL_GetTextureAlphaMod(texture: *SDL_Texture, alpha));

// Set the blend mode for a texture, used by [[render_copy]].
//
// If the blend mode is not supported, the closest supported mode is chosen
// and this function returns an error.
export fn set_texture_blend_mode(
	texture: *texture,
	blendMode: sdl::blend_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetTextureBlendMode(texture: *SDL_Texture,
		blendMode: SDL_BlendMode));
};

// Get the blend mode used for texture copy operations.
export fn get_texture_blend_mode(
	texture: *texture,
	blendMode: *sdl::blend_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_GetTextureBlendMode(texture: *SDL_Texture,
		blendMode: *SDL_BlendMode));
};

// Set the scale mode used for texture scale operations.
//
// If the scale mode is not supported, the closest supported mode is chosen.
export fn set_texture_scale_mode(
	texture: *texture,
	scaleMode: scale_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetTextureScaleMode(texture: *SDL_Texture,
		scaleMode: SDL_ScaleMode));
};

// Get the scale mode used for texture scale operations.
export fn get_texture_scale_mode(texture: *texture) (scale_mode | sdl::error) = {
	let sm = scale_mode::NEAREST;
	wrapvoid(SDL_GetTextureScaleMode(texture: *SDL_Texture,
		&sm: *SDL_ScaleMode))?;
	return sm;
};

// Associate a user-specified pointer with a texture.
// TODO can we set null? what does getter do then?
export fn set_texture_user_data(
	texture: *texture,
	userdata: *opaque,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetTextureUserData(texture: *SDL_Texture,
		userdata));
};

// Get the user-specified pointer associated with a texture
export fn get_texture_user_data(texture: *texture) (*opaque | sdl::error) = {
	return wrapptr(SDL_GetTextureUserData(texture: *SDL_Texture))?;
};

// Update the given texture rectangle with new pixel data.
//
// The pixel data must be in the pixel format of the texture. Use
// [[query_texture]] to query the pixel format of the texture.
//
// This is a fairly slow function, intended for use with static textures that
// do not change often.
//
// If the texture is intended to be updated often, it is preferred to create
// the texture as streaming and use the locking functions referenced below.
// While this function will work with streaming textures, for optimization
// reasons you may not get the pixels back if you lock the texture afterward.
export fn update_texture(
	texture: *texture,
	rect: nullable *sdl::rect,
	pixels: *opaque,
	pitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_UpdateTexture(texture: *SDL_Texture,
		rect: nullable *SDL_Rect, pixels, pitch));
};

// Update a rectangle within a planar YV12 or IYUV texture with new pixel
// data.
//
// You can use [[update_texture]] as long as your pixel data is a contiguous
// block of Y and U/V planes in the proper order, but this function is
// available if your pixel data is not contiguous.
export fn update_yuvtexture(
	texture: *texture,
	rect: nullable *sdl::rect,
	Yplane: *u8,
	Ypitch: int,
	Uplane: *u8,
	Upitch: int,
	Vplane: *u8,
	Vpitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_UpdateYUVTexture(texture: *SDL_Texture,
		rect: nullable *SDL_Rect, Yplane, Ypitch, Uplane, Upitch,
		Vplane, Vpitch));
};

// Update a rectangle within a planar NV12 or NV21 texture with new pixels.
//
// You can use [[update_texture]] as long as your pixel data is a contiguous
// block of NV12/21 planes in the proper order, but this function is available
// if your pixel data is not contiguous.
export fn update_nvtexture(
	texture: *texture,
	rect: nullable *sdl::rect,
	Yplane: *u8,
	Ypitch: int,
	UVplane: *u8,
	UVpitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_UpdateNVTexture(texture: *SDL_Texture,
		rect: nullable *SDL_Rect, Yplane, Ypitch, UVplane, UVpitch));
};

// Lock a portion of the texture for **write-only** pixel access.
//
// As an optimization, the pixels made available for editing don't necessarily
// contain the old texture data. This is a write-only operation, and if you
// need to keep a copy of the texture data you should do that at the
// application level.
//
// You must use [[unlock_texture]] to unlock the pixels and apply any
// changes.
// rect is a [[rect]] structure representing the area to lock for access; or
// null to lock the entire texture.
// pixels is filled in with a pointer to the locked pixels, appropriately offset
// by the locked area
// pitch is filled in with the pitch of the locked pixels; the pitch is the
// length of one row in bytes
export fn lock_texture(
	texture: *texture,
	rect: nullable *sdl::rect,
	pixels: **opaque,
	pitch: *int,
) (void | sdl::error) = {
	return wrapvoid(SDL_LockTexture(texture: *SDL_Texture,
		rect: nullable *SDL_Rect, pixels, pitch));
};

// Lock a portion of the texture for **write-only** pixel access, and expose
// it as a SDL surface.
//
// Besides providing an [[surface]] instead of raw pixel data, this function
// operates like [[lock_texture]].
//
// As an optimization, the pixels made available for editing don't necessarily
// contain the old texture data. This is a write-only operation, and if you
// need to keep a copy of the texture data you should do that at the
// application level.
//
// You must use [[unlock_texture]] to unlock the pixels and apply any
// changes.
//
// The returned surface is freed internally after calling [[unlock_texture]]
// or [[destroy_texture]]. The caller should not free it.
//
// The texture to lock for access must have been created with
// texture_access::STREAMING.
// rect is a pointer to the rectangle to lock for access. If the rect is null,
// the entire texture will be locked.
// surface is filled in with an SDL surface representing the locked area.
export fn lock_texture_to_surface(
	texture: *texture,
	rect: nullable *sdl::rect,
	surface: **sdl::surface,
) (void | sdl::error) = {
	return wrapvoid(SDL_LockTextureToSurface(texture: *SDL_Texture,
		rect: nullable *SDL_Rect, surface: **SDL_Surface));
};

// Unlock a texture, uploading the changes to video memory, if needed.
//
// **Warning**: Please note that [[lock_texture]] is intended to be
// write-only; it will not guarantee the previous contents of the texture will
// be provided. You must fully initialize any area of a texture that you lock
// before unlocking it, as the pixels might otherwise be uninitialized memory.
//
// Which is to say: locking and immediately unlocking a texture can result in
// corrupted textures, depending on the renderer in use.
export fn unlock_texture(texture: *texture) void =
	SDL_UnlockTexture(texture: *SDL_Texture);

// Determine whether a renderer supports the use of render targets.
export fn render_target_supported(renderer: *renderer) bool =
	SDL_RenderTargetSupported(renderer: *SDL_Renderer);

// Set a texture as the current rendering target.
//
// Before using this function, you should check the TARGETTEXTURE bit in the
// flags of [[renderer_info]] to see if render targets are supported.
//
// The default render target is the window for which the renderer was created.
// To stop rendering to a texture and render to the window again, call this
// function with a null texture.
export fn set_render_target(
	renderer: *renderer,
	texture: nullable *texture,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetRenderTarget(renderer: *SDL_Renderer,
		texture: nullable *SDL_Texture));
};

// Get the current render target.
//
// The default render target is the window for which the renderer was created,
// and is reported as void here.
export fn get_render_target(renderer: *renderer) (*texture | void) = {
	match (SDL_GetRenderTarget(renderer: *SDL_Renderer)) {
	case null => return void;
	case let t: *SDL_Texture => return t: *texture;
	};
};

// Set a device independent resolution for rendering.
//
// This function uses the viewport and scaling functionality to allow a fixed
// logical resolution for rendering, regardless of the actual output
// resolution. If the actual output resolution doesn't have the same aspect
// ratio the output rendering will be centered within the output display.
//
// If the output display is a window, mouse and touch events in the window
// will be filtered and scaled so they seem to arrive within the logical
// resolution. The HINT_MOUSE_RELATIVE_SCALING hint controls whether
// relative motion events are also scaled.
//
// If this function results in scaling or subpixel drawing by the rendering
// backend, it will be handled using the appropriate quality hints.
export fn render_set_logical_size(
	renderer: *renderer,
	w: int,
	h: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderSetLogicalSize(renderer: *SDL_Renderer,
		w, h));
};

// Get device independent resolution for rendering.
//
// When using the main rendering target (eg no target texture is set): this may
// return 0 for w and h if the [[renderer]] has never had its logical size set
// by [[render_set_logical_size]]. Otherwise it returns the logical width and
// height.
//
// When using a target texture: Never return 0 for w and h at first. Then it
// returns the logical width and height that are set.
export fn render_get_logical_size(renderer: *renderer, w: *int, h: *int) void =
	SDL_RenderGetLogicalSize(renderer: *SDL_Renderer, w, h);

// Set whether to force integer scales for resolution-independent rendering.
//
// This function restricts the logical viewport to integer values - that is,
// when a resolution is between two multiples of a logical size, the viewport
// size is rounded down to the lower multiple.
export fn render_set_integer_scale(
	renderer: *renderer,
	enable: bool,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderSetIntegerScale(renderer: *SDL_Renderer,
		enable));
};

// Get whether integer scales are forced for resolution-independent rendering.
// False can also mean failure, lmao.
export fn render_get_integer_scale(renderer: *renderer) bool =
	SDL_RenderGetIntegerScale(renderer: *SDL_Renderer);

// Set the drawing area for rendering on the current target.
//
// When the window is resized, the viewport is reset to fill the entire new
// window size. The rect can be null to set the viewport to the entire target.
export fn render_set_viewport(
	renderer: *renderer,
	rect: nullable *sdl::rect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderSetViewport(renderer: *SDL_Renderer,
		rect: nullable *SDL_Rect));
};

// Get the drawing area for the current target.
export fn render_get_viewport(renderer: *renderer, rect: *sdl::rect) void =
	SDL_RenderGetViewport(renderer: *SDL_Renderer, rect: *SDL_Rect);

// Set the clip rectangle for rendering on the specified target.
// A null rect disables clipping.
export fn render_set_clip_rect(
	renderer: *renderer,
	rect: nullable *sdl::rect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderSetClipRect(renderer: *SDL_Renderer,
		rect: nullable *SDL_Rect));
};

// Get the clip rectangle for the current target. Rect will be empty if clipping
// is disabled.
export fn render_get_clip_rect(renderer: *renderer, rect: *sdl::rect) void =
	SDL_RenderGetClipRect(renderer: *SDL_Renderer, rect: *SDL_Rect);

// Get whether clipping is enabled on the given renderer.
// False also means error lmao.
export fn render_is_clip_enabled(renderer: *renderer) bool =
	SDL_RenderIsClipEnabled(renderer: *SDL_Renderer);

// Set the drawing scale for rendering on the current target.
//
// The drawing coordinates are scaled by the x/y scaling factors before they
// are used by the renderer. This allows resolution independent drawing with a
// single coordinate system.
//
// If this results in scaling or subpixel drawing by the rendering backend, it
// will be handled using the appropriate quality hints. For best results use
// integer scaling factors.
export fn render_set_scale(
	renderer: *renderer,
	scaleX: f32,
	scaleY: f32,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderSetScale(renderer: *SDL_Renderer,
		scaleX, scaleY));
};

// Get the drawing scale for the current target.
export fn render_get_scale(
	renderer: *renderer,
	scaleX: *f32,
	scaleY: *f32,
) void = SDL_RenderGetScale(renderer: *SDL_Renderer, scaleX, scaleY);

// Get logical coordinates of point in renderer when given real coordinates of
// point in window.
//
// Logical coordinates will differ from real coordinates when render is scaled
// and logical renderer size set
export fn render_window_to_logical(
	renderer: *renderer,
	windowX: int,
	windowY: int,
	logicalX: *f32,
	logicalY: *f32,
) void = {
	return SDL_RenderWindowToLogical(renderer: *SDL_Renderer,
		windowX, windowY, logicalX, logicalY);
};

// Get real coordinates of point in window when given logical coordinates of
// point in renderer.
//
// Logical coordinates will differ from real coordinates when render is scaled
// and logical renderer size set
export fn render_logical_to_window(
	renderer: *renderer,
	logicalX: f32,
	logicalY: f32,
	windowX: *int,
	windowY: *int,
) void = {
	return SDL_RenderLogicalToWindow(renderer: *SDL_Renderer,
		logicalX, logicalY, windowX, windowY);
};

// Set the color used for drawing operations (Rect, Line and Clear).
//
// Set the color for drawing or filling rectangles, lines, and points, and for
// [[render_clear]].
export fn set_render_draw_color(
	renderer: *renderer,
	r: u8,
	g: u8,
	b: u8,
	a: u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetRenderDrawColor(renderer: *SDL_Renderer,
		r, g, b, a));
};

// Get the color used for drawing operations (Rect, Line and Clear).
export fn get_render_draw_color(
	renderer: *renderer,
	r: *u8,
	g: *u8,
	b: *u8,
	a: *u8,
) (void | sdl::error) = {
	return wrapvoid(SDL_GetRenderDrawColor(renderer: *SDL_Renderer,
		r, g, b, a));
};

// Set the blend mode used for drawing operations (Fill and Line).
//
// If the blend mode is not supported, the closest supported mode is chosen.
export fn set_render_draw_blend_mode(
	renderer: *renderer,
	blendMode: sdl::blend_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_SetRenderDrawBlendMode(renderer: *SDL_Renderer,
		blendMode: SDL_BlendMode));
};

// Get the blend mode used for drawing operations.
export fn get_render_draw_blend_mode(
	renderer: *renderer,
	blendMode: *sdl::blend_mode,
) (void | sdl::error) = {
	return wrapvoid(SDL_GetRenderDrawBlendMode(renderer: *SDL_Renderer,
		blendMode: *SDL_BlendMode));
};

// Draw a point on the current rendering target.
//
// [[render_draw_point]] draws a single point. If you want to draw multiple,
// use [[render_draw_points]] instead.
export fn render_draw_point(
	renderer: *renderer,
	x: int,
	y: int,
) (void | sdl::error) = wrapvoid(SDL_RenderDrawPoint(renderer: *SDL_Renderer, x, y));

// Draw multiple points on the current rendering target.
export fn render_draw_points(
	renderer: *renderer,
	points: []sdl::point,
) (void | sdl::error) = {
	let sl = &points: *types::slice;
	return wrapvoid(SDL_RenderDrawPoints(renderer: *SDL_Renderer,
		sl.data: *SDL_Point, sl.length: int));
};

// Draw a line on the current rendering target.
//
// [[render_draw_line]] draws the line to include both end points. If you want
// to draw multiple, connecting lines use [[render_draw_lines]] instead.
export fn render_draw_line(
	renderer: *renderer,
	x1: int,
	y1: int,
	x2: int,
	y2: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderDrawLine(renderer: *SDL_Renderer,
		x1, y1, x2, y2));
};

// Draw a series of connected lines on the current rendering target. Draws
// len(points) - 1 lines.
export fn render_draw_lines(
	renderer: *renderer,
	points: []sdl::point,
) (void | sdl::error) = {
	let sl = &points: *types::slice;
	return wrapvoid(SDL_RenderDrawLines(renderer: *SDL_Renderer,
		sl.data: *SDL_Point, sl.length: int));
};

// Draw a rectangle on the current rendering target.
// rect may be null to outline the entire rendering target
export fn render_draw_rect(
	renderer: *renderer,
	rect: nullable *sdl::rect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderDrawRect(renderer: *SDL_Renderer,
		rect: nullable *SDL_Rect));
};

// Draw some number of rectangles on the current rendering target.
export fn render_draw_rects(
	renderer: *renderer,
	rects: []sdl::rect,
) (void | sdl::error) = {
	let sl = &rects: *types::slice;
	return wrapvoid(SDL_RenderDrawRects(renderer: *SDL_Renderer,
		sl.data: *SDL_Rect, sl.length: int));
};

// Fill a rectangle on the current rendering target with the drawing color.
//
// The current drawing color is set by [[set_render_draw_color]], and the
// color's alpha value is ignored unless blending is enabled with the
// appropriate call to [[set_render_draw_blend_mode]].
//
// rect may be null for the entire rendering target
export fn render_fill_rect(
	renderer: *renderer,
	rect: nullable *sdl::rect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderFillRect(renderer: *SDL_Renderer,
		rect: nullable *SDL_Rect));
};

// Fill some number of rectangles on the current rendering target with the
// drawing color.
export fn render_fill_rects(
	renderer: *renderer,
	rects: []sdl::rect,
) (void | sdl::error) = {
	let sl = &rects: *types::slice;
	return wrapvoid(SDL_RenderFillRects(renderer: *SDL_Renderer,
		sl.data: *SDL_Rect, sl.length: int));
};

// Copy a portion of the texture to the current rendering target.
//
// The texture is blended with the destination based on its blend mode set
// with [[set_texture_blend_mode]].
//
// The texture color is affected based on its color modulation set by
// [[set_texture_color_mod]].
//
// The texture alpha is affected based on its alpha modulation set by
// [[set_texture_alpha_mod]].
//
// srcrect may be null for the entire texture.
// dstrect may be null for the entire rendering target; the texture will be
// stretched to fill the given rectangle.
export fn render_copy(
	renderer: *renderer,
	texture: *texture,
	srcrect: nullable *sdl::rect,
	dstrect: nullable *sdl::rect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderCopy(renderer: *SDL_Renderer,
		texture: *SDL_Texture, srcrect: nullable *SDL_Rect,
		dstrect: nullable *SDL_Rect));
};

// Copy a portion of the texture to the current rendering, with optional
// rotation and flipping.
//
// Copy a portion of the texture to the current rendering target, optionally
// rotating it by angle around the given center and also flipping it
// top-bottom and/or left-right.
//
// The texture is blended with the destination based on its blend mode set
// with [[set_texture_blend_mode]].
//
// The texture color is affected based on its color modulation set by
// [[set_texture_color_mod]].
//
// The texture alpha is affected based on its alpha modulation set by
// [[set_texture_alpha_mod]].
//
// srcrect may be null for the entire texture.
// dstrect may be null for the entire rendering target; the texture will be
// stretched to fill the given rectangle.
// angle is an angle in degrees that indicates the rotation that will be
// applied to dstrect, rotating it in a clockwise direction
// center is a pointer to a point indicating the point around which dstrect
// will be rotated (if null, rotation will be done around dstrect.w / 2,
// dstrect.h / 2.
export fn render_copy_ex(
	renderer: *renderer,
	texture: *texture,
	srcrect: nullable *sdl::rect,
	dstrect: nullable *sdl::rect,
	angle: f64,
	center: nullable *sdl::point,
	flip: renderer_flip,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderCopyEx(renderer: *SDL_Renderer,
		texture: *SDL_Texture, srcrect: nullable *SDL_Rect,
		dstrect: nullable *SDL_Rect, angle, center: nullable *SDL_Point,
		flip: SDL_RendererFlip));
};

// Draw a point on the current rendering target at subpixel precision.
export fn render_draw_point_f(
	renderer: *renderer,
	x: f32,
	y: f32,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderDrawPointF(renderer: *SDL_Renderer, x, y));
};

// Draw multiple points on the current rendering target at subpixel precision.
export fn render_draw_points_f(
	renderer: *renderer,
	points: []sdl::fpoint,
) (void | sdl::error) = {
	let sl = &points: *types::slice;
	return wrapvoid(SDL_RenderDrawPointsF(renderer: *SDL_Renderer,
		sl.data: *SDL_FPoint, sl.length: int));
};

// Draw a line on the current rendering target at subpixel precision.
export fn render_draw_line_f(
	renderer: *renderer,
	x1: f32,
	y1: f32,
	x2: f32,
	y2: f32,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderDrawLineF(renderer: *SDL_Renderer,
		x1, y1, x2, y2));
};

// Draw a series of connected lines on the current rendering target at
// subpixel precision. Draws len(points) - 1 lines.
export fn render_draw_lines_f(
	renderer: *renderer,
	points: []sdl::fpoint,
) (void | sdl::error) = {
	let sl = &points: *types::slice;
	return wrapvoid(SDL_RenderDrawLinesF(renderer: *SDL_Renderer,
		sl.data: *SDL_FPoint, sl.length: int));
};

// Draw a rectangle on the current rendering target at subpixel precision.
// rect may be null to outline the entire rendering target.
export fn render_draw_rect_f(
	renderer: *renderer,
	rect: nullable *sdl::frect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderDrawRectF(renderer: *SDL_Renderer,
		rect: nullable *SDL_FRect));
};

// Draw some number of rectangles on the current rendering target at subpixel
// precision.
export fn render_draw_rects_f(
	renderer: *renderer,
	rects: []sdl::frect,
) (void | sdl::error) = {
	let sl = &rects: *types::slice;
	return wrapvoid(SDL_RenderDrawRectsF(renderer: *SDL_Renderer,
		sl.data: *SDL_FRect, sl.length: int));
};

// Fill a rectangle on the current rendering target with the drawing color at
// subpixel precision.
// rect may be null for the entire rendering target.
export fn render_fill_rect_f(
	renderer: *renderer,
	rect: nullable *sdl::frect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderFillRectF(renderer: *SDL_Renderer,
		rect: nullable *SDL_FRect));
};

// Fill some number of rectangles on the current rendering target with the
// drawing color at subpixel precision.
export fn render_fill_rects_f(
	renderer: *renderer,
	rects: []sdl::frect,
) (void | sdl::error) = {
	let sl = &rects: *types::slice;
	return wrapvoid(SDL_RenderFillRectsF(renderer: *SDL_Renderer,
		sl.data: *SDL_FRect, sl.length: int));
};

// Copy a portion of the texture to the current rendering target at subpixel
// precision.
// srcrect may be null for the entire texture.
// dstrect may be null for the entire rendering target.
export fn render_copy_f(
	renderer: *renderer,
	texture: *texture,
	srcrect: nullable *sdl::rect,
	dstrect: nullable *sdl::frect,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderCopyF(renderer: *SDL_Renderer,
		texture: *SDL_Texture, srcrect: nullable *SDL_Rect,
		dstrect: nullable *SDL_FRect));
};

// Copy a portion of the source texture to the current rendering target, with
// rotation and flipping, at subpixel precision.
// srcrect may be null for the entire texture.
// dstrect may be null for the entire rendering target.
// angle is n angle in degrees that indicates the rotation that will be
// applied to dstrect, rotating it in a clockwise direction.
// center is a pointer to a point indicating the point around which dstrect will
// be rotated (if null, rotation will be done around dstrect.w/2, dstrect.h/2).
export fn render_copy_ex_f(
	renderer: *renderer,
	texture: *texture,
	srcrect: nullable *sdl::rect,
	dstrect: nullable *sdl::frect,
	angle: f64,
	center: nullable *sdl::fpoint,
	flip: renderer_flip,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderCopyExF(renderer: *SDL_Renderer,
		texture: *SDL_Texture, srcrect: nullable *SDL_Rect,
		dstrect: nullable *SDL_FRect, angle,
		center: nullable *SDL_FPoint, flip: SDL_RendererFlip));
};

// Render a list of triangles, optionally using a texture and indices into the
// vertex array Color and alpha modulation is done per vertex
// ([[set_texture_color_mod]] and [[set_texture_alpha_mod]] are ignored).
//
// indices is an optional array of integer indices into the vertices
// array, if len(indices) == 0, all vertices will be rendered in sequential
// order.
// TODO reconsider this interface
export fn render_geometry(
	renderer: *renderer,
	texture: nullable *texture,
	vertices: []vertex,
	indices: []int,
) (void | sdl::error) = {
	let slv = &vertices: *types::slice;
	let sli = &indices: *types::slice;
	return wrapvoid(SDL_RenderGeometry(renderer: *SDL_Renderer,
		texture: nullable *SDL_Texture,
		slv.data: *SDL_Vertex, slv.length: int,
		if (len(indices) == 0) null else sli.data: *int,
		sli.length: int));
};

// Render a list of triangles, optionally using a texture and indices into the
// vertex arrays Color and alpha modulation is done per vertex
// ([[set_texture_color_mod]] and [[set_texture_alpha_mod]] are ignored).
//
// xy is the vertex positions.
// xy_stride is the byte size to move from one element to the next element.
// color is the vertex colors.
// color_stride is the byte size to move from one element to the next element
// uv is vertex normalized texture coordinates.
// uv_stride is byte size to move from one element to the next element
// num_vertices is the number of vertices.
// indices is an optional array of indices into the vertices arrays. If null,
// all vertices will be rendered in sequential order.
// num_indices is the number of indices.
// size_indices is the index size: 1 (byte), 2 (short), 4 (int)
// TODO should we give this a makeover?
export fn render_geometry_raw(
	renderer: *renderer,
	texture: nullable *texture,
	xy: *f32,
	xy_stride: int,
	color: *sdl::color,
	color_stride: int,
	uv: *f32,
	uv_stride: int,
	num_vertices: int,
	indices: nullable *opaque,
	num_indices: int,
	size_indices: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderGeometryRaw(renderer: *SDL_Renderer,
		texture: nullable *SDL_Texture, xy, xy_stride,
		color: *SDL_Color, color_stride, uv, uv_stride,
		num_vertices, indices, num_indices, size_indices));
};

// Read pixels from the current rendering target to an array of pixels.
//
// **WARNING**: This is a very slow operation, and should not be used
// frequently. If you're using this on the main rendering target, it should be
// called after rendering and before [[render_present]].
//
// pitch specifies the number of bytes between rows in the destination
// pixels data. This allows you to write to a subrectangle or have padded
// rows in the destination. Generally, pitch should equal the number of
// pixels per row in the pixels data times the number of bytes per pixel,
// but it might contain additional padding.
//
// rect may be null for the entire render target
// format may be 0 to use the format of the rendering target.
// pixels is a pointer to the pixel data to copy into.
// pitch is the pitch of the pixels parameter.
// TODO makeover mage?
export fn render_read_pixels(
	renderer: *renderer,
	rect: nullable *sdl::rect,
	format: u32,
	pixels: *opaque,
	pitch: int,
) (void | sdl::error) = {
	return wrapvoid(SDL_RenderReadPixels(renderer: *SDL_Renderer,
		rect: nullable *SDL_Rect, format, pixels, pitch));
};

// Destroy the specified texture.
export fn destroy_texture(texture: *texture) void =
	SDL_DestroyTexture(texture: *SDL_Texture);

// Destroy the rendering context for a window and free associated textures.
export fn destroy_renderer(renderer: *renderer) void =
	SDL_DestroyRenderer(renderer: *SDL_Renderer);

// Force the rendering context to flush any pending commands to the underlying
// rendering API.
//
// You do not need to (and in fact, shouldn't) call this function unless you
// are planning to call into OpenGL/whatever directly in addition to using a
// [[renderer]].
//
// This is for a very-specific case: if you are using SDL's render API, you
// asked for a specific renderer backend (OpenGL, Vulkan, etc), you set
// HINT_RENDER_BATCHING to "1", and you plan to make OpenGL/whatever calls in
// addition to SDL render API calls. If all of this applies, you should call
// [[render_flush]] between calls to SDL's render API and the low-level API
// you're using in cooperation.
//
// In all other cases, you can ignore this function. This is only here to get
// maximum performance out of a specific situation. In all other cases, SDL
// will do the right thing, perhaps at a performance loss.
export fn render_flush(renderer: *renderer) (void | sdl::error) =
	wrapvoid(SDL_RenderFlush(renderer: *SDL_Renderer));

// Bind an OpenGL/ES/ES2 texture to the current context.
//
// This is for use with OpenGL instructions when rendering OpenGL primitives
// directly.
//
// If not null, texw and texh will be filled with the width and height values
// suitable for the provided texture. In most cases, both will be 1.0, however,
// on systems that support the GL_ARB_texture_rectangle extension, these values
// will actually be the pixel width and height used to create the texture, so
// this factor needs to be taken into account when providing texture
// coordinates to OpenGL.
//
// You need a renderer to create an [[texture]], therefore you can only use
// this function with an implicit OpenGL context from [[create_renderer]],
// not with your own OpenGL context. If you need control over your OpenGL
// context, you need to write your own texture-loading methods.
//
// Also note that SDL may upload RGB textures as BGR (or vice-versa), and
// re-order the color channels in the shaders phase, so the uploaded texture
// may have swapped color channels.
export fn gl_bind_texture(
	texture: *texture,
	texw: nullable *f32,
	texh: nullable *f32,
) (void | sdl::error) = {
	return wrapvoid(SDL_GL_BindTexture(texture: *SDL_Texture, texw, texh));
};

// Unbind an OpenGL/ES/ES2 texture from the current context.
//
// See [[gl_bind_texture]] for examples on how to use these functions
export fn gl_unbind_texture(texture: *texture) (void | sdl::error) =
	wrapvoid(SDL_GL_UnbindTexture(texture: *SDL_Texture));

// Toggle VSync of the given renderer.
export fn render_set_vsync(renderer: *renderer, vsync: bool) (void | sdl::error) = {
	if (SDL_RenderSetVSync(renderer: *SDL_Renderer,
			if (vsync) 1 else 0) != 0)
		return get_error();
};
