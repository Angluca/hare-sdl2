use fs;
use io;
use os;
use sdl2;

// The internal format for an audio Mix_Chunk
export type Mix_Chunk = struct {
	allocated: int,
	abuf: *u8,
	alen: u32,
	volume: u8,
};

@symbol("Mix_LoadWAV_RW") fn _Mix_LoadWAV_RW(src: *sdl2::SDL_RWops, freesrc: int) nullable *Mix_Chunk;

// Loads a sample from an [[io::handle]]. The stream will not be closed for you.
export fn Mix_LoadWAV_RW(src: io::handle) (*Mix_Chunk | sdl2::error) = {
	const rw = sdl2::rw_from_handle(src);
	defer sdl2::SDL_RWclose(rw);
	return sdl2::wrapptr(_Mix_LoadWAV_RW(rw, 0))?: *Mix_Chunk;
};

// Loads a sample from a file path.
export fn load_file(src: str) (*Mix_Chunk | fs::error | sdl2::error) = {
	const file = os::open(src)?;
	defer io::close(file);
	return Mix_LoadWAV_RW(file);
};

// Free the memory used in Mix_Chunk, and free Mix_Chunk itself as well. Do not use
// Mix_Chunk after this without loading a new sample to it. Note: It's a bad idea to
// free a Mix_Chunk that is still being played...
export @symbol("Mix_FreeChunk") fn Mix_FreeChunk(Mix_Chunk: *Mix_Chunk) void;

// Maximum volume for a Mix_Chunk.
export def MIX_MAX_VOLUME: int = 128; // XXX: SDL_mixer derives this from SDL_MIX_MAXVOLUME

// Sets the Mix_Chunk volume as specified, returning the previous value.
export @symbol("Mix_VolumeChunk") fn Mix_VolumeChunk(Mix_Chunk: *Mix_Chunk, volume: int) int;
