use types::c;

export type SDL_AudioFormat = u16;

export def AUDIO_U8: SDL_AudioFormat = 0x0008;
export def AUDIO_S8: SDL_AudioFormat = 0x8008;
export def AUDIO_U16LSB: SDL_AudioFormat = 0x0010;
export def AUDIO_S16LSB: SDL_AudioFormat = 0x8010;
export def AUDIO_U16MSB: SDL_AudioFormat = 0x1010;
export def AUDIO_S16MSB: SDL_AudioFormat = 0x9010;
export def AUDIO_U16: SDL_AudioFormat = AUDIO_U16LSB;
export def AUDIO_S16: SDL_AudioFormat = AUDIO_S16LSB;

export def AUDIO_S32LSB: SDL_AudioFormat = 0x8020;
export def AUDIO_S32MSB: SDL_AudioFormat = 0x9020;
export def AUDIO_S32: SDL_AudioFormat = AUDIO_S32LSB;

export def AUDIO_F32LSB: SDL_AudioFormat = 0x8120;
export def AUDIO_F32MSB: SDL_AudioFormat = 0x9120;
export def AUDIO_F32: SDL_AudioFormat = AUDIO_F32LSB;

export def SDL_AUDIO_ALLOW_FREQUENCY_CHANGE = 0x00000001;
export def SDL_AUDIO_ALLOW_FORMAT_CHANGE = 0x00000002;
export def SDL_AUDIO_ALLOW_CHANNELS_CHANGE = 0x00000004;
export def SDL_AUDIO_ALLOW_SAMPLES_CHANGE = 0x00000008;
export def SDL_AUDIO_ALLOW_ANY_CHANGE = SDL_AUDIO_ALLOW_FREQUENCY_CHANGE | SDL_AUDIO_ALLOW_FORMAT_CHANGE | SDL_AUDIO_ALLOW_CHANNELS_CHANGE | SDL_AUDIO_ALLOW_SAMPLES_CHANGE;

export type SDL_AudioCallback = fn(userdata: nullable *opaque, stream: *u8, len_: int) void;

export type SDL_AudioSpec = struct {
	freq: int,
	format: SDL_AudioFormat,
	channels: u8,
	silence: u8,
	samples: u16,
	padding: u16,
	size_: u32,
	callback: nullable *SDL_AudioCallback,
	userdata: nullable *opaque,
};

export def SDL_AUDIOCVT_MAX_FILTERS = 9;

export type SDL_AudioCVT = struct @packed {
	needed: int,
	src_format: SDL_AudioFormat,
	dst_format: SDL_AudioFormat,
	rate_incr: f64,
	buf: *u8,
	len_: int,
	len_cvt: int,
	len_mult: int,
	len_ratio: f64,
	filters: [SDL_AUDIOCVT_MAX_FILTERS + 1]SDL_AudioFilter,
	filter_index: int,
};

export type SDL_AudioFilter = *fn(cvt: *SDL_AudioCVT, format: SDL_AudioFormat) void;

export @symbol("SDL_GetNumAudioDrivers") fn SDL_GetNumAudioDrivers() int;
export @symbol("SDL_GetAudioDriver") fn SDL_GetAudioDriver(index: int) nullable *c::char;
export @symbol("SDL_AudioInit") fn SDL_AudioInit(driver_name: *c::char) int;
export @symbol("SDL_AudioQuit") fn SDL_AudioQuit() void;
export @symbol("SDL_GetCurrentAudioDriver") fn SDL_GetCurrentAudioDriver() nullable *c::char;
export @symbol("SDL_OpenAudio") fn SDL_OpenAudio(desired: *SDL_AudioSpec, obtained: nullable *SDL_AudioSpec) int;

export type SDL_AudioDeviceID = u32;

export @symbol("SDL_GetNumAudioDevices") fn SDL_GetNumAudioDevices(iscapture: int) int;
export @symbol("SDL_GetAudioDeviceName") fn SDL_GetAudioDeviceName(index: int, iscapture: int) nullable *c::char;
export @symbol("SDL_GetAudioDeviceSpec") fn SDL_GetAudioDeviceSpec(index: int, iscapture: int, spec: *SDL_AudioSpec) int;
export @symbol("SDL_GetDefaultAudioInfo") fn SDL_GetDefaultAudioInfo(name: nullable **c::char, spec: *SDL_AudioSpec, iscapture: int) int;
export @symbol("SDL_OpenAudioDevice") fn SDL_OpenAudioDevice(device: nullable *c::char, iscapture: int, desired: *SDL_AudioSpec, obtained: nullable *SDL_AudioSpec, allowed_changes: int) SDL_AudioDeviceID;

export type SDL_AudioStatus = enum {
	SDL_AUDIO_STOPPED = 0,
	SDL_AUDIO_PLAYING,
	SDL_AUDIO_PAUSED,
};

export @symbol("SDL_GetAudioStatus") fn SDL_GetAudioStatus() SDL_AudioStatus;
export @symbol("SDL_GetAudioDeviceStatus") fn SDL_GetAudioDeviceStatus(dev: SDL_AudioDeviceID) SDL_AudioStatus;
export @symbol("SDL_PauseAudio") fn SDL_PauseAudio(pause_on: int) void;
export @symbol("SDL_PauseAudioDevice") fn SDL_PauseAudioDevice(dev: SDL_AudioDeviceID, pause_on: int) void;
export @symbol("SDL_LoadWAV_RW") fn SDL_LoadWAV_RW(src: *SDL_RWops, freesrc: int, spec: *SDL_AudioSpec, audio_buf: **u8, audio_len: *u32) nullable *SDL_AudioSpec;
export @symbol("SDL_FreeWAV") fn SDL_FreeWAV(audio_buf: nullable *u8) void;
export @symbol("SDL_BuildAudioCVT") fn SDL_BuildAudioCVT(cvt: *SDL_AudioCVT, src_format: SDL_AudioFormat, src_channels: u8, src_rate: int, dst_format: SDL_AudioFormat, dst_channels: u8, dst_rate: int) int;
export @symbol("SDL_ConvertAudio") fn SDL_ConvertAudio(cvt: *SDL_AudioCVT) int;

export type SDL_AudioStream = opaque;

export @symbol("SDL_NewAudioStream") fn SDL_NewAudioStream(src_format: SDL_AudioFormat, src_channels: u8, src_rate: int, dst_format: SDL_AudioFormat, dst_channels: u8, dst_rate: int) nullable *SDL_AudioStream;
export @symbol("SDL_AudioStreamPut") fn SDL_AudioStreamPut(stream: *SDL_AudioStream, buf: *opaque, len_: int) int;
export @symbol("SDL_AudioStreamGet") fn SDL_AudioStreamGet(stream: *SDL_AudioStream, buf: *opaque, len_: int) int;
export @symbol("SDL_AudioStreamAvailable") fn SDL_AudioStreamAvailable(stream: *SDL_AudioStream) int;
export @symbol("SDL_AudioStreamFlush") fn SDL_AudioStreamFlush(stream: *SDL_AudioStream) int;
export @symbol("SDL_AudioStreamClear") fn SDL_AudioStreamClear(stream: *SDL_AudioStream) void;
export @symbol("SDL_FreeAudioStream") fn SDL_FreeAudioStream(stream: *SDL_AudioStream) void;

export def SDL_MIX_MAXVOLUME = 128;

export @symbol("SDL_MixAudio") fn SDL_MixAudio(dst: *u8, src: *u8, len_: u32, volume: int) void;
export @symbol("SDL_MixAudioFormat") fn SDL_MixAudioFormat(dst: *u8, src: *u8, format: SDL_AudioFormat, len_: u32, volume: int) void;
export @symbol("SDL_QueueAudio") fn SDL_QueueAudio(dev: SDL_AudioDeviceID, data: *opaque, len_: u32) int;
export @symbol("SDL_DequeueAudio") fn SDL_DequeueAudio(dev: SDL_AudioDeviceID, data: *opaque, len_: u32) u32;
export @symbol("SDL_GetQueuedAudioSize") fn SDL_GetQueuedAudioSize(dev: SDL_AudioDeviceID) u32;
export @symbol("SDL_ClearQueuedAudio") fn SDL_ClearQueuedAudio(dev: SDL_AudioDeviceID) void;
export @symbol("SDL_LockAudio") fn SDL_LockAudio() void;
export @symbol("SDL_LockAudioDevice") fn SDL_LockAudioDevice(dev: SDL_AudioDeviceID) void;
export @symbol("SDL_UnlockAudio") fn SDL_UnlockAudio() void;
export @symbol("SDL_UnlockAudioDevice") fn SDL_UnlockAudioDevice(dev: SDL_AudioDeviceID) void;
export @symbol("SDL_CloseAudio") fn SDL_CloseAudio() void;
export @symbol("SDL_CloseAudioDevice") fn SDL_CloseAudioDevice(dev: SDL_AudioDeviceID) void;
