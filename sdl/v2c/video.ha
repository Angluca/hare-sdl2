use types::c;

export type SDL_DisplayMode = struct {
	format: u32,
	w: int,
	h: int,
	refresh_rate: int,
	driverdata: nullable *opaque,
};

export type SDL_Window = opaque;

export type SDL_WindowFlags = enum u32 {
	SDL_WINDOW_FULLSCREEN = 0x00000001,
	SDL_WINDOW_OPENGL = 0x00000002,
	SDL_WINDOW_SHOWN = 0x00000004,
	SDL_WINDOW_HIDDEN = 0x00000008,
	SDL_WINDOW_BORDERLESS = 0x00000010,
	SDL_WINDOW_RESIZABLE = 0x00000020,
	SDL_WINDOW_MINIMIZED = 0x00000040,
	SDL_WINDOW_MAXIMIZED = 0x00000080,
	SDL_WINDOW_MOUSE_GRABBED = 0x00000100,
	SDL_WINDOW_INPUT_FOCUS = 0x00000200,
	SDL_WINDOW_MOUSE_FOCUS = 0x00000400,
	SDL_WINDOW_FULLSCREEN_DESKTOP = 0x00001001,
	SDL_WINDOW_FOREIGN = 0x00000800,
	SDL_WINDOW_ALLOW_HIGHDPI = 0x00002000,
	SDL_WINDOW_MOUSE_CAPTURE = 0x00004000,
	SDL_WINDOW_ALWAYS_ON_TOP = 0x00008000,
	SDL_WINDOW_SKIP_TASKBAR = 0x00010000,
	SDL_WINDOW_UTILITY = 0x00020000,
	SDL_WINDOW_TOOLTIP = 0x00040000,
	SDL_WINDOW_POPUP_MENU = 0x00080000,
	SDL_WINDOW_KEYBOARD_GRABBED = 0x00100000,
	SDL_WINDOW_VULKAN = 0x10000000,
	SDL_WINDOW_INPUT_GRABBED = 0x00000100,
};

export def SDL_WINDOWPOS_UNDEFINED = 0x1FFF0000;
export def SDL_WINDOWPOS_CENTERED = 0x2FFF0000;

export type SDL_WindowEventID = enum u8 {
	SDL_WINDOWEVENT_NONE,
	SDL_WINDOWEVENT_SHOWN,
	SDL_WINDOWEVENT_HIDDEN,
	SDL_WINDOWEVENT_EXPOSED,
	SDL_WINDOWEVENT_MOVED,
	SDL_WINDOWEVENT_RESIZED,
	SDL_WINDOWEVENT_SIZE_CHANGED,
	SDL_WINDOWEVENT_MINIMIZED,
	SDL_WINDOWEVENT_MAXIMIZED,
	SDL_WINDOWEVENT_RESTORED,
	SDL_WINDOWEVENT_ENTER,
	SDL_WINDOWEVENT_LEAVE,
	SDL_WINDOWEVENT_FOCUS_GAINED,
	SDL_WINDOWEVENT_FOCUS_LOST,
	SDL_WINDOWEVENT_CLOSE,
	SDL_WINDOWEVENT_TAKE_FOCUS,
	SDL_WINDOWEVENT_HIT_TEST,
	SDL_WINDOWEVENT_ICCPROF_CHANGED,
	SDL_WINDOWEVENT_DISPLAY_CHANGED,
};

export type SDL_DisplayEventID = enum u8 {
	SDL_DISPLAYEVENT_NONE,
	SDL_DISPLAYEVENT_ORIENTATION,
	SDL_DISPLAYEVENT_CONNECTED,
	SDL_DISPLAYEVENT_DISCONNECTED,
	SDL_DISPLAYEVENT_MOVED,
};

export type SDL_DisplayOrientation = enum {
	SDL_ORIENTATION_UNKNOWN,
	SDL_ORIENTATION_LANDSCAPE,
	SDL_ORIENTATION_LANDSCAPE_FLIPPED,
	SDL_ORIENTATION_PORTRAIT,
	SDL_ORIENTATION_PORTRAIT_FLIPPED,
};

export type SDL_FlashOperation = enum {
	SDL_FLASH_CANCEL,
	SDL_FLASH_BRIEFLY,
	SDL_FLASH_UNTIL_FOCUSED,
};

export type SDL_GLContext = opaque;

export type SDL_GLattr = enum {
	SDL_GL_RED_SIZE,
	SDL_GL_GREEN_SIZE,
	SDL_GL_BLUE_SIZE,
	SDL_GL_ALPHA_SIZE,
	SDL_GL_BUFFER_SIZE,
	SDL_GL_DOUBLEBUFFER,
	SDL_GL_DEPTH_SIZE,
	SDL_GL_STENCIL_SIZE,
	SDL_GL_ACCUM_RED_SIZE,
	SDL_GL_ACCUM_GREEN_SIZE,
	SDL_GL_ACCUM_BLUE_SIZE,
	SDL_GL_ACCUM_ALPHA_SIZE,
	SDL_GL_STEREO,
	SDL_GL_MULTISAMPLEBUFFERS,
	SDL_GL_MULTISAMPLESAMPLES,
	SDL_GL_ACCELERATED_VISUAL,
	SDL_GL_RETAINED_BACKING,
	SDL_GL_CONTEXT_MAJOR_VERSION,
	SDL_GL_CONTEXT_MINOR_VERSION,
	SDL_GL_CONTEXT_EGL,
	SDL_GL_CONTEXT_FLAGS,
	SDL_GL_CONTEXT_PROFILE_MASK,
	SDL_GL_SHARE_WITH_CURRENT_CONTEXT,
	SDL_GL_FRAMEBUFFER_SRGB_CAPABLE,
	SDL_GL_CONTEXT_RELEASE_BEHAVIOR,
	SDL_GL_CONTEXT_RESET_NOTIFICATION,
	SDL_GL_CONTEXT_NO_ERROR,
	SDL_GL_FLOATBUFFERS,
};

export type SDL_GLprofile = enum {
	SDL_GL_CONTEXT_PROFILE_CORE = 0x0001,
	SDL_GL_CONTEXT_PROFILE_COMPATIBILITY = 0x0002,
	SDL_GL_CONTEXT_PROFILE_ES = 0x0004,
};

export type SDL_GLcontextFlag = enum {
	SDL_GL_CONTEXT_DEBUG_FLAG = 0x0001,
	SDL_GL_CONTEXT_FORWARD_COMPATIBLE_FLAG = 0x0002,
	SDL_GL_CONTEXT_ROBUST_ACCESS_FLAG = 0x0004,
	SDL_GL_CONTEXT_RESET_ISOLATION_FLAG = 0x0008
};

export type SDL_GLcontextReleaseFlag = enum {
	SDL_GL_CONTEXT_RELEASE_BEHAVIOR_NONE = 0x0000,
	SDL_GL_CONTEXT_RELEASE_BEHAVIOR_FLUSH = 0x0001
};

export type SDL_GLContextResetNotification = enum {
	SDL_GL_CONTEXT_RESET_NO_NOTIFICATION = 0x0000,
	SDL_GL_CONTEXT_RESET_LOSE_CONTEXT = 0x0001
};

export @symbol("SDL_GetNumVideoDrivers") fn SDL_GetNumVideoDrivers() int;
export @symbol("SDL_GetVideoDriver") fn SDL_GetVideoDriver(index: int) nullable *c::char;
export @symbol("SDL_VideoInit") fn SDL_VideoInit(driver_name: nullable *c::char) int;
export @symbol("SDL_VideoQuit") fn SDL_VideoQuit() void;
export @symbol("SDL_GetCurrentVideoDriver") fn SDL_GetCurrentVideoDriver() nullable *c::char;
export @symbol("SDL_GetNumVideoDisplays") fn SDL_GetNumVideoDisplays() int;
export @symbol("SDL_GetDisplayName") fn SDL_GetDisplayName(displayIndex: int) nullable *c::char;
export @symbol("SDL_GetDisplayBounds") fn SDL_GetDisplayBounds(displayIndex: int, rect: *SDL_Rect) int;
export @symbol("SDL_GetDisplayUsableBounds") fn SDL_GetDisplayUsableBounds(displayIndex: int, rect: nullable *SDL_Rect) int;
export @symbol("SDL_GetDisplayDPI") fn SDL_GetDisplayDPI(displayIndex: int, ddpi: nullable *f32, hdpi: nullable *f32, vdpi: nullable *f32) int;
export @symbol("SDL_GetDisplayOrientation") fn SDL_GetDisplayOrientation(displayIndex: int) SDL_DisplayOrientation;
export @symbol("SDL_GetNumDisplayModes") fn SDL_GetNumDisplayModes(displayIndex: int) int;
export @symbol("SDL_GetDisplayMode") fn SDL_GetDisplayMode(displayIndex: int, modeIndex: int, mode: *SDL_DisplayMode) int;
export @symbol("SDL_GetDesktopDisplayMode") fn SDL_GetDesktopDisplayMode(displayIndex: int, mode: *SDL_DisplayMode) int;
export @symbol("SDL_GetCurrentDisplayMode") fn SDL_GetCurrentDisplayMode(displayIndex: int, mode: *SDL_DisplayMode) int;
export @symbol("SDL_GetClosestDisplayMode") fn SDL_GetClosestDisplayMode(displayIndex: int, mode: *SDL_DisplayMode, closest: *SDL_DisplayMode) nullable *SDL_DisplayMode;
export @symbol("SDL_GetPointDisplayIndex") fn SDL_GetPointDisplayIndex(point: *SDL_Point) int;
export @symbol("SDL_GetRectDisplayIndex") fn SDL_GetRectDisplayIndex(rect: *SDL_Rect) int;
export @symbol("SDL_GetWindowDisplayIndex") fn SDL_GetWindowDisplayIndex(window: *SDL_Window) int;
export @symbol("SDL_SetWindowDisplayMode") fn SDL_SetWindowDisplayMode(window: *SDL_Window, mode: nullable *SDL_DisplayMode) int;
export @symbol("SDL_GetWindowDisplayMode") fn SDL_GetWindowDisplayMode(window: *SDL_Window, mode: *SDL_DisplayMode) int;
export @symbol("SDL_GetWindowICCProfile") fn SDL_GetWindowICCProfile(window: *SDL_Window, size_: *size) nullable *opaque;
export @symbol("SDL_GetWindowPixelFormat") fn SDL_GetWindowPixelFormat(window: *SDL_Window) u32;
export @symbol("SDL_CreateWindow") fn SDL_CreateWindow(title: *c::char, x: int, y: int, w: int, h: int, flags: u32) nullable *SDL_Window;
export @symbol("SDL_CreateWindowFrom") fn SDL_CreateWindowFrom(data: *opaque) nullable *SDL_Window;
export @symbol("SDL_GetWindowID") fn SDL_GetWindowID(window: *SDL_Window) u32;
export @symbol("SDL_GetWindowFromID") fn SDL_GetWindowFromID(id: u32) nullable *SDL_Window;
export @symbol("SDL_GetWindowFlags") fn SDL_GetWindowFlags(window: *SDL_Window) u32;
export @symbol("SDL_SetWindowTitle") fn SDL_SetWindowTitle(window: *SDL_Window, title: *c::char) void;
export @symbol("SDL_GetWindowTitle") fn SDL_GetWindowTitle(window: *SDL_Window) *c::char;
export @symbol("SDL_SetWindowIcon") fn SDL_SetWindowIcon(window: *SDL_Window, icon: *SDL_Surface) void;
export @symbol("SDL_SetWindowData") fn SDL_SetWindowData(window: *SDL_Window, name: *c::char, userdata: nullable *opaque) nullable *opaque;
export @symbol("SDL_GetWindowData") fn SDL_GetWindowData(window: *SDL_Window, name: *c::char) nullable *opaque;
export @symbol("SDL_SetWindowPosition") fn SDL_SetWindowPosition(window: *SDL_Window, x: int, y: int) void;
export @symbol("SDL_GetWindowPosition") fn SDL_GetWindowPosition(window: *SDL_Window, x: nullable *int, y: nullable *int) void;
export @symbol("SDL_SetWindowSize") fn SDL_SetWindowSize(window: *SDL_Window, w: int, h: int) void;
export @symbol("SDL_GetWindowSize") fn SDL_GetWindowSize(window: *SDL_Window, w: nullable *int, h: nullable *int) void;
export @symbol("SDL_GetWindowBordersSize") fn SDL_GetWindowBordersSize(window: *SDL_Window, top: nullable *int, left: nullable *int, bottom: nullable *int, right: nullable *int) int;
export @symbol("SDL_GetWindowSizeInPixels") fn SDL_GetWindowSizeInPixels(window: *SDL_Window, w: nullable *int, h: nullable *int) void;
export @symbol("SDL_SetWindowMinimumSize") fn SDL_SetWindowMinimumSize(window: *SDL_Window, min_w: int, min_h: int) void;
export @symbol("SDL_GetWindowMinimumSize") fn SDL_GetWindowMinimumSize(window: *SDL_Window, w: nullable *int, h: nullable *int) void;
export @symbol("SDL_SetWindowMaximumSize") fn SDL_SetWindowMaximumSize(window: *SDL_Window, max_w: int, max_h: int) void;
export @symbol("SDL_GetWindowMaximumSize") fn SDL_GetWindowMaximumSize(window: *SDL_Window, w: nullable *int, h: nullable *int) void;
export @symbol("SDL_SetWindowBordered") fn SDL_SetWindowBordered(window: *SDL_Window, bordered: bool) void;
export @symbol("SDL_SetWindowResizable") fn SDL_SetWindowResizable(window: *SDL_Window, resizable: bool) void;
export @symbol("SDL_SetWindowAlwaysOnTop") fn SDL_SetWindowAlwaysOnTop(window: *SDL_Window, on_top: bool) void;
export @symbol("SDL_ShowWindow") fn SDL_ShowWindow(window: *SDL_Window) void;
export @symbol("SDL_HideWindow") fn SDL_HideWindow(window: *SDL_Window) void;
export @symbol("SDL_RaiseWindow") fn SDL_RaiseWindow(window: *SDL_Window) void;
export @symbol("SDL_MaximizeWindow") fn SDL_MaximizeWindow(window: *SDL_Window) void;
export @symbol("SDL_MinimizeWindow") fn SDL_MinimizeWindow(window: *SDL_Window) void;
export @symbol("SDL_RestoreWindow") fn SDL_RestoreWindow(window: *SDL_Window) void;
export @symbol("SDL_SetWindowFullscreen") fn SDL_SetWindowFullscreen(window: *SDL_Window, flags: u32) int;
export @symbol("SDL_HasWindowSurface") fn SDL_HasWindowSurface(window: *SDL_Window) bool;
export @symbol("SDL_GetWindowSurface") fn SDL_GetWindowSurface(window: *SDL_Window) nullable *SDL_Surface;
export @symbol("SDL_UpdateWindowSurface") fn SDL_UpdateWindowSurface(window: *SDL_Window) int;
export @symbol("SDL_UpdateWindowSurfaceRects") fn SDL_UpdateWindowSurfaceRects(window: *SDL_Window, rects: *SDL_Rect, numrects: int) int;
export @symbol("SDL_DestroyWindowSurface") fn SDL_DestroyWindowSurface(window: *SDL_Window) int;
export @symbol("SDL_SetWindowGrab") fn SDL_SetWindowGrab(window: *SDL_Window, grabbed: bool) void;
export @symbol("SDL_SetWindowKeyboardGrab") fn SDL_SetWindowKeyboardGrab(window: *SDL_Window, grabbed: bool) void;
export @symbol("SDL_SetWindowMouseGrab") fn SDL_SetWindowMouseGrab(window: *SDL_Window, grabbed: bool) void;
export @symbol("SDL_GetWindowGrab") fn SDL_GetWindowGrab(window: *SDL_Window) bool;
export @symbol("SDL_GetWindowKeyboardGrab") fn SDL_GetWindowKeyboardGrab(window: *SDL_Window) bool;
export @symbol("SDL_GetWindowMouseGrab") fn SDL_GetWindowMouseGrab(window: *SDL_Window) bool;
export @symbol("SDL_GetGrabbedWindow") fn SDL_GetGrabbedWindow() nullable *SDL_Window;
export @symbol("SDL_SetWindowMouseRect") fn SDL_SetWindowMouseRect(window: *SDL_Window, rect: nullable *SDL_Rect) int;
export @symbol("SDL_GetWindowMouseRect") fn SDL_GetWindowMouseRect(window: *SDL_Window) nullable *SDL_Rect;
export @symbol("SDL_SetWindowBrightness") fn SDL_SetWindowBrightness(window: *SDL_Window, brightness: f32) int;
export @symbol("SDL_GetWindowBrightness") fn SDL_GetWindowBrightness(window: *SDL_Window) f32;
export @symbol("SDL_SetWindowOpacity") fn SDL_SetWindowOpacity(window: *SDL_Window, opacity: f32) int;
export @symbol("SDL_GetWindowOpacity") fn SDL_GetWindowOpacity(window: *SDL_Window, out_opacity: nullable *f32) int;
export @symbol("SDL_SetWindowModalFor") fn SDL_SetWindowModalFor(modal_window: *SDL_Window, parent_window: *SDL_Window) int;
export @symbol("SDL_SetWindowInputFocus") fn SDL_SetWindowInputFocus(window: *SDL_Window) int;
export @symbol("SDL_SetWindowGammaRamp") fn SDL_SetWindowGammaRamp(window: *SDL_Window, red: nullable *u16, green: nullable *u16, blue: nullable *u16) int;
export @symbol("SDL_GetWindowGammaRamp") fn SDL_GetWindowGammaRamp(window: *SDL_Window, red: nullable *u16, green: nullable *u16, blue: nullable *u16) int;

export type SDL_HitTestResult = enum {
	SDL_HITTEST_NORMAL,
	SDL_HITTEST_DRAGGABLE,
	SDL_HITTEST_RESIZE_TOPLEFT,
	SDL_HITTEST_RESIZE_TOP,
	SDL_HITTEST_RESIZE_TOPRIGHT,
	SDL_HITTEST_RESIZE_RIGHT,
	SDL_HITTEST_RESIZE_BOTTOMRIGHT,
	SDL_HITTEST_RESIZE_BOTTOM,
	SDL_HITTEST_RESIZE_BOTTOMLEFT,
	SDL_HITTEST_RESIZE_LEFT,
};

export type SDL_HitTest = nullable *fn(win: *SDL_Window, area: *SDL_Point, data: *opaque) SDL_HitTestResult;

export @symbol("SDL_SetWindowHitTest") fn SDL_SetWindowHitTest(window: *SDL_Window, callback: SDL_HitTest, callback_data: nullable *opaque) int;
export @symbol("SDL_FlashWindow") fn SDL_FlashWindow(window: *SDL_Window, operation: SDL_FlashOperation) int;
export @symbol("SDL_DestroyWindow") fn SDL_DestroyWindow(window: *SDL_Window) void;
export @symbol("SDL_IsScreenSaverEnabled") fn SDL_IsScreenSaverEnabled() bool;
export @symbol("SDL_EnableScreenSaver") fn SDL_EnableScreenSaver() void;
export @symbol("SDL_DisableScreenSaver") fn SDL_DisableScreenSaver() void;
export @symbol("SDL_GL_LoadLibrary") fn SDL_GL_LoadLibrary(path: nullable *c::char) int;
export @symbol("SDL_GL_GetProcAddress") fn SDL_GL_GetProcAddress(proc: *c::char) nullable *opaque;
export @symbol("SDL_GL_UnloadLibrary") fn SDL_GL_UnloadLibrary() void;
export @symbol("SDL_GL_ExtensionSupported") fn SDL_GL_ExtensionSupported(extension: *c::char) bool;
export @symbol("SDL_GL_ResetAttributes") fn SDL_GL_ResetAttributes() void;
export @symbol("SDL_GL_SetAttribute") fn SDL_GL_SetAttribute(attr: SDL_GLattr, value: int) int;
export @symbol("SDL_GL_GetAttribute") fn SDL_GL_GetAttribute(attr: SDL_GLattr, value: *int) int;
export @symbol("SDL_GL_CreateContext") fn SDL_GL_CreateContext(window: *SDL_Window) nullable *SDL_GLContext;
export @symbol("SDL_GL_MakeCurrent") fn SDL_GL_MakeCurrent(window: *SDL_Window, context: *SDL_GLContext) int;
export @symbol("SDL_GL_GetCurrentWindow") fn SDL_GL_GetCurrentWindow() nullable *SDL_Window;
export @symbol("SDL_GL_GetCurrentContext") fn SDL_GL_GetCurrentContext() nullable *SDL_GLContext;
export @symbol("SDL_GL_GetDrawableSize") fn SDL_GL_GetDrawableSize(window: *SDL_Window, w: nullable *int, h: nullable *int) void;
export @symbol("SDL_GL_SetSwapInterval") fn SDL_GL_SetSwapInterval(interval: int) int;
export @symbol("SDL_GL_GetSwapInterval") fn SDL_GL_GetSwapInterval() int;
export @symbol("SDL_GL_SwapWindow") fn SDL_GL_SwapWindow(window: *SDL_Window) void;
export @symbol("SDL_GL_DeleteContext") fn SDL_GL_DeleteContext(context: *SDL_GLContext) void;
