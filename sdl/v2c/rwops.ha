use io;
use types::c;

export def SDL_RWOPS_UNKNOWN = 0u;
export def SDL_RWOPS_WINFILE = 1u;
export def SDL_RWOPS_STDFILE = 2u;
export def SDL_RWOPS_JNIFILE = 3u;
export def SDL_RWOPS_MEMORY = 4u;
export def SDL_RWOPS_MEMORY_RO = 5u;

export type SDL_RWops = struct {
	size_: *fn(context: *SDL_RWops) i64,
	seek: *fn(context: *SDL_RWops, offset_: i64, whence: int) i64,
	read: *fn(context: *SDL_RWops, ptr: *opaque, size_: size, maxnum: size) size,
	write: *fn(context: *SDL_RWops, ptr: *opaque, size_: size, num: size) size,
	close: *fn(context: *SDL_RWops) int,

	type_: u32,

	hidden: union {
		stdio: struct {
			autoclose: bool,
			fp: nullable *opaque, // FILE *
		},
		mem: struct {
			base: nullable *u8,
			here: nullable *u8,
			stop: nullable *u8,
		},
		unknown: struct {
			data1: nullable *opaque,
			data2: nullable *opaque,
		},
	},
};

export def RW_SEEK_SET = 0;
export def RW_SEEK_CUR = 1;
export def RW_SEEK_END = 2;

export @symbol("SDL_RWFromFile") fn SDL_RWFromFile(file: *c::char, mode: *c::char) nullable *SDL_RWops;
export @symbol("SDL_RWFromFP") fn SDL_RWFromFP(fp: *opaque, autoclose: bool) nullable *SDL_RWops;
export @symbol("SDL_RWFromMem") fn SDL_RWFromMem(mem: *opaque, size_: int) nullable *SDL_RWops;
export @symbol("SDL_RWFromConstMem") fn SDL_RWFromConstMem(mem: *opaque, size_: int) nullable *SDL_RWops;
export @symbol("SDL_AllocRW") fn SDL_AllocRW() nullable *SDL_RWops;
export @symbol("SDL_FreeRW") fn SDL_FreeRW(area: *SDL_RWops) void;
export @symbol("SDL_RWsize") fn SDL_RWsize(context: *SDL_RWops) i64;
export @symbol("SDL_RWseek") fn SDL_RWseek(context: *SDL_RWops, offset_: i64, whence: int) i64;
export @symbol("SDL_RWtell") fn SDL_RWtell(context: *SDL_RWops) i64;
export @symbol("SDL_RWread") fn SDL_RWread(context: *SDL_RWops, ptr: *opaque, size_: size, maxnum: size) size;
export @symbol("SDL_RWwrite") fn SDL_RWwrite(context: *SDL_RWops, ptr: *opaque, size_: size, num: size) size;
export @symbol("SDL_RWclose") fn SDL_RWclose(context: *SDL_RWops) int;
export @symbol("SDL_LoadFile_RW") fn SDL_LoadFile_RW(src: *SDL_RWops, datasize: nullable *size, freesrc: int) nullable *opaque;
export @symbol("SDL_LoadFile") fn SDL_LoadFile(file: *c::char, datasize: nullable *size) nullable *opaque;
export @symbol("SDL_ReadU8") fn SDL_ReadU8(src: *SDL_RWops) u8;
export @symbol("SDL_ReadLE16") fn SDL_ReadLE16(src: *SDL_RWops) u16;
export @symbol("SDL_ReadBE16") fn SDL_ReadBE16(src: *SDL_RWops) u16;
export @symbol("SDL_ReadLE32") fn SDL_ReadLE32(src: *SDL_RWops) u32;
export @symbol("SDL_ReadBE32") fn SDL_ReadBE32(src: *SDL_RWops) u32;
export @symbol("SDL_ReadLE64") fn SDL_ReadLE64(src: *SDL_RWops) u64;
export @symbol("SDL_ReadBE64") fn SDL_ReadBE64(src: *SDL_RWops) u64;
export @symbol("SDL_WriteU8") fn SDL_WriteU8(dst: *SDL_RWops, value: u8) size;
export @symbol("SDL_WriteLE16") fn SDL_WriteLE16(dst: *SDL_RWops, value: u16) size;
export @symbol("SDL_WriteBE16") fn SDL_WriteBE16(dst: *SDL_RWops, value: u16) size;
export @symbol("SDL_WriteLE32") fn SDL_WriteLE32(dst: *SDL_RWops, value: u32) size;
export @symbol("SDL_WriteBE32") fn SDL_WriteBE32(dst: *SDL_RWops, value: u32) size;
export @symbol("SDL_WriteLE64") fn SDL_WriteLE64(dst: *SDL_RWops, value: u64) size;
export @symbol("SDL_WriteBE64") fn SDL_WriteBE64(dst: *SDL_RWops, value: u64) size;

// Creates an [[SDL_RWops]] from an [[io::handle]]. Closing the rwops does not
// close the underlying stream.
//
// This is not an SDL function, but if you import sdl::v2c::*, we don't want to
// pollute the global namespace any more.
export fn SDL_rw_from_handle(in: io::handle) SDL_RWops = {
	let rw = SDL_RWops {
		size_ = &stream_size,
		seek = &stream_seek,
		read = &stream_read,
		write = &stream_write,
		close = &stream_close,
		type_ = SDL_RWOPS_UNKNOWN,
		...
	};
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

fn stream_read(ctx: *SDL_RWops, ptr: *opaque, sz: size, maxnum: size) size = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	let buf = ptr: *[*]u8;
	match (io::readall(handle, buf[..sz * maxnum])) {
	case let n: size =>
		return n / sz;
	case io::EOF =>
		return 0;
	case io::error =>
		return 0;
	};
};

fn stream_write(ctx: *SDL_RWops, ptr: *opaque, sz: size, num: size) size = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	let buf = ptr: *[*]const u8;
	match (io::writeall(handle, buf[..sz * num])) {
	case let n: size =>
		return n / sz;
	case io::error =>
		return 0;
	};
};

fn stream_close(ctx: *SDL_RWops) int = {
	const handle = *(&ctx.hidden.unknown.data1: *io::handle);
	free(ctx);
	match (io::close(handle)) {
	case void => return 0;
	case io::error => return -1;
	};
};
