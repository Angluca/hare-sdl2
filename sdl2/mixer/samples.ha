use fs;
use io;
use os;
use sdl2;

// The internal format for an audio chunk
export type chunk = struct {
	allocated: int,
	abuf: *u8,
	alen: u32,
	volume: u8,
};

@symbol("Mix_LoadWAV_RW") fn _loadwav_rw(src: *sdl2::rwops, freesrc: int) nullable *chunk;

// Loads a sample from an [[io::handle]]. The stream will not be closed for you.
export fn load(src: io::handle) (*chunk | sdl2::error) = {
	const rw = sdl2::rw_from_handle(src);
	defer sdl2::rwclose(rw);
	return sdl2::wrapptr(_loadwav_rw(rw, 0))?: *chunk;
};

// Loads a sample from a file path.
export fn load_file(src: str) (*chunk | fs::error | sdl2::error) = {
	const file = os::open(src)?;
	defer io::close(file);
	return load(file);
};

// Free the memory used in chunk, and free chunk itself as well. Do not use
// chunk after this without loading a new sample to it. Note: It's a bad idea to
// free a chunk that is still being played... 
export @symbol("Mix_FreeChunk") fn free_chunk(chunk: *chunk) void;

// Maximum volume for a chunk.
export def MAX_VOLUME: int = 128; // XXX: SDL_mixer derives this from SDL_MIX_MAXVOLUME

// Sets the chunk volume as specified, returning the previous value.
export @symbol("Mix_VolumeChunk") fn volume_chunk(chunk: *chunk, volume: int) int;
