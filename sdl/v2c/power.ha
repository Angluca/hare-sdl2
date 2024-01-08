export type SDL_PowerState = enum {
	SDL_POWERSTATE_UNKNOWN,
	SDL_POWERSTATE_ON_BATTERY,
	SDL_POWERSTATE_NO_BATTERY,
	SDL_POWERSTATE_CHARGING,
	SDL_POWERSTATE_CHARGED,
};

export @symbol("SDL_GetPowerInfo") fn SDL_GetPowerInfo(seconds: nullable *int, percent: nullable *int) SDL_PowerState;
