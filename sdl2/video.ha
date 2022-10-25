// TODO: Flesh me out
use strings;

// The type used to identify a window. (Opaque)
export type SDL_Window = void;

// The flags on a window
export type SDL_WindowFlags = enum u32 {
	NONE = 0,
	FULLSCREEN = 0x00000001,
	OPENGL = 0x00000002,
	SHOWN = 0x00000004,
	HIDDEN = 0x00000008,
	BORDERLESS = 0x00000010,
	RESIZABLE = 0x00000020,
	MINIMIZED = 0x00000040,
	MAXIMIZED = 0x00000080,
	INPUT_GRABBED = 0x00000100,
	INPUT_FOCUS = 0x00000200,
	MOUSE_FOCUS = 0x00000400,
	FULLSCREEN_DESKTOP = 0x00001001,
	FOREIGN = 0x00000800,
	ALLOW_HIGHDPI = 0x00002000,
	MOUSE_CAPTURE = 0x00004000,
	ALWAYS_ON_TOP = 0x00008000,
	SKIP_TASKBAR = 0x00010000,
	UTILITY = 0x00020000,
	TOOLTIP = 0x00040000,
	POPUP_MENU = 0x00080000,
	VULKAN = 0x10000000
};

export def SDL_WINDOWPOS_UNDEFINED: int = 0x1FFF0000;
export def SDL_WINDOWPOS_CENTERED: int = 0x2FFF0000;

@symbol("SDL_CreateWindow") fn _SDL_CreateWindow(title: const *char,
	x: int, y: int, w: int, h: int, flags: SDL_WindowFlags) nullable *SDL_Window;

// Create a window with the specified position, dimensions, and flags.
//
// 'title' is the title of the window, in UTF-8 encoding. See [[strings::to_c]]
// to prepare a suitable string.
//
// 'x' and 'y' set the position of the window, or use [[SDL_WINDOWPOS_CENTERED]] or
// [[SDL_WINDOWPOS_UNDEFINED]].
//
// 'w' and 'h' set the width and height of the window, in screen coordinates.
//
// 'flags' configure additional window parameters.
//
// Returns the created window, or null if window creation failed.
//
// If the window is created with the SDL_WINDOW_ALLOW_HIGHDPI flag, its size
// in pixels may differ from its size in screen coordinates on platforms with
// high-DPI support (e.g. iOS and Mac OS X). Use SDL_GetWindowSize() to query
// the client area's size in screen coordinates, and SDL_GL_GetDrawableSize(),
// SDL_Vulkan_GetDrawableSize(), or SDL_GetRendererOutputSize() to query the
// drawable size in pixels.
//
// If the window is created with any of the SDL_WINDOW_OPENGL or
// SDL_WINDOW_VULKAN flags, then the corresponding LoadLibrary function
// (SDL_GL_LoadLibrary or SDL_Vulkan_LoadLibrary) is called and the
// corresponding UnloadLibrary function is called by SDL_DestroyWindow().
//
// If SDL_WINDOW_VULKAN is specified and there isn't a working Vulkan driver,
// SDL_CreateWindow() will fail because SDL_Vulkan_LoadLibrary() will fail.
//
// Note: On non-Apple devices, SDL requires you to either not link to the
// Vulkan loader or link to a dynamic library version. This limitation may be
// removed in a future version of SDL.
//
// See also: [[SDL_DestroyWindow]] [[gl_loadlibrary]], [[vulkan_loadlibrary]].
export fn SDL_CreateWindow(
	title: str,
	x: int,
	y: int,
	w: int,
	h: int,
	flags: SDL_WindowFlags,
) (*SDL_Window | error) = {
	let title = strings::to_c(title);
	defer free(title);
	return wrapptr(_SDL_CreateWindow(title, x, y, w, h, flags))?: *SDL_Window;
};

// Destroy a window.
export @symbol("SDL_DestroyWindow") fn SDL_DestroyWindow(window: *SDL_Window) void;

// Get the size of a window's client area.
//
// Null may safely be passed as the 'w' or 'h' parameter if the width or
// height value is not desired.
//
// The window size in screen coordinates may differ from the size in pixels, if
// the window was created with `ALLOW_HIGHDPI` on a platform with high-dpi
// support (e.g. iOS or macOS). Use [[gl_getdrawablesize]],
// [[vulkan_getdrawablesize]], or [[getrendereroutputsize]] to get the real
// client area size in pixels.
export @symbol("SDL_GetWindowSize") fn SDL_GetWindowSize(window: *SDL_Window,
	w: nullable *int, h: nullable *int) void;

// Get the SDL surface associated with the window.
@symbol("SDL_GetWindowSurface") fn _SDL_GetWindowSurface(window: *SDL_Window)
	*SDL_Surface;

export fn SDL_GetWindowSurface(window: *SDL_Window) (*SDL_Surface | error) = {
	return wrapptr(_SDL_GetWindowSurface(window))?: *SDL_Surface;
};
