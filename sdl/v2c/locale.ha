use types::c;

export type SDL_Locale = struct {
	language: *c::char,
	country: *c::char,
};

export @symbol("SDL_GetPreferredLocales") fn SDL_GetPreferredLocales() nullable *SDL_Locale;
