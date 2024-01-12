use sdl::v2c::*;

// The basic state for the system's power supply.
export type power_state = enum {
	UNKNOWN,
	ON_BATTERY,
	NO_BATTERY,
	CHARGING,
	CHARGED,
};

// Get the current power supply details.
//
// You should never take a battery status as absolute truth. Batteries
// (especially failing batteries) are delicate hardware, and the values
// reported here are best estimates based on what that hardware reports. It's
// not uncommon for older batteries to lose stored power much faster than it
// reports, or completely drain when reporting it has 20 percent left, etc.
//
// Battery status can change at any time; if you are concerned with power
// state, you should call this function frequently, and perhaps ignore changes
// until they seem to be stable for a few seconds.
//
// It's possible a platform can only report battery percentage or time left
// but not both.
//
// Sets seconds to seconds of battery life left, and percent to percentage of
// battery life left. You can pass a null if you don't care about one of the
// numbers. Will set to -1 if we can't determine a value, or we're not running
// on a battery (return value will be [[power_state::NO_BATTERY]]).
export fn get_power_info(
	seconds: nullable *int,
	percent: nullable *int,
) power_state = SDL_GetPowerInfo(seconds, percent): power_state;
