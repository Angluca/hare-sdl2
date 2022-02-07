use sdl2;

// Flags for [[init]].
export type MIX_InitFlags = enum {
	FLAC = 0x00000001,
	MOD = 0x00000002,
	MP3 = 0x00000008,
	OGG = 0x00000010,
	MID = 0x00000020,
	OPUS = 0x00000040
};

// The default mixer has 8 simultaneous mixing channels
export def MIX_CHANNELS: int = 8;

// Good default frequency for a PC soundcard
export def MIX_DEFAULT_FREQUENCY: int = 22050;

// Good default channels for a PC soundcard
export def MIX_DEFAULT_CHANNELS: int = 2;

// XXX: This should choose MSB on a big-endian system:

// Good default format for a PC soundcard
export def MIX_DEFAULT_FORMAT: sdl2::SDL_AudioFormat = sdl2::AUDIO_S16LSB;

@symbol("Mix_Init") fn _Mix_Init(flags: int) int;

// Loads dynamic libraries and prepares them for use.  Flags should be
// one or more flags from [[MIX_InitFlags]] OR'd together.
export fn Mix_Init(flags: MIX_InitFlags) (void | sdl2::error) = {
	return sdl2::wrapvoid(_Mix_Init(flags));
};

// Unloads libraries loaded with [[Mix_Init]].
export @symbol("Mix_Quit") fn Mix_Quit() void;

@symbol("Mix_OpenAudio") fn _Mix_OpenAudio(frequency: int,
	format: u16, channels: int, chunksize: int) int;

// Open the mixer with a certain audio format
export fn Mix_OpenAudio(
	frequency: int,
	format: sdl2::SDL_AudioFormat,
	channels: int,
	chunksize: int,
) (void | sdl2::error) = {
	return sdl2::wrapvoid(_Mix_OpenAudio(frequency, format, channels, chunksize));
};

// Close the mixer, halting all playing audio
export @symbol("Mix_CloseAudio") fn Mix_CloseAudio() void;
