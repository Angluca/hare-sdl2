use types::c;

export type SDL_Keysym = struct {
	scancode: SDL_Scancode,
	sym: SDL_Keycode,
	mod: SDL_Keymod,
	unused: u32,
};

export @symbol("SDL_GetKeyboardFocus") fn SDL_GetKeyboardFocus() nullable *SDL_Window;
export @symbol("SDL_GetKeyboardState") fn SDL_GetKeyboardState(numkeys: nullable *int) *u8;
export @symbol("SDL_ResetKeyboard") fn SDL_ResetKeyboard() void;
export @symbol("SDL_GetModState") fn SDL_GetModState() SDL_Keymod;
export @symbol("SDL_SetModState") fn SDL_SetModState(modstate: SDL_Keymod) void;
export @symbol("SDL_GetKeyFromScancode") fn SDL_GetKeyFromScancode(scancode: SDL_Scancode) SDL_Keycode;
export @symbol("SDL_GetScancodeFromKey") fn SDL_GetScancodeFromKey(key: SDL_Keycode) SDL_Scancode;
export @symbol("SDL_GetScancodeName") fn SDL_GetScancodeName(scancode: SDL_Scancode) *c::char;
export @symbol("SDL_GetScancodeFromName") fn SDL_GetScancodeFromName(name: *c::char) SDL_Scancode;
export @symbol("SDL_GetKeyName") fn SDL_GetKeyName(key: SDL_Keycode) *c::char;
export @symbol("SDL_GetKeyFromName") fn SDL_GetKeyFromName(name: *c::char) SDL_Keycode;
export @symbol("SDL_StartTextInput") fn SDL_StartTextInput() void;
export @symbol("SDL_IsTextInputActive") fn SDL_IsTextInputActive() bool;
export @symbol("SDL_StopTextInput") fn SDL_StopTextInput() void;
export @symbol("SDL_ClearComposition") fn SDL_ClearComposition() void;
export @symbol("SDL_IsTextInputShown") fn SDL_IsTextInputShown() bool;
export @symbol("SDL_SetTextInputRect") fn SDL_SetTextInputRect(rect: nullable *SDL_Rect) void;
export @symbol("SDL_HasScreenKeyboardSupport") fn SDL_HasScreenKeyboardSupport() bool;
export @symbol("SDL_IsScreenKeyboardShown") fn SDL_IsScreenKeyboardShown(window: *SDL_Window) bool;
