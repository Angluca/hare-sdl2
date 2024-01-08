use types;
use types::c;
use sdl::v2c::*;

export type display_orientation = enum i32 {
	// The display orientation can't be determined.
	UNKNOWN,
	// The display is in landscape mode, with the right side up, relative to
	// portrait mode.
	LANDSCAPE,
	// The display is in landscape mode, with the left side up, relative to
	// portrait mode.
	LANDSCAPE_FLIPPED,
	// The display is in portrait mode.
	PORTRAIT,
	// The display is in portrait mode, upside down.
	PORTRAIT_FLIPPED,
};

// Get the number of video drivers compiled into SDL.
export fn get_num_video_drivers() (int | error) =
	wrapint(SDL_GetNumVideoDrivers());

// Get the name of the video driver  with the given index.
export fn get_video_driver(index: int) (str | error) =
	c::tostr(wrapptr(SDL_GetVideoDriver(index))?: *c::char)!;

// Get the name of the currently initialized video driver, if there is one.
export fn get_current_video_driver() (str | void) = {
	match (SDL_GetCurrentVideoDriver()) {
	case null =>
		return void;
	case let s: *c::char =>
		return c::tostr(s)!;
	};
};

// Get the number of available video displays.
export fn get_num_video_displays() (int | error) =
	wrapint(SDL_GetNumVideoDisplays());

// Get the name of a display.
export fn get_display_name(index: int) (str | error) =
	c::tostr(wrapptr(SDL_GetDisplayName(index))?: *c::char)!;

// Get the desktop area represented by a display.
//
// The primary display (index zero) is always located at 0, 0.
export fn get_display_bounds(index: int) (rect | error) = {
	let r = rect { ... };
	wrapint(SDL_GetDisplayBounds(index, &r: *SDL_Rect))?;
	return r;
};

// Get the usable desktop area represented by a display.
//
// The primary display (index zero) is always located at 0, 0.
//
// This is the same area as [[get_display_bounds]] reports, but with portions
// reserved by the system removed.
//
// Setting a window to be fullscreen generally bypasses these unusable areas, so
// these are good guidelines for the maximum space available to a
// non-fullscreen window.
export fn get_display_usable_bounds(index: int) (rect | error) = {
	let r = rect { ... };
	wrapint(SDL_GetDisplayUsableBounds(index, &r: *SDL_Rect))?;
	return r;
};

// DPI information.
export type dpi = struct {
	ddpi: f32, // Diagonal DPI.
	hdpi: f32, // Horizontal DPI.
	vdpi: f32, // Vertical DPI.
};

// Get the dots/pixels-per-inch for a display.
// 
// A failure of this function usually means that either no DPI information is
// available or the index is out of range.
// 
// **WARNING**: This reports the DPI that the hardware reports, and it is not
// always reliable! It is almost always better to use SDL_GetWindowSize() to
// find the window size, which might be in logical points instead of pixels,
// and then [[gl_get_drawable_size]], vulkan_get_drawable_size, or
// [[get_renderer_output_size]], and compare the two values to get an actual
// scaling value between the two. We will be rethinking how high-dpi details
// should be managed in SDL3 to make things more consistent, reliable, and
// clear.
export fn get_display_dpi(index: int) (dpi | error) = {
	let d = dpi { ... };
	wrapint(SDL_GetDisplayDPI(index, &d.ddpi, &d.hdpi, &d.vdpi))?;
	return d;
};

// Get the orientation of a display, or UNKNOWN if it isn't available.
export fn get_display_orientation(index: int) display_orientation =
	SDL_GetDisplayOrientation(index): display_orientation;

// Get the number of available display modes.
export fn get_num_display_modes(display_index: int) (int | error) =
	wrapint(SDL_GetNumDisplayModes(display_index));

// The structure that defines a display mode.
export type display_mode = struct {
	format: u32, // Pixel format.
	w: int, // Width, in screen coordinates.
	h: int, // Height, in screen coordinates.
	refresh_rate: int, // Refresh rate (or zero for unspecified).
	driverdata: nullable *opaque, // Driver-specific data.
};

// Get information about a specific display mode.
//
// The display modes are sorted in this priority:
//
// - width -> largest to smallest
// - height -> largest to smallest
// - bits per pixel -> more colors to fewer colors
// - packed pixel layout -> largest to smallest
// - refresh rate -> highest to lowest
export fn get_display_mode(
	display_index: int,
	mode_index: int,
) (display_mode | error) = {
	let d = display_mode { ... };
	wrapint(SDL_GetDisplayMode(display_index, mode_index, &d))?;
	return d;
};

// TODO more display mode functions

// The type used to identify a window.
export type window = opaque;
export type window_id = u32;

// The flags on a window.
export type window_flags = enum u32 {
	FULLSCREEN = 0x00000001, // Fullscreen window.
	OPENGL = 0x00000002, // Window usable with OpenGL context.
	SHOWN = 0x00000004, // Window is visible.
	HIDDEN = 0x00000008, // Window is not visible.
	BORDERLESS = 0x00000010, // No window decoration.
	RESIZABLE = 0x00000020, // Window can be resized.
	MINIMIZED = 0x00000040, // Window is minimized.
	MAXIMIZED = 0x00000080, // Window is maximized.
	MOUSE_GRABBED = 0x00000100, // Window has grabbed mouse input.
	INPUT_FOCUS = 0x00000200, // Window has input focus.
	MOUSE_FOCUS = 0x00000400, // Window has mouse focus.
	FULLSCREEN_DESKTOP = 0x00001001,
	FOREIGN = 0x00000800, // Window not created by SDL.
	ALLOW_HIGHDPI = 0x00002000, // Window should be created in high-DPI mode if supported.
	MOUSE_CAPTURE = 0x00004000, // Window has mouse captured.
	ALWAYS_ON_TOP = 0x00008000, // Window should always be above others.
	SKIP_TASKBAR = 0x00010000, // Window should not be added to the taskbar.
	UTILITY = 0x00020000, // Window should be treated as a utility window.
	TOOLTIP = 0x00040000, // Window should be treated as a tooltip.
	POPUP_MENU = 0x00080000, // Window should be treated as a popup menu.
	KEYBOARD_GRABBED = 0x00100000, // Window has grabbed keyboard input.
	VULKAN = 0x10000000, // Window usable for Vulkan surface.
	INPUT_GRABBED = 0x00000100, // Equivalent to MOUSE_GRABBED.
};

export def WINDOWPOS_UNDEFINED = 0x1FFF0000;
export def WINDOWPOS_CENTERED = 0x2FFF0000;

// Create a window with the specified position, dimensions, and flags.
//
// windowflags::SHOWN is ignored by [[create_window]]. The window is
// implicitly shown if HIDDEN is not set.
//
// If the window is created with the ALLOW_HIGHDPI flag, its size in pixels may
// differ from its size in screen coordinates on platforms with high-DPI
// support. Use [[get_window_size]] to query the client area's size in screen
// coordinates, and [[gl_get_drawable_size]] or [[get_renderer_output_size]] to
// query the drawable size in pixels. Note that when this flag is set, the
// drawable size can vary after the window is created and should be queried
// after major window events such as when the window is resized or moved between
// displays.
// 
// If the window is set fullscreen, the width and height parameters w and h will
// not be used. However, invalid size parameters (e.g. too large) may still
// fail. Window size is actually limited to 16384 x 16384 for all platforms at
// window creation.
// 
// If the window is created with any of the OPENGL or VULKAN flags, then the
// corresponding load_library function ([[gl_load_library]] or
// vulkan_load_library) is called and the corresponding unload_library
// function is called by [[destroy_window]].
// 
// If VULKAN is specified and there isn't a working Vulkan driver,
// [[create_window]] will fail because vulkan_load_library will fail.
export fn create_window(
	title: str,
	x: int,
	y: int,
	w: int,
	h: int,
	flags: window_flags,
) (*window | error) = {
	let t = c::fromstr(title);
	defer free(t);
	return wrapptr(SDL_CreateWindow(t, x, y, w, h, flags))?: *window;
};

// Create an SDL window from an existing native window.
// 
// In some cases (e.g. OpenGL) and on some platforms, the hint
// `SDL_HINT_VIDEO_WINDOW_SHARE_PIXEL_FORMAT` needs to be configured
// before using [[create_window_from]]. TODO change hint name
export fn create_window_from(data: *opaque) (*window | error) =
	wrapptr(SDL_CreateWindowFrom(data))?: *window;

// Get the numeric ID of a window.
// 
// The numeric ID is what window events reference, and is necessary to map these
// events to specific window objects.
export fn get_window_id(window: *window) (window_id | error) = {
	let id = SDL_GetWindowID(window: *SDL_Window);
	if (id == 0) return c::tostr(SDL_GetError())!;
	return id;
};

// Get a window from a stored ID.
// 
// The numeric ID is what window events reference, and is necessary to map these
// events to specific window objects.
export fn get_window_from_id(id: window_id) (*window | error) =
	wrapptr(SDL_GetWindowFromID(id))?: *window;

// Get the window flags.
export fn get_window_flags(window: *window) window_flags =
	SDL_GetWindowFlags(window: *SDL_Window): window_flags;

// Get the size of a window's client area.
// 
// Result is the pair (width, height).
// 
// The window size in screen coordinates may differ from the size in pixels,
// if the window was created with ALLOW_HIGHDPI on a platform with high-dpi
// support. Use [[gl_get_drawable_size]], vulkan_get_drawable_size, or
// [[get_renderer_output_size]] to get the real client area size in pixels.
export fn get_window_size(window: *window) (int, int) = {
	let w = 0, h = 0;
	SDL_GetWindowSize(window: *SDL_Window, &w, &h);
	return (w, h);
};

// Return whether the window has a surface associated with it.
export fn has_window_surface(window: *window) bool =
	SDL_HasWindowSurface(window: *SDL_Window);

// Get the SDL surface associated with the window.
// 
// A new surface will be created with the optimal format for the window, if
// necessary. This surface will be freed when the window is destroyed. Do not
// free this surface.
// 
// This surface will be invalidated if the window is resized. After resizing a
// window this function must be called again to return a valid surface.
// 
// You may not combine this with 3D or the rendering API on this window.
// 
// This function is affected by `SDL_HINT_FRAMEBUFFER_ACCELERATION`.
// TODO hint name?
export fn get_window_surface(window: *window) (*surface | error) =
	wrapptr(SDL_GetWindowSurface(window: *SDL_Window))?: *surface;

// Copy the window surface to the screen.
// 
// This is the function you use to reflect any changes to the surface on the
// screen.
// 
// This function is equivalent to the SDL 1.2 API SDL_Flip().
export fn update_window_surface(window: *window) (void | error) =
	wrapvoid(SDL_UpdateWindowSurface(window: *SDL_Window))?;

// Copy areas of the window surface to the screen.
// 
// This is the function you use to reflect changes to portions of the surface
// on the screen.
// 
// This function is equivalent to the SDL 1.2 API SDL_UpdateRects().
export fn update_window_surface_rects(
	window: *window,
	rects: []rect,
) (void | error) = {
	let rs = &rects: *types::slice;
	return wrapvoid(SDL_UpdateWindowSurfaceRects(window: *SDL_Window,
		rs.data: *SDL_Rect, rs.length: int));
};

// Destroy the surface associated with the window.
export fn destroy_window_surface(window: *window) (void | error) =
	wrapvoid(SDL_DestroyWindowSurface(window: *SDL_Window));

// Destroy a window.
export fn destroy_window(window: *window) void =
	SDL_DestroyWindow(window: *SDL_Window);

// Set the title of a window.
export fn set_window_title(window: *window, title: str) void = {
	let t = c::fromstr(title);
	defer free(t);
	return SDL_SetWindowTitle(window: *SDL_Window, t);
};

// Get the title of a window, or empty string if there is none.
export fn get_window_title(window: *window) str =
	c::tostr(SDL_GetWindowTitle(window: *SDL_Window))!;

// Set the icon for a window.
export fn set_window_icon(window: *window, icon: *surface) void =
	SDL_SetWindowIcon(window: *SDL_Window, icon: *SDL_Surface);

// Associate an arbitrary named pointer with a window.
//
// name is case-sensitive. Returns the previous value associated with name.
export fn set_window_data(
	window: *window,
	name: str,
	userdata: nullable *opaque,
) nullable *opaque = {
	let n = c::fromstr(name);
	defer free(n);
	return SDL_SetWindowData(window: *SDL_Window, n, userdata);
};

// Retrieve the data pointer associated with a window.
export fn get_window_data(window: *window, name: str) nullable *opaque = {
	let n = c::fromstr(name);
	defer free(n);
	return SDL_GetWindowData(window: *SDL_Window, n);
};

// Set the position of a window.
//
// The window coordinate origin is the upper left of the display.
//
// Coordinates are screen coordinates, with their origin at the upper left of
// the display, or [[WINDOWPOS_CENTERED]] or [[WINDOWPOS_UNDEFINED]].
export fn set_window_position(window: *window, x: int, y: int) void =
	SDL_SetWindowPosition(window: *SDL_Window, x, y);

// Get the position of a window.
//
// If you do not need the value for one of the positions a null may be passed
// in the x or y parameter.
export fn get_window_position(
	window: *window,
	x: nullable *int,
	y: nullable *int,
) void = {
	return SDL_GetWindowPosition(window: *SDL_Window, x, y);
};

// Set the size of a window's client area.
//
// The window size in screen coordinates may differ from the size in pixels,
// if the window was created with ALLOW_HIGHDPI on a platform with high-dpi
// support. Use [[gl_get_drawable_size]] or
// [[get_renderer_output_size]] to get the real client area size in pixels.
//
// Fullscreen windows automatically match the size of the display mode, and
// you should use set_window_display_mode to change their size.
export fn set_window_size(window: *window, w: int, h: int) void = {
	return SDL_SetWindowSize(window: *SDL_Window, w, h);
};

// Get the size of a window's borders (decorations) around the client area.
//
// Note: If this function fails, the size values will be initialized to
// 0, 0, 0, 0 (if a non-null pointer is provided), as if the window in question
// was borderless.
//
// Note: This function may fail on systems where the window has not yet been
// decorated by the display server (for example, immediately after calling
// [[create_window]]. It is recommended that you wait at least until the
// window has been presented and composited, so that the window system has a
// chance to decorate the window and provide the border dimensions to SDL.
//
// This function also fails if getting the information is not supported.
export fn get_window_borders_size(
	window: *window,
	top: nullable *int,
	left: nullable *int,
	bottom: nullable *int,
	right: nullable *int,
) (void | error) = {
	return wrapvoid(SDL_GetWindowBordersSize(window: *SDL_Window,
		top, left, bottom, right));
};

// Get the size of a window in pixels.
//
// This may differ from [[get_window_size]] if we're rendering to a high-DPI
// drawable, i.e. the window was created with ALLOW_HIGHDPI on a platform
// with high-DPI support (Apple calls this "Retina"), and not disabled by the
// `[[HINT_VIDEO_HIGHDPI_DISABLED]]` hint.
// TODO hint names?
export fn get_window_size_in_pixels(
	window: *window,
	w: nullable *int,
	h: nullable *int,
) void = SDL_GetWindowSizeInPixels(window: *SDL_Window, w, h);

// Set the minimum size of a window's client area in pixels.
export fn set_window_minimum_size(
	window: *window,
	min_w: int,
	min_h: int,
) void = SDL_SetWindowMinimumSize(window: *SDL_Window, min_w, min_h);

// Get the minimum size of a window's client area.
export fn get_window_minimum_size(
	window: *window,
	w: nullable *int,
	h: nullable *int,
) void = SDL_GetWindowMinimumSize(window: *SDL_Window, w, h);

// Set the maximum size of a window's client area in pixels.
export fn set_window_maximum_size(
	window: *window,
	max_w: int,
	max_h: int,
) void = SDL_SetWindowMaximumSize(window: *SDL_Window, max_w, max_h);

// Get the maximum size of a window's client area.
export fn get_window_maximum_size(
	window: *window,
	w: nullable *int,
	h: nullable *int,
) void = SDL_GetWindowMaximumSize(window: *SDL_Window, w, h);

// Set the border state of a window.
//
// This will add or remove the window's BORDERLESS flag and add or remove the
// border from the actual window. This is a no-op if the window's border already
// matches the requested state.
//
// You can't change the border state of a fullscreen window.
export fn set_window_bordered(window: *window, bordered: bool) void =
	SDL_SetWindowBordered(window: *SDL_Window, bordered);

// Set the user-resizable state of a window.
//
// This will add or remove the window's RESIZABLE flag and allow/disallow user
// resizing of the window. This is a no-op if the window's resizable state
// already matches the requested state.
//
// You can't change the resizable state of a fullscreen window.
export fn set_window_resizable(window: *window, resizable: bool) void =
	SDL_SetWindowResizable(window: *SDL_Window, resizable);

// Set the window to always be above the others.
//
// This will add or remove the window's ALWAYS_ON_TOP flag. This will bring the
// window to the front and keep the window above the rest.
export fn set_window_always_on_top(window: *window, on_top: bool) void =
	SDL_SetWindowAlwaysOnTop(window: *SDL_Window, on_top);

// Show a window.
export fn show_window(window: *window) void =
	SDL_ShowWindow(window: *SDL_Window);

// Hide a window.
export fn hide_window(window: *window) void =
	SDL_HideWindow(window: *SDL_Window);

// Raise a window above other windows and set the input focus.
export fn raise_window(window: *window) void =
	SDL_RaiseWindow(window: *SDL_Window);

// Make a window as large as possible.
export fn maximize_window(window: *window) void =
	SDL_MaximizeWindow(window: *SDL_Window);

// Minimize a window to an iconic representation.
export fn minimize_window(window: *window) void =
	SDL_MinimizeWindow(window: *SDL_Window);

// Restore the size and position of a minimized or maximized window.
export fn restore_window(window: *window) void =
	SDL_RestoreWindow(window: *SDL_Window);

// Set a window's fullscreen state.
//
// flags may be FULLSCREEN, for "real" fullscreen with a videomode change,
// FULLSCREEN_DESKTOP for "fake" fullscreen that takes the size of the desktop,
// and 0 for windowed mode.
export fn set_window_fullscreen(
	window: *window,
	flags: window_flags,
) (void | error) = {
	return wrapvoid(SDL_SetWindowFullscreen(window: *SDL_Window, flags));
};

// Set a window's input grab mode.
//
// When input is grabbed, the mouse is confined to the window. This function
// will also grab the keyboard if HINT_GRAB_KEYBOARD is set. To grab the
// keyboard without also grabbing the mouse, use [[set_window_keyboard_grab]].
//
// If the caller enables a grab while another window is currently grabbed, the
// other window loses its grab in favor of the caller's window.
export fn set_window_grab(window: *window, grabbed: bool) void = {
	return SDL_SetWindowGrab(window: *SDL_Window, grabbed);
};

// Set a window's keyboard grab mode.
//
// Keyboard grab enables capture of system keyboard shortcuts like Alt+Tab or
// the Meta/Super key. Note that not all system keyboard shortcuts can be
// captured by applications.
//
// This is primarily intended for specialized applications such as VNC clients
// or VM frontends. Normal games should not use keyboard grab.
//
// When keyboard grab is enabled, SDL will continue to handle Alt+Tab when the
// window is full-screen to ensure the user is not trapped in your
// application. If you have a custom keyboard shortcut to exit fullscreen
// mode, you may suppress this behavior with HINT_ALLOW_ALT_TAB_WHILE_GRABBED.
//
// If the caller enables a grab while another window is currently grabbed, the
// other window loses its grab in favor of the caller's window.
export fn set_window_keyboard_grab(window: *window, grabbed: bool) void =
	SDL_SetWindowKeyboardGrab(window: *SDL_Window, grabbed);

// Set a window's mouse grab mode.
//
// Mouse grab confines the mouse cursor to the window.
export fn set_window_mouse_grab(window: *window, grabbed: bool) void =
	SDL_SetWindowMouseGrab(window: *SDL_Window, grabbed);

// Get a window's input grab mode.
export fn get_window_grab(window: *window) bool =
	SDL_GetWindowGrab(window: *SDL_Window);

// Get a window's keyboard grab mode.
export fn get_window_keyboard_grab(window: *window) bool =
	SDL_GetWindowKeyboardGrab(window: *SDL_Window);

// Get a window's mouse grab mode.
export fn get_window_mouse_grab(window: *window) bool =
	SDL_GetWindowMouseGrab(window: *SDL_Window);

// Get the window that currently has an input grab enabled.
export fn get_grabbed_window() (*window | void) = {
	return match (SDL_GetGrabbedWindow()) {
	case null => yield void;
	case let w: *SDL_Window => yield w: *window;
	};
};

// Confines the cursor to the specified area of a window.
//
// Note that this does NOT grab the cursor, it only defines the area a cursor
// is restricted to when the window has mouse focus.
//
// rect should be a rectangle area in window-relative coordinates. If null, the
// barrier for the specified window will be destroyed.
export fn set_window_mouse_rect(
	window: *window,
	rect: nullable *rect,
) (void | error) = {
	return wrapvoid(SDL_SetWindowMouseRect(window: *SDL_Window,
		rect: nullable *SDL_Rect));
};

// Get the mouse confinement rectangle of a window.
export fn get_window_mouse_rect(window: *window) (*rect | void) = {
	return match (SDL_GetWindowMouseRect(window: *SDL_Window)) {
	case null => yield void;
	case let r: *SDL_Rect => yield r: *rect;
	};
};

// Set the brightness (gamma multiplier) for a given window's display.
//
// Despite the name and signature, this method sets the brightness of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using get_window_display_index.) The
// brightness set will not follow the window if it is moved to another
// display.
//
// Many platforms will refuse to set the display brightness in modern times.
// You are better off using a shader to adjust gamma during rendering, or
// something similar.

// brightness the brightness (gamma multiplier) value to set where 0.0 is
// completely dark and 1.0 is normal brightness.
export fn set_window_brightness(
	window: *window,
	brightness: f32,
) (void | error) = {
	return wrapvoid(SDL_SetWindowBrightness(window: *SDL_Window,
		brightness));
};

// Get the brightness (gamma multiplier) for a given window's display.
//
// Despite the name and signature, this method retrieves the brightness of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using get_window_display_index.)
//
// Returns the brightness for the display where 0.0 is completely dark and
// 1.0 is normal brightness.
export fn get_window_brightness(window: *window) f32 =
	SDL_GetWindowBrightness(window: *SDL_Window);

// Set the opacity for a window.
//
// The parameter opacity will be clamped internally between 0.0f (transparent)
// and 1.0f (opaque).
export fn set_window_opacity(window: *window, opacity: f32) (void | error) = {
	return wrapvoid(SDL_SetWindowOpacity(window: *SDL_Window, opacity));
};

// Get the opacity of a window.
//
// If transparency isn't supported on this platform, opacity will be reported
// as 1.0f without error.
export fn get_window_opacity(window: *window) (f32 | error) = {
	let o = 0.0f32;
	wrapvoid(SDL_GetWindowOpacity(window: *SDL_Window, &o))?;
	return o;
};

// Set the window as a modal for another window.
export fn set_window_modal_for(
	modal_window: *window,
	parent_window: *window,
) (void | error) = {
	return wrapvoid(SDL_SetWindowModalFor(modal_window: *SDL_Window,
		parent_window: *SDL_Window));
};

// Explicitly set input focus to the window.
//
// You almost certainly want [[raise_window]] instead of this function. Use
// this with caution, as you might give focus to a window that is completely
// obscured by other windows.
export fn set_window_input_focus(window: *window) (void | error) =
	wrapvoid(SDL_SetWindowInputFocus(window: *SDL_Window));

// Set the gamma ramp for the display that owns a given window.
//
// Set the gamma translation table for the red, green, and blue channels of
// the video hardware. Each table is an array of 256 16-bit quantities,
// representing a mapping between the input and output for that channel. The
// input is the index into the array, and the output is the 16-bit gamma value
// at that index, scaled to the output color precision.
//
// Despite the name and signature, this method sets the gamma ramp of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using get_window_display_index.) The gamma
// ramp set will not follow the window if it is moved to another display.
// TODO ([256]u16 | void) ?
export fn set_window_gamma_ramp(
	window: *window,
	red: nullable *u16,
	green: nullable *u16,
	blue: nullable *u16,
) (void | error) = {
	return wrapvoid(SDL_SetWindowGammaRamp(window: *SDL_Window,
		red, green, blue));
};

// Get the gamma ramp for a given window's display.
//
// Despite the name and signature, this method retrieves the gamma ramp of the
// entire display, not an individual window. A window is considered to be
// owned by the display that contains the window's center pixel. (The index of
// this display can be retrieved using get_window_display_index.)
// TODO some better way?
export fn get_window_gamma_ramp(
	window: *window,
	red: nullable *u16,
	green: nullable *u16,
	blue: nullable *u16,
) (void | error) = {
	return wrapvoid(SDL_GetWindowGammaRamp(window: *SDL_Window,
		red, green, blue));
};

// Possible return values from the hit_test callback.
export type hit_test_result = enum {
	NORMAL, // Region is normal. No special properties.
	DRAGGABLE, // Region can drag entire window.
	RESIZE_TOPLEFT,
	RESIZE_TOP,
	RESIZE_TOPRIGHT,
	RESIZE_RIGHT,
	RESIZE_BOTTOMRIGHT,
	RESIZE_BOTTOM,
	RESIZE_BOTTOMLEFT,
	RESIZE_LEFT,
};

// Callback used for hit-testing.
export type hit_test = nullable *fn(
	win: *window,
	area: *point,
	data: *opaque,
) hit_test_result;

// Provide a callback that decides if a window region has special properties.
//
// Normally windows are dragged and resized by decorations provided by the
// system window manager (a title bar, borders, etc), but for some apps, it
// makes sense to drag them from somewhere else inside the window itself; for
// example, one might have a borderless window that wants to be draggable from
// any part, or simulate its own title bar, etc.
//
// This function lets the app provide a callback that designates pieces of a
// given window as special. This callback is run during event processing if we
// need to tell the OS to treat a region of the window specially; the use of
// this callback is known as "hit testing."
//
// Mouse input may not be delivered to your application if it is within a
// special area; the OS will often apply that input to moving the window or
// resizing the window and not deliver it to the application.
//
// Specifying null for a callback disables hit-testing. Hit-testing is disabled
// by default.
//
// Platforms that don't support this functionality will return error
// unconditionally, even if you're attempting to disable hit-testing.
//
// Your callback may fire at any time, and its firing does not indicate any
// specific behavior (for example, on Windows, this certainly might fire when
// the OS is deciding whether to drag your window, but it fires for lots of
// other reasons, too, some unrelated to anything you probably care about _and
// when the mouse isn't actually at the location it is testing_). Since this
// can fire at any time, you should try to keep your callback efficient,
// devoid of allocations, etc.
export fn set_window_hit_test(
	window: *window,
	callback: hit_test,
	callback_data: nullable *opaque,
) (void | error) = {
	return wrapvoid(SDL_SetWindowHitTest(window: *SDL_Window,
		callback: SDL_HitTest, callback_data));
};

// Window flash operation.
export type flash_operation = enum {
	CANCEL, // Cancel any window flash state.
	BRIEFLY, // Flash the window briefly to get attention.
	UNTIL_FOCUSED, // Flash the window until it gets focus.
};

// Request a window to demand attention from the user.
export fn flash_window(
	window: *window,
	operation: flash_operation,
) (void | error) = {
	return wrapvoid(SDL_FlashWindow(window: *SDL_Window,
		operation: SDL_FlashOperation));
};

// Check whether the screensaver is currently enabled.
export fn is_screen_saver_enabled() bool = SDL_IsScreenSaverEnabled();

// Allow the screen to be blanked by a screen saver.
//
// \since This function is available since SDL 2.0.0.
//
// \sa [[disable_screen_saver]]
// \sa [[is_screen_saver_enabled]]
export fn enable_screen_saver() void = {
	return SDL_EnableScreenSaver();
};

// Prevent the screen from being blanked by a screen saver.
//
// If you disable the screensaver, it is automatically re-enabled when SDL
// quits.
export fn disable_screen_saver() void = SDL_DisableScreenSaver();

// Dynamically load an OpenGL library.
//
// This should be done after initializing the video driver, but before
// creating any OpenGL windows. If no OpenGL library is loaded, the default
// library will be loaded upon creation of the first OpenGL window.
//
// If you do this, you need to retrieve all of the GL functions used in your
// program from the dynamic library using [[gl_get_proc_address]].
//
// path is the platform dependent OpenGL library name, or null to open the
// default OpenGL library
export fn gl_load_library(path: nullable *c::char) (void | error) =
	wrapvoid(SDL_GL_LoadLibrary(path));

// Get an OpenGL function by name.
//
// If the GL library is loaded at runtime with [[gl_load_library]], then all
// GL functions must be retrieved this way. Usually this is used to retrieve
// function pointers to OpenGL extensions.
//
// There are some quirks to looking up OpenGL functions that require some
// extra care from the application. If you code carefully, you can handle
// these quirks without any platform-specific code, though:
//
// - On X11, function pointers returned by this function are valid for any
//   context, and can even be looked up before a context is created at all.
//   This means that, for at least some common OpenGL implementations, if you
//   look up a function that doesn't exist, you'll get a non-null result that
//   is _NOT_ safe to call. You must always make sure the function is actually
//   available for a given GL context before calling it, by checking for the
//   existence of the appropriate extension with [[gl_extension_supported]],
//   or verifying that the version of OpenGL you're using offers the function
//   as core functionality.
// - Some OpenGL drivers, on all platforms, *will* return null if a function
//   isn't supported, but you can't count on this behavior. Check for
//   extensions you use, and if you get a null anyway, act as if that
//   extension wasn't available. This is probably a bug in the driver, but you
//   can code defensively for this scenario anyhow.
// - Just because you're on Linux/Unix, don't assume you'll be using X11.
//   Next-gen display servers are waiting to replace it, and may or may not
//   make the same promises about function pointers.
// - OpenGL function pointers must be declared APIENTRY as in the example code.
//   This will ensure the proper calling convention is followed on platforms
//   where this matters thereby avoiding stack corruption.
export fn gl_get_proc_address(proc: *c::char) (*opaque | error) =
	return wrapptr(SDL_GL_GetProcAddress(proc))?: *opaque;

// Unload the OpenGL library previously loaded by [[gl_load_library]].
export fn gl_unload_library() void = SDL_GL_UnloadLibrary();

// Check if an OpenGL extension is supported for the current context.
//
// This function operates on the current GL context; you must have created a
// context and it must be current before calling this function. Do not assume
// that all contexts you create will have the same set of extensions
// available, or that recreating an existing context will offer the same
// extensions again.
//
// While it's probably not a massive overhead, this function is not an O(1)
// operation. Check the extensions you care about after creating the GL
// context and save that information somewhere instead of calling the function
// every time you need to know.
export fn gl_extension_supported(extension: str) bool = {
	let e = c::fromstr(extension);
	defer free(e);
	return SDL_GL_ExtensionSupported(e);
};

// Reset all previously set OpenGL context attributes to their default values.
export fn gl_reset_attributes() void = SDL_GL_ResetAttributes();

// OpenGL configuration attributes.
export type glattr = enum {
	RED_SIZE,
	GREEN_SIZE,
	BLUE_SIZE,
	ALPHA_SIZE,
	BUFFER_SIZE,
	DOUBLEBUFFER,
	DEPTH_SIZE,
	STENCIL_SIZE,
	ACCUM_RED_SIZE,
	ACCUM_GREEN_SIZE,
	ACCUM_BLUE_SIZE,
	ACCUM_ALPHA_SIZE,
	STEREO,
	MULTISAMPLEBUFFERS,
	MULTISAMPLESAMPLES,
	ACCELERATED_VISUAL,
	RETAINED_BACKING,
	CONTEXT_MAJOR_VERSION,
	CONTEXT_MINOR_VERSION,
	CONTEXT_EGL,
	CONTEXT_FLAGS,
	CONTEXT_PROFILE_MASK,
	SHARE_WITH_CURRENT_CONTEXT,
	FRAMEBUFFER_SRGB_CAPABLE,
	CONTEXT_RELEASE_BEHAVIOR,
	CONTEXT_RESET_NOTIFICATION,
	CONTEXT_NO_ERROR,
	FLOATBUFFERS,
};

// Set an OpenGL window attribute before window creation.
//
// This function sets the OpenGL attribute attr to value. The requested
// attributes should be set before creating an OpenGL window. You should use
// [[gl_get_attribute]] to check the values after creating the OpenGL
// context, since the values obtained can differ from the requested ones.
export fn gl_set_attribute(attr: glattr, value: int) (void | error) =
	return wrapvoid(SDL_GL_SetAttribute(attr: SDL_GLattr, value));

// Get the actual value for an attribute from the current context.
export fn gl_get_attribute(attr: glattr) (int | error) = {
	let v = 0;
	wrapvoid(SDL_GL_GetAttribute(attr: SDL_GLattr, &v))?;
	return v;
};

export type glcontext = opaque;

// Create an OpenGL context for an OpenGL window, and make it current.
export fn gl_create_context(window: *window) (*glcontext | error) =
	wrapptr(SDL_GL_CreateContext(window: *SDL_Window))?: *glcontext;

// Set up an OpenGL context for rendering into an OpenGL window.
//
// The context must have been created with a compatible window.
export fn gl_make_current(
	window: *window,
	context: *glcontext,
) (void | error) = {
	return wrapvoid(SDL_GL_MakeCurrent(window: *SDL_Window,
		context: *SDL_GLContext));
};

// Get the currently active OpenGL window.
export fn gl_get_current_window() (*window | error) = {
	return wrapptr(SDL_GL_GetCurrentWindow())?: *window;
};

// Get the currently active OpenGL context.
export fn gl_get_current_context() (*glcontext | error) =
	wrapptr(SDL_GL_GetCurrentContext())?: *glcontext;

// Get the size of a window's underlying drawable in pixels.
//
// This returns info useful for calling glViewport().
//
// This may differ from [[get_window_size]] if we're rendering to a high-DPI
// drawable, i.e. the window was created with ALLOW_HIGHDPI on a platform with
// high-DPI support, and not disabled by the HINT_VIDEO_HIGHDPI_DISABLED hint.
export fn gl_get_drawable_size(
	window: *window,
	w: nullable *int,
	h: nullable *int,
) void = SDL_GL_GetDrawableSize(window: *SDL_Window, w, h);

// Set the swap interval for the current OpenGL context.
//
// Some systems allow specifying -1 for the interval, to enable adaptive
// vsync. Adaptive vsync works the same as vsync, but if you've already missed
// the vertical retrace for a given frame, it swaps buffers immediately, which
// might be less jarring for the user during occasional framerate drops. If an
// application requests adaptive vsync and the system does not support it,
// this function will fail and return an error. In such a case, you should
// probably retry the call with 1 for the interval.
//
// Adaptive vsync is implemented for some glX drivers with
// GLX_EXT_swap_control_tear.
//
// Read more on the Khronos wiki:
// https://www.khronos.org/opengl/wiki/Swap_Interval#Adaptive_Vsync
//
// interval should be 0 for immediate updates, 1 for updates synchronized with
// the vertical retrace, -1 for adaptive vsync.
export fn gl_set_swap_interval(interval: int) (void | error) =
	wrapvoid(SDL_GL_SetSwapInterval(interval));

// Get the swap interval for the current OpenGL context.
//
// If the system can't determine the swap interval, or there isn't a valid
// current context, this function will return 0 as a safe default.
//
// Returns 0 if there is no vertical retrace synchronization, 1 if the buffer
// swap is synchronized with the vertical retrace, and -1 if late swaps happen
// immediately instead of waiting for the next retrace.
export fn gl_get_swap_interval() int = SDL_GL_GetSwapInterval();

// Update a window with OpenGL rendering.
//
// This is used with double-buffered OpenGL contexts, which are the default.
export fn gl_swap_window(window: *window) void =
	SDL_GL_SwapWindow(window: *SDL_Window);

// Delete an OpenGL context.
export fn gl_delete_context(context: *glcontext) void =
	SDL_GL_DeleteContext(context: *SDL_GLContext);
