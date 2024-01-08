use types::c;

export type SDL_Thread = opaque;
export type SDL_threadID = u32;
export type SDL_TLSID = u32;

export type SDL_ThreadPriority = enum {
	SDL_THREAD_PRIORITY_LOW,
	SDL_THREAD_PRIORITY_NORMAL,
	SDL_THREAD_PRIORITY_HIGH,
	SDL_THREAD_PRIORITY_TIME_CRITICAL
};

export type SDL_ThreadFunction = *fn(data: *opaque) int;

export @symbol("SDL_CreateThread") fn SDL_CreateThread(fn_: SDL_ThreadFunction, name: *c::char, data: nullable *opaque) nullable *SDL_Thread;
export @symbol("SDL_CreateThreadWithStackSize") fn SDL_CreateThreadWithStackSize(fn_: SDL_ThreadFunction, name: *c::char, stacksize: size, data: nullable *opaque) nullable *SDL_Thread;
export @symbol("SDL_GetThreadName") fn SDL_GetThreadName(thread: *SDL_Thread) nullable *c::char;
export @symbol("SDL_ThreadID") fn SDL_ThreadID() SDL_threadID;
export @symbol("SDL_GetThreadID") fn SDL_GetThreadID(thread: nullable *SDL_Thread) SDL_threadID;
export @symbol("SDL_SetThreadPriority") fn SDL_SetThreadPriority(priority: SDL_ThreadPriority) int;
export @symbol("SDL_WaitThread") fn SDL_WaitThread(thread: nullable *SDL_Thread, status: nullable *int) void;
export @symbol("SDL_DetachThread") fn SDL_DetachThread(thread: nullable *SDL_Thread) void;
export @symbol("SDL_TLSCreate") fn SDL_TLSCreate() SDL_TLSID;
export @symbol("SDL_TLSGet") fn SDL_TLSGet(id: SDL_TLSID) nullable *opaque;
export @symbol("SDL_TLSSet") fn SDL_TLSSet(id: SDL_TLSID, value: *opaque, destructor: *fn(ptr: *opaque) void) int;
export @symbol("SDL_TLSCleanup") fn SDL_TLSCleanup() void;
