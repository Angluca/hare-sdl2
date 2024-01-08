export type SDL_TimerCallback = *fn(interval: u32, param: nullable *opaque) u32;
export type SDL_TimerID = int;

export @symbol("SDL_GetTicks") fn SDL_GetTicks() u32;
export @symbol("SDL_GetTicks64") fn SDL_GetTicks64() u64;
export @symbol("SDL_GetPerformanceCounter") fn SDL_GetPerformanceCounter() u64;
export @symbol("SDL_GetPerformanceFrequency") fn SDL_GetPerformanceFrequency() u64;
export @symbol("SDL_Delay") fn SDL_Delay(ms: u32) void;
export @symbol("SDL_AddTimer") fn SDL_AddTimer(interval: u32, callback: SDL_TimerCallback, param: nullable *opaque) SDL_TimerID;
export @symbol("SDL_RemoveTimer") fn SDL_RemoveTimer(id: SDL_TimerID) bool;
