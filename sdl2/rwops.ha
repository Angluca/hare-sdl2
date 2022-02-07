use io;
use strings;

// RWops types
export type rwops_type = enum u32 {
	UNKNOWN = 0,
	WINFILE = 1,
	STDFILE = 2,
	JNIFILE = 3,
	MEMORY = 4,
	MEMORY_RO = 5,
};

// The read/write operation structure -- very basic.
export type SDL_RWops = struct {
	sz: *fn(ctx: *SDL_RWops) i64,
	seek: *fn(ctx: *SDL_RWops, offs: i64, whence: int) i64,
	read: *fn(ctx: *SDL_RWops, ptr: *void, sz: size, maxnum: size) size,
	write: *fn(ctx: *SDL_RWops, ptr: *void, sz: size, num: size) size,
	close: *fn(ctx: *SDL_RWops) void,

	type_: rwops_type,
	// XXX: This union is platform-specific
	hidden: union {
		stdio: struct {
			autoclose: bool,
			fp: nullable *void, // FILE *
		},
		mem: struct {
			base: nullable *u8,
			here: nullable *u8,
			stop: nullable *u8,
		},
		unknown: struct {
			data1: nullable *void,
			data2: nullable *void,
		},
	},
};

@symbol("SDL_RWFromFile") fn _rw_from_file(
	file: const *char,
	mode: const *char,
) *SDL_RWops;

// Returns the size of an [[SDL_RWops]], or 0 if unknown or error.
//
// See [[stream_from_rw]] for a more idiomatic Hare interface to SDL_RWops.
export @symbol("SDL_RWsize") fn SDL_RWsize(ctx: *SDL_RWops) i64;

// Closes an [[SDL_RWops]], returning 1 on success or 0 on error.
//
// See [[stream_from_rw]] for a more idiomatic Hare interface to SDL_RWops.
export @symbol("SDL_RWclose") fn SDL_RWclose(ctx: *SDL_RWops) int;

// TODO: Other RWops wrappers

// Creates an [[SDL_RWops]] from an [[io::handle]]. Closing the rwops does not close
// the underlying stream.
export fn rw_from_handle(in: io::handle) *SDL_RWops = {
	// TODO: Add stream_from_rw
	let rw = alloc(SDL_RWops {
		sz = &stream_size,
		seek = &stream_seek,
		read = &stream_read,
		write = &stream_write,
		close = &stream_close,
		type_ = rwops_type::UNKNOWN,
		...
	});
	// Assert that we can cram an io::handle into the SDL_RWops struct
	static assert(size(io::handle) <= size(nullable *u8) * 2);
	let ptr = &rw.hidden.unknown.data1: *io::handle;
	*ptr = in;
	return rw;
};

fn stream_size(ctx: *SDL_RWops) i64 = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	const old = match (io::tell(handle)) {
	case let o: io::off =>
		yield o;
	case io::error =>
		return -1;
	};
	io::seek(handle, 0, io::whence::END)!;
	const sz = io::tell(handle)!;
	io::seek(handle, old, io::whence::SET)!;
	return sz;
};

fn stream_seek(ctx: *SDL_RWops, offs: i64, whence: int) i64 = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	// Note: whence values in stdio.h match io::whence
	match (io::seek(handle, offs: io::off, whence: io::whence)) {
	case let o: io::off =>
		return o;
	case io::error =>
		return -1;
	};
};

fn stream_read(ctx: *SDL_RWops, ptr: *void, sz: size, maxnum: size) size = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	let buf = ptr: *[*]u8;
	match (io::readitems(handle, buf[..sz * maxnum], sz)) {
	case let n: size =>
		return n;
	case io::error =>
		return 0;
	};
};

fn stream_write(ctx: *SDL_RWops, ptr: *void, sz: size, num: size) size = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	let buf = ptr: *[*]u8;
	match (io::writeitems(handle, buf[..sz * num], sz)) {
	case let n: size =>
		return n;
	case io::error =>
		return 0;
	};
};

fn stream_close(ctx: *SDL_RWops) void = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	free(ctx);
};
