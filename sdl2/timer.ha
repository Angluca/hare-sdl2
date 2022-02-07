// Get the number of milliseconds since SDL library initialization.
//
// This value wraps if the program runs for more than ~49 days.
//
// Returns an unsigned 32-bit value representing the number of milliseconds
// since the SDL library initialized.
export @symbol("SDL_GetTicks") fn SDL_GetTicks() u32;

// Get the current value of the high resolution counter.
//
// This function is typically used for profiling.
//
// The counter values are only meaningful relative to each other. Differences
// between values can be converted to times by using
// [[SDL_GetPerformanceFrequency]].
//
// Returns the current counter value.
export @symbol("SDL_GetPerformanceCounter") fn SDL_GetPerformanceCounter() u64;

// Get the count per second of the high resolution counter.
//
// Returns a platform-specific count per second.
export @symbol("SDL_GetPerformanceFrequency") fn SDL_GetPerformanceFrequency() u64;

// Wait a specified number of milliseconds before returning.
//
// This function waits a specified number of milliseconds before returning. It
// waits at least the specified time, but possibly longer due to OS
// scheduling.
export @symbol("SDL_Delay") fn SDL_Delay(ms: u32) void;

// TODO: Timers
