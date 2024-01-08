use types::c;

export @symbol("SDL_GetBasePath") fn SDL_GetBasePath() nullable *c::char;
export @symbol("SDL_GetPrefPath") fn SDL_GetPrefPath(org: *c::char, app: *c::char) nullable *c::char;
