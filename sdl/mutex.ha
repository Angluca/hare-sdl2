use sdl::v2c::*;

// The SDL mutex structure.
export type mutex = opaque;

// Create a new mutex.
//
// All newly-created mutexes begin in the _unlocked_ state.
//
// Calls to [[lock_mutex]] will not return while the mutex is locked by
// another thread. See [[try_lock_mutex]] to attempt to lock without blocking.
//
// SDL mutexes are reentrant.
export fn create_mutex() (*mutex | error) = wrapptr(SDL_CreateMutex())?: *mutex;

// Destroy a mutex created with [[create_mutex]].
//
// This function must be called on any mutex that is no longer needed. Failure
// to destroy a mutex will result in a system memory or resource leak. While
// it is safe to destroy a mutex that is _unlocked_, it is not safe to attempt
// to destroy a locked mutex, and may result in undefined behavior depending
// on the platform.
export fn destroy_mutex(mutex: *mutex) void = {
	return SDL_DestroyMutex(mutex: *SDL_mutex);
};

// Lock the mutex.
//
// This will block until the mutex is available, which is to say it is in the
// unlocked state and the OS has chosen the caller as the next thread to lock
// it. Of all threads waiting to lock the mutex, only one may do so at a time.
//
// It is legal for the owning thread to lock an already-locked mutex. It must
// unlock it the same number of times before it is actually made available for
// other threads in the system (this is known as a "recursive mutex").
export fn lock_mutex(mutex: *mutex) (void | error) = {
	return wrapvoid(SDL_LockMutex(mutex: *SDL_mutex));
};

// Synchronization functions which can time out return this if they time out.
export type mutex_timedout = void;

// Try to lock a mutex without blocking.
//
// This works just like [[lock_mutex]], but if the mutex is not available,
// this function returns [[mutex_timedout]] immediately.
//
// This technique is useful if you need exclusive access to a resource but
// don't want to wait for it, and will return to it to try again later.
export fn try_lock_mutex(mutex: *mutex) (void | mutex_timedout | error) = {
	if (wrapint(SDL_TryLockMutex(mutex: *SDL_mutex))? == SDL_MUTEX_TIMEOUT)
		return mutex_timedout;
};

// Unlock the mutex.
//
// It is legal for the owning thread to lock an already-locked mutex. It must
// unlock it the same number of times before it is actually made available for
// other threads in the system (this is known as a "recursive mutex").
//
// It is an error to unlock a mutex that has not been locked by the current
// thread, and doing so results in undefined behavior.
//
// It is also an error to unlock a mutex that isn't locked at all.
export fn unlock_mutex(mutex: *mutex) (void | error) = {
	return wrapvoid(SDL_UnlockMutex(mutex: *SDL_mutex));
};

// The SDL semaphore structure.
export type sem = opaque;

// Create a semaphore.
//
// This function creates a new semaphore and initializes it with the given
// initial value. Each wait operation on the semaphore will atomically
// decrement the semaphore value and potentially block if the semaphore value
// is 0. Each post operation will atomically increment the semaphore value and
// wake waiting threads and allow them to retry the wait operation.
export fn create_semaphore(initial_value: u32) (*sem | error) = {
	return wrapptr(SDL_CreateSemaphore(initial_value))?: *sem;
};

// Destroy a semaphore.
//
// It is not safe to destroy a semaphore if there are threads currently
// waiting on it.
export fn destroy_semaphore(sem: *sem) void = {
	return SDL_DestroySemaphore(sem: *SDL_sem);
};

// This is the timeout value which corresponds to never time out.
export def MUTEX_MAXWAIT = SDL_MUTEX_MAXWAIT;

// Wait until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until either the semaphore pointed
// to by sem has a positive value or the call is interrupted by a signal or
// error. If the call is successful it will atomically decrement the semaphore
// value.
//
// This function is the equivalent of calling [[sem_wait_timeout]] with a time
// length of [[MUTEX_MAXWAIT]].
export fn sem_wait(sem: *sem) (void | error) = {
	return wrapvoid(SDL_SemWait(sem: *SDL_sem));
};

// See if a semaphore has a positive value and decrement it if it does.
//
// This function checks to see if the semaphore pointed to by `sem` has a
// positive value and atomically decrements the semaphore value if it does. If
// the semaphore doesn't have a positive value, the function immediately
// returns [[mutex_timedout]].
export fn sem_try_wait(sem: *sem) (void | mutex_timedout | error) = {
	if (wrapint(SDL_SemTryWait(sem: *SDL_sem))? == SDL_MUTEX_TIMEOUT)
		return mutex_timedout;
};

// Wait until a semaphore has a positive value and then decrements it.
//
// This function suspends the calling thread until either the semaphore pointed
// to by sem has a positive value, the call is interrupted by a signal or error,
// or the specified time (in ms) has elapsed. If the call is successful it will
// atomically decrement the semaphore value.
export fn sem_wait_timeout(
	sem: *sem,
	timeout: u32,
) (void | mutex_timedout | error) = {
	if (wrapint(SDL_SemWaitTimeout(sem: *SDL_sem, timeout))?
			== SDL_MUTEX_TIMEOUT)
		return mutex_timedout;
};

// Atomically increment a semaphore's value and wake waiting threads.
export fn sem_post(sem: *sem) (void | error) = {
	return wrapvoid(SDL_SemPost(sem: *SDL_sem));
};

// Get the current value of a semaphore.
export fn sem_value(sem: *sem) u32 = SDL_SemValue(sem: *SDL_sem);

// The SDL condition variable structure.
export type cond = opaque;

// Create a condition variable.
export fn create_cond() (*cond | error) = wrapptr(SDL_CreateCond())?: *cond;

// Destroy a condition variable.
export fn destroy_cond(cond: *cond) void = SDL_DestroyCond(cond: *SDL_cond);

// Restart one of the threads that are waiting on the condition variable.
export fn cond_signal(cond: *cond) (void | error) =
	wrapvoid(SDL_CondSignal(cond: *SDL_cond));

// Restart all threads that are waiting on the condition variable.
export fn cond_broadcast(cond: *cond) (void | error) =
	wrapvoid(SDL_CondBroadcast(cond: *SDL_cond));

// Wait until a condition variable is signaled.
//
// This function unlocks the specified mutex and waits for another thread to
// call [[cond_signal]] or [[cond_broadcast]] on the condition variable
// cond. Once the condition variable is signaled, the mutex is re-locked and
// the function returns.
//
// The mutex must be locked before calling this function.
//
// This function is the equivalent of calling [[cond_wait_timeout]] with a
// time length of [[MUTEX_MAXWAIT]].
export fn cond_wait(cond: *cond, mutex: *mutex) (void | error) = {
	return wrapvoid(SDL_CondWait(cond: *SDL_cond, mutex: *SDL_mutex));
};

// Wait until a condition variable is signaled or a certain time has passed.
//
// This function unlocks the specified mutex and waits for another thread to
// call [[cond_signal]] or [[cond_broadcast]] on the condition variable
// cond, or for the specified time (in ms) to elapse. Once the condition
// variable is signaled or the time elapsed, the mutex is re-locked and the
// function returns.
//
// The mutex must be locked before calling this function.
export fn cond_wait_timeout(
	cond: *cond,
	mutex: *mutex,
	ms: u32,
) (void | mutex_timedout | error) = {
	if (wrapint(SDL_CondWaitTimeout(cond: *SDL_cond, mutex: *SDL_mutex,
			ms))? == SDL_MUTEX_TIMEOUT)
		return mutex_timedout;
};
