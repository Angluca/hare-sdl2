use sdl::v2c::*;
use strings;
use types::c;

// Put text into the clipboard.
export fn set_clipboard_text(text: str) (void | error) = {
	let t = c::fromstr(text);
	defer free(t);
	return wrapvoid(SDL_SetClipboardText(t));
};

// Get text from the clipboard, which must be freed by the caller.
export fn get_clipboard_text() (str | error) = {
	let cstr = SDL_GetClipboardText();
	defer SDL_free(cstr);
	if (c::strlen(cstr) == 0) return c::tostr(SDL_GetError())!: error;
	return strings::dup(c::tostr(cstr)!);
};

// Query whether the clipboard exists and contains a non-empty text string.
export fn has_clipboard_text() bool = SDL_HasClipboardText();

// Put text into the primary selection.
export fn set_primary_selection_text(text: str) (void | error) = {
	let t = c::fromstr(text);
	defer free(t);
	return wrapvoid(SDL_SetPrimarySelectionText(t));
};

// Get text from the primary selection, which must be freed by the caller.
export fn get_primary_selection_text() (str | error) = {
	let cstr = SDL_GetPrimarySelectionText();
	defer SDL_free(cstr);
	if (c::strlen(cstr) == 0) return c::tostr(SDL_GetError())!: error;
	return strings::dup(c::tostr(cstr)!);
};

// Query whether the primary selection exists and contains a non-empty text
// string.
export fn has_primary_selection_text() bool = SDL_HasPrimarySelectionText();
