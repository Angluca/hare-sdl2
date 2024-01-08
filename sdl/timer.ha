use types::c;
use sdl::v2c::*;

// Get the number of milliseconds since SDL library initialization.
// 
// This value wraps if the program runs for more than ~49 days.
// 
// This function is not recommended as of SDL 2.0.18; use [[get_ticks64]]
// instead, where the value doesn't wrap every ~49 days. There are places in
// SDL where we provide a 32-bit timestamp that can not change without
// breaking binary compatibility, though, so this function isn't officially
// deprecated.
export fn get_ticks() u32 = SDL_GetTicks();

// Get the number of milliseconds since SDL library initialization.
// 
// 64-bit values from this function can be safely compared directly. For
// example, if you want to wait 100 ms, you could do this:
// 
//	const timeout = sdl::get_ticks64() + 100;
//	for (sdl::get_ticks64() < timeout) {
//		// ... do work until timeout has elapsed
//	};
//
export fn get_ticks64() u64 = SDL_GetTicks64();

// Get the current value of the high resolution counter.
//
// This function is typically used for profiling.
//
// The counter values are only meaningful relative to each other. Differences
// between values can be converted to times by using
// [[get_performance_frequency]].
export fn get_performance_counter() u64 = SDL_GetPerformanceCounter();

// Get the counts per second of the high resolution counter.
export fn get_performance_frequency() u64 = SDL_GetPerformanceFrequency();

// Wait a specified number of milliseconds before returning.
//
// This function waits a specified number of milliseconds before returning. It
// waits at least the specified time, but possibly longer due to OS scheduling.
export fn delay(ms: u32) void = SDL_Delay(ms);

// Function prototype for the timer callback function.
// 
// The callback function is passed the current timer interval and returns
// the next timer interval. If the returned value is the same as the one
// passed in, the periodic alarm continues, otherwise a new alarm is
// scheduled. If the callback returns 0, the periodic alarm is cancelled.
export type timer_callback = *fn(interval: u32, param: nullable *opaque) u32;

// Definition of the timer ID type.
export type timer_id = int;

// Call a callback function at a future time.
// 
// If you use this function, you must init the timer subsystem in [[init]].
// 
// The callback function is passed the current timer interval (in ms) and the
// user supplied parameter from the [[add_timer]] call and should return the
// next timer interval. If the value returned from the callback is 0, the timer
// is canceled.
// 
// The callback is run on a separate thread.
// 
// Timers take into account the amount of time it took to execute the
// callback. For example, if the callback took 250 ms to execute and returned
// 1000 (ms), the timer would only wait another 750 ms before its next
// iteration.
// 
// Timing may be inexact due to OS scheduling. Be sure to note the current time
// with [[get_ticks]] or [[get_performance_counter]] in case your callback needs
// to adjust for variances.
export fn add_timer(
	interval: u32,
	callback: timer_callback,
	param: nullable *opaque,
) (timer_id | error) = {
	const r = SDL_AddTimer(interval, callback: SDL_TimerCallback, param);
	return if (r == 0) c::tostr(SDL_GetError()): error else r: timer_id;
};

// Remove a timer created with [[add_timer]].
//
// Returns true if the timer was removed or false if it wasn't found.
export fn remove_timer(id: timer_id) bool = SDL_RemoveTimer(id);
