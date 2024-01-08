use types::c;

export @symbol("SDL_SetClipboardText") fn SDL_SetClipboardText(text: *c::char) int;
export @symbol("SDL_GetClipboardText") fn SDL_GetClipboardText() *c::char;
export @symbol("SDL_HasClipboardText") fn SDL_HasClipboardText() bool;
export @symbol("SDL_SetPrimarySelectionText") fn SDL_SetPrimarySelectionText(text: *c::char) int;
export @symbol("SDL_GetPrimarySelectionText") fn SDL_GetPrimarySelectionText() *c::char;
export @symbol("SDL_HasPrimarySelectionText") fn SDL_HasPrimarySelectionText() bool;
