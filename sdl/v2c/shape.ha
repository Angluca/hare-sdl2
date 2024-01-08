use types::c;

export def SDL_NONSHAPEABLE_WINDOW = -1;
export def SDL_INVALID_SHAPE_ARGUMENT = -2;
export def SDL_WINDOW_LACKS_SHAPE = -3;

export type WindowShapeMode = enum {
	ShapeModeDefault,
	ShapeModeBinarizeAlpha,
	ShapeModeReverseBinarizeAlpha,
	ShapeModeColorKey
};

export type SDL_WindowShapeParams = union {
	binarizationCutoff: u8,
	colorKey: SDL_Color,
};

export type SDL_WindowShapeMode = struct {
	mode: WindowShapeMode,
	parameters: SDL_WindowShapeParams,
};

export @symbol("SDL_CreateShapedWindow") fn SDL_CreateShapedWindow(title: *c::char, x: int, y: int, w: int, h: int, flags: u32) *SDL_Window;
export @symbol("SDL_IsShapedWindow") fn SDL_IsShapedWindow(window: *SDL_Window) bool;
export @symbol("SDL_SetWindowShape") fn SDL_SetWindowShape(window: *SDL_Window, shape: *SDL_Surface, shape_mode: *SDL_WindowShapeMode) int;
export @symbol("SDL_GetShapedWindowMode") fn SDL_GetShapedWindowMode(window: *SDL_Window, shape_mode: *SDL_WindowShapeMode) int;
