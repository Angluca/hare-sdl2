use sdl::v2c::*;
use types::c;

// The SDL thread structure.
export type thread = opaque;

// The SDL thread ID.
export type thread_id = u32;

// Thread local storage ID, 0 is the invalid ID.
export type tlsid = u32;

export type thread_function = *fn(data: *opaque) int;

// The SDL thread priority.
//
// SDL will make system changes as necessary in order to apply the thread
// priority. Code which attempts to control thread state related to priority
// should be aware that calling [[set_thread_priority]] may alter such state.
// HINT_THREAD_PRIORITY_POLICY can be used to control aspects of this behavior.
//
// On many systems you require special privileges to set high or time critical
// priority.
export type thread_priority = enum {
	LOW,
	NORMAL,
	HIGH,
	TIME_CRITICAL,
};

// Create a new thread with a default stack size.
export fn create_thread(
	fn_: thread_function,
	name: str,
	data: nullable *opaque,
) (*thread | error) = {
	let n = c::fromstr(name);
	defer free(n);
	return wrapptr(SDL_CreateThread(fn_: SDL_ThreadFunction, n,
		data))?: *thread;
};

// Create a new thread with a specific stack size.
//
// SDL makes an attempt to report name to the system, so that debuggers can
// display it. Not all platforms support this.
//
// Thread naming is a little complicated: Most systems have very small limits
// for the string length (Haiku has 32 bytes, Linux currently has 16, Visual
// C++ 6.0 has _nine_!), and possibly other arbitrary rules. You'll have to
// see what happens with your system's debugger. These guidelines are helpful in
// choosing a name:
//
// https://stackoverflow.com/questions/149932/naming-conventions-for-threads
//
// If a system imposes requirements, SDL will try to munge the string for it
// (truncate, etc), but the original string contents will be available from
// [[get_thread_name]].
//
// The size (in bytes) of the new stack can be specified. Zero means "use the
// system default" which might be wildly different between platforms. x86
// Linux generally defaults to eight megabytes, an embedded device might be a
// few kilobytes instead. You generally need to specify a stack that is a
// multiple of the system's page size (in many cases, this is 4 kilobytes, but
// check your system documentation).
export fn create_thread_with_stack_size(
	fn_: thread_function,
	name: str,
	stacksize: size,
	data: nullable *opaque,
) (*thread | error) = {
	let n = c::fromstr(name);
	defer free(n);
	return wrapptr(SDL_CreateThreadWithStackSize(fn_: SDL_ThreadFunction,
		n, stacksize, data))?: *thread;
};

// Get the thread name as it was specified in [[create_thread]].
//
// This is internal memory, not to be freed by the caller, and remains valid
// until the specified thread is cleaned up by [[wait_thread]].
export fn get_thread_name(thread: *thread) (str | void) = {
	return match (SDL_GetThreadName(thread: *SDL_Thread)) {
	case null =>
		yield void;
	case let cs: *c::char =>
		yield c::tostr(cs)!;
	};
};

// Get the thread identifier for the specified thread.
//
// This thread identifier is as reported by the underlying operating system.
// If SDL is running on a platform that does not support threads the return
// value will always be zero.
//
// Returns the ID of the specified thread, or the ID of the current thread if
// thread is null.
export fn get_thread_id(thread: nullable *thread) thread_id =
	SDL_GetThreadID(thread: *SDL_Thread);

// Set the priority for the current thread.
//
// Note that some platforms will not let you alter the priority (or at least,
// promote the thread to a higher priority) at all, and some require you to be
// an administrator account. Be prepared for this to fail.
export fn set_thread_priority(priority: thread_priority) (void | error) =
	wrapvoid(SDL_SetThreadPriority(priority: SDL_ThreadPriority));

// Wait for a thread to finish.
//
// Threads that haven't been detached will remain (as a "zombie") until this
// function cleans them up. Not doing so is a resource leak.
//
// Once a thread has been cleaned up through this function, the [[thread]]
// that references it becomes invalid and should not be referenced again. As
// such, only one thread may call [[wait_thread]] on another.
//
// The return code for the thread function is placed in the area pointed to by
// status, if status is not null.
//
// You may not wait on a thread that has been used in a call to
// [[detach_thread]]. Use either that function or this one, but not both, or
// behavior is undefined.
//
// It is safe to pass a null thread to this function; it is a no-op.
//
// Note that the thread pointer is freed by this function and is not valid
// afterward.
export fn wait_thread(thread: nullable *thread, status: nullable *int) void =
	SDL_WaitThread(thread: nullable *SDL_Thread, status);

// Let a thread clean up on exit without intervention.
//
// A thread may be "detached" to signify that it should not remain until
// another thread has called [[wait_thread]] on it. Detaching a thread is
// useful for long-running threads that nothing needs to synchronize with or
// further manage. When a detached thread is done, it simply goes away.
//
// There is no way to recover the return code of a detached thread. If you
// need this, don't detach the thread and instead use [[wait_thread]].
//
// Once a thread is detached, you should usually assume the [[thread]] isn't
// safe to reference again, as it will become invalid immediately upon the
// detached thread's exit, instead of remaining until someone has called
// [[wait_thread]] to finally clean it up. As such, don't detach the same
// thread more than once.
//
// If a thread has already exited when passed to [[detach_thread]], it will
// stop waiting for a call to [[wait_thread]] and clean up immediately. It is
// not safe to detach a thread that might be used with [[wait_thread]].
//
// You may not call [[wait_thread]] on a thread that has been detached. Use
// either that function or this one, but not both, or behavior is undefined.
//
// It is safe to pass null to this function; it is a no-op.
export fn detach_thread(thread: nullable *thread) void =
	SDL_DetachThread(thread: nullable *SDL_Thread);

// TODO: We can consider adding TLS.
