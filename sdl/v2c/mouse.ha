export type SDL_Cursor = opaque;

export type SDL_SystemCursor = enum {
	SDL_SYSTEM_CURSOR_ARROW,
	SDL_SYSTEM_CURSOR_IBEAM,
	SDL_SYSTEM_CURSOR_WAIT,
	SDL_SYSTEM_CURSOR_CROSSHAIR,
	SDL_SYSTEM_CURSOR_WAITARROW,
	SDL_SYSTEM_CURSOR_SIZENWSE,
	SDL_SYSTEM_CURSOR_SIZENESW,
	SDL_SYSTEM_CURSOR_SIZEWE,
	SDL_SYSTEM_CURSOR_SIZENS,
	SDL_SYSTEM_CURSOR_SIZEALL,
	SDL_SYSTEM_CURSOR_NO,
	SDL_SYSTEM_CURSOR_HAND,
	SDL_NUM_SYSTEM_CURSORS,
};

export type SDL_MouseWheelDirection = enum u32 {
	SDL_MOUSEWHEEL_NORMAL,
	SDL_MOUSEWHEEL_FLIPPED,
};

export def SDL_BUTTON_LEFT = 1;
export def SDL_BUTTON_MIDDLE = 2;
export def SDL_BUTTON_RIGHT = 3;
export def SDL_BUTTON_X1 = 4;
export def SDL_BUTTON_X2 = 5;
export def SDL_BUTTON_LMASK = 1u << (SDL_BUTTON_LEFT - 1);
export def SDL_BUTTON_MMASK = 1u << (SDL_BUTTON_MIDDLE - 1);
export def SDL_BUTTON_RMASK = 1u << (SDL_BUTTON_RIGHT - 1);
export def SDL_BUTTON_X1MASK = 1u << (SDL_BUTTON_X1- 1);
export def SDL_BUTTON_X2MASK = 1u << (SDL_BUTTON_X2 - 1);

export @symbol("SDL_GetMouseFocus") fn SDL_GetMouseFocus() nullable *SDL_Window;
export @symbol("SDL_GetMouseState") fn SDL_GetMouseState(x: nullable *int, y: nullable *int) u32;
export @symbol("SDL_GetGlobalMouseState") fn SDL_GetGlobalMouseState(x: nullable *int, y: nullable *int) u32;
export @symbol("SDL_GetRelativeMouseState") fn SDL_GetRelativeMouseState(x: nullable *int, y: nullable *int) u32;
export @symbol("SDL_WarpMouseInWindow") fn SDL_WarpMouseInWindow(window: nullable *SDL_Window, x: int, y: int) void;
export @symbol("SDL_WarpMouseGlobal") fn SDL_WarpMouseGlobal(x: int, y: int) int;
export @symbol("SDL_SetRelativeMouseMode") fn SDL_SetRelativeMouseMode(enabled: bool) int;
export @symbol("SDL_CaptureMouse") fn SDL_CaptureMouse(enabled: bool) int;
export @symbol("SDL_GetRelativeMouseMode") fn SDL_GetRelativeMouseMode() bool;
export @symbol("SDL_CreateCursor") fn SDL_CreateCursor(data: *u8, mask: *u8, w: int, h: int, hot_x: int, hot_y: int) nullable *SDL_Cursor;
export @symbol("SDL_CreateColorCursor") fn SDL_CreateColorCursor(surface: *SDL_Surface, hot_x: int, hot_y: int) nullable *SDL_Cursor;
export @symbol("SDL_CreateSystemCursor") fn SDL_CreateSystemCursor(id: SDL_SystemCursor) nullable *SDL_Cursor;
export @symbol("SDL_SetCursor") fn SDL_SetCursor(cursor: nullable *SDL_Cursor) void;
export @symbol("SDL_GetCursor") fn SDL_GetCursor() nullable *SDL_Cursor;
export @symbol("SDL_GetDefaultCursor") fn SDL_GetDefaultCursor() nullable *SDL_Cursor;
export @symbol("SDL_FreeCursor") fn SDL_FreeCursor(cursor: *SDL_Cursor) void;
export @symbol("SDL_ShowCursor") fn SDL_ShowCursor(toggle: int) int;
