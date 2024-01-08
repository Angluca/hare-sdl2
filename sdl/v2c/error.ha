use types::c;

export @symbol("SDL_SetError") fn SDL_SetError(fmt: *c::char, ...) int;
export @symbol("SDL_GetError") fn SDL_GetError() *c::char;
export @symbol("SDL_GetErrorMsg") fn SDL_GetErrorMsg(errstr: *c::char, maxlen: int) *c::char;
export @symbol("SDL_ClearError") fn SDL_ClearError() void;
