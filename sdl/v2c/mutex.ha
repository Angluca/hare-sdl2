use types;

export def SDL_MUTEX_TIMEOUT = 1;
export def SDL_MUTEX_MAXWAIT = types::U32_MAX;

export type SDL_mutex = opaque;
export type SDL_sem = opaque;
export type SDL_cond = opaque;

export @symbol("SDL_CreateMutex") fn SDL_CreateMutex() nullable *SDL_mutex;
export @symbol("SDL_DestroyMutex") fn SDL_DestroyMutex(mutex: *SDL_mutex) void;
export @symbol("SDL_LockMutex") fn SDL_LockMutex(mutex: *SDL_mutex) int;
export @symbol("SDL_TryLockMutex") fn SDL_TryLockMutex(mutex: *SDL_mutex) int;
export @symbol("SDL_UnlockMutex") fn SDL_UnlockMutex(mutex: *SDL_mutex) int;
export @symbol("SDL_CreateSemaphore") fn SDL_CreateSemaphore(initial_value: u32) nullable *SDL_sem;
export @symbol("SDL_DestroySemaphore") fn SDL_DestroySemaphore(sem: *SDL_sem) void;
export @symbol("SDL_SemWait") fn SDL_SemWait(sem: *SDL_sem) int;
export @symbol("SDL_SemTryWait") fn SDL_SemTryWait(sem: *SDL_sem) int;
export @symbol("SDL_SemWaitTimeout") fn SDL_SemWaitTimeout(sem: *SDL_sem, timeout: u32) int;
export @symbol("SDL_SemPost") fn SDL_SemPost(sem: *SDL_sem) int;
export @symbol("SDL_SemValue") fn SDL_SemValue(sem: *SDL_sem) u32;
export @symbol("SDL_CreateCond") fn SDL_CreateCond() nullable *SDL_cond;
export @symbol("SDL_DestroyCond") fn SDL_DestroyCond(cond: *SDL_cond) void;
export @symbol("SDL_CondSignal") fn SDL_CondSignal(cond: *SDL_cond) int;
export @symbol("SDL_CondBroadcast") fn SDL_CondBroadcast(cond: *SDL_cond) int;
export @symbol("SDL_CondWait") fn SDL_CondWait(cond: *SDL_cond, mutex: *SDL_mutex) int;
export @symbol("SDL_CondWaitTimeout") fn SDL_CondWaitTimeout(cond: *SDL_cond, mutex: *SDL_mutex, ms: u32) int;
