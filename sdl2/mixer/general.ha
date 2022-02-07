use sdl2;

// Flags for [[init]].
export type init_flags = enum {
	FLAC = 0x00000001,
	MOD = 0x00000002,
	MP3 = 0x00000008,
	OGG = 0x00000010,
	MID = 0x00000020,
	OPUS = 0x00000040
};

// The default mixer has 8 simultaneous mixing channels
export def CHANNELS: int = 8;

// Good default frequency for a PC soundcard
export def DEFAULT_FREQUENCY: int = 22050;

// Good default channels for a PC soundcard
export def DEFAULT_CHANNELS: int = 2;

// XXX: This should choose MSB on a big-endian system:

// Good default format for a PC soundcard
export def DEFAULT_FORMAT: sdl2::audio_format = sdl2::AUDIO_S16LSB;

@symbol("Mix_Init") fn _init(flags: int) int;

// Loads dynamic libraries and prepares them for use.  Flags should be
// one or more flags from [[init_flags]] OR'd together.
export fn init(flags: init_flags) (void | sdl2::error) = {
	return sdl2::wrapvoid(_init(flags));
};

// Unloads libraries loaded with [[init]].
export @symbol("Mix_Quit") fn quit() void;

@symbol("Mix_OpenAudio") fn _openaudio(frequency: int,
	format: u16, channels: int, chunksize: int) int;

// Open the mixer with a certain audio format
export fn open_audio(
	frequency: int,
	format: sdl2::audio_format,
	channels: int,
	chunksize: int,
) (void | sdl2::error) = {
	return sdl2::wrapvoid(_openaudio(frequency, format, channels, chunksize));
};

// Close the mixer, halting all playing audio
export @symbol("Mix_CloseAudio") fn close_audio() void;
