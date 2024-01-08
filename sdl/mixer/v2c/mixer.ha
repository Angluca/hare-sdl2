use sdl::v2c::*;
use types::c;

// TODO a few functions didn't make it in, check nullable

export type MIX_InitFlags = enum {
	MIX_INIT_FLAC   = 0x00000001,
	MIX_INIT_MOD    = 0x00000002,
	MIX_INIT_MP3    = 0x00000008,
	MIX_INIT_OGG    = 0x00000010,
	MIX_INIT_MID    = 0x00000020,
	MIX_INIT_OPUS   = 0x00000040,
	MIX_INIT_WAVPACK= 0x00000080
};

export def MIX_CHANNELS = 8;

export def MIX_DEFAULT_FREQUENCY = 44100;
export def MIX_DEFAULT_FORMAT = 44100;
export def MIX_DEFAULT_CHANNELS = 2;

export type Mix_Chunk = struct {
	allocated: int,
	abuf: *u8,
	alen: u32,
	volume: u8,
};

export type Mix_Fading = enum {
	MIX_NO_FADING,
	MIX_FADING_OUT,
	MIX_FADING_IN
};

export type Mix_MusicType = enum {
	MUS_NONE,
	MUS_CMD,
	MUS_WAV,
	MUS_MOD,
	MUS_MID,
	MUS_OGG,
	MUS_MP3,
	MUS_MP3_MAD_UNUSED,
	MUS_FLAC,
	MUS_MODPLUG_UNUSED,
	MUS_OPUS,
	MUS_WAVPACK,
	MUS_GME
};

export type Mix_Music = opaque;

export type Mix_EffectFunc_t = *fn(chan: int, stream: *opaque, len_: int, udata: nullable *opaque) void;
export type Mix_EffectDone_t = *fn(chan: int, udata: nullable *opaque) void;

export @symbol("Mix_Linked_Version") fn Mix_Linked_Version() *SDL_version;
export @symbol("Mix_Init") fn Mix_Init(flags: MIX_InitFlags) int;
export @symbol("Mix_Quit") fn Mix_Quit() void;
export @symbol("Mix_OpenAudio") fn Mix_OpenAudio(frequency: int, format: u16, channels: int, chunksize: int) int;
export @symbol("Mix_OpenAudioDevice") fn Mix_OpenAudioDevice(frequency: int, format: u16, channels: int, chunksize: int, device: nullable *c::char, allowed_changes: int) int;
export @symbol("Mix_PauseAudio") fn Mix_PauseAudio(pause_on: int) void;
export @symbol("Mix_QuerySpec") fn Mix_QuerySpec(frequency: *int, format: *u16, channels: *int) int;
export @symbol("Mix_AllocateChannels") fn Mix_AllocateChannels(numchans: int) int;
export @symbol("Mix_LoadWAV_RW") fn Mix_LoadWAV_RW(src: *SDL_RWops, freesrc: int) nullable *Mix_Chunk;
export @symbol("Mix_LoadWAV") fn Mix_LoadWAV(file: *c::char) nullable *Mix_Chunk;
export @symbol("Mix_LoadMUS") fn Mix_LoadMUS(file: *c::char) nullable *Mix_Music;
export @symbol("Mix_LoadMUS_RW") fn Mix_LoadMUS_RW(src: *SDL_RWops, freesrc: int) nullable *Mix_Music;
export @symbol("Mix_LoadMUSType_RW") fn Mix_LoadMUSType_RW(src: *SDL_RWops, type_: Mix_MusicType, freesrc: int) nullable *Mix_Music;
export @symbol("Mix_QuickLoad_WAV") fn Mix_QuickLoad_WAV(mem: *u8) nullable *Mix_Chunk;
export @symbol("Mix_QuickLoad_RAW") fn Mix_QuickLoad_RAW(mem: *u8, len_: u32) nullable *Mix_Chunk;
export @symbol("Mix_FreeChunk") fn Mix_FreeChunk(chunk: *Mix_Chunk) void;
export @symbol("Mix_FreeMusic") fn Mix_FreeMusic(music: *Mix_Music) void;
export @symbol("Mix_GetNumChunkDecoders") fn Mix_GetNumChunkDecoders() int;
export @symbol("Mix_GetChunkDecoder") fn Mix_GetChunkDecoder(index: int) *c::char;
export @symbol("Mix_HasChunkDecoder") fn Mix_HasChunkDecoder(name: *c::char) bool;
export @symbol("Mix_GetNumMusicDecoders") fn Mix_GetNumMusicDecoders() int;
export @symbol("Mix_GetMusicDecoder") fn Mix_GetMusicDecoder(index: int) *c::char;
export @symbol("Mix_HasMusicDecoder") fn Mix_HasMusicDecoder(name: *c::char) bool;
export @symbol("Mix_GetMusicType") fn Mix_GetMusicType(music: *Mix_Music) Mix_MusicType;
export @symbol("Mix_GetMusicTitle") fn Mix_GetMusicTitle(music: *Mix_Music) *c::char;
export @symbol("Mix_GetMusicTitleTag") fn Mix_GetMusicTitleTag(music: *Mix_Music) *c::char;
export @symbol("Mix_GetMusicArtistTag") fn Mix_GetMusicArtistTag(music: *Mix_Music) *c::char;
export @symbol("Mix_GetMusicAlbumTag") fn Mix_GetMusicAlbumTag(music: *Mix_Music) *c::char;
export @symbol("Mix_GetMusicCopyrightTag") fn Mix_GetMusicCopyrightTag(music: *Mix_Music) *c::char;
export @symbol("Mix_GetMusicHookData") fn Mix_GetMusicHookData() *opaque;
export @symbol("Mix_RegisterEffect") fn Mix_RegisterEffect(chan: int, f: Mix_EffectFunc_t, d: Mix_EffectDone_t, arg: *opaque) int;
export @symbol("Mix_UnregisterEffect") fn Mix_UnregisterEffect(channel: int, f: Mix_EffectFunc_t) int;
export @symbol("Mix_UnregisterAllEffects") fn Mix_UnregisterAllEffects(channel: int) int;
export @symbol("Mix_SetPanning") fn Mix_SetPanning(channel: int, left: u8, right: u8) int;
export @symbol("Mix_SetPosition") fn Mix_SetPosition(channel: int, angle: i16, distance: u8) int;
export @symbol("Mix_SetDistance") fn Mix_SetDistance(channel: int, distance: u8) int;
export @symbol("Mix_SetReverseStereo") fn Mix_SetReverseStereo(channel: int, flip: int) int;
export @symbol("Mix_ReserveChannels") fn Mix_ReserveChannels(num: int) int;
export @symbol("Mix_GroupChannel") fn Mix_GroupChannel(which: int, tag: int) int;
export @symbol("Mix_GroupChannels") fn Mix_GroupChannels(from: int, to: int, tag: int) int;
export @symbol("Mix_GroupAvailable") fn Mix_GroupAvailable(tag: int) int;
export @symbol("Mix_GroupCount") fn Mix_GroupCount(tag: int) int;
export @symbol("Mix_GroupOldest") fn Mix_GroupOldest(tag: int) int;
export @symbol("Mix_GroupNewer") fn Mix_GroupNewer(tag: int) int;
export @symbol("Mix_PlayChannel") fn Mix_PlayChannel(channel: int, chunk: *Mix_Chunk, loops: int) int;
export @symbol("Mix_PlayChannelTimed") fn Mix_PlayChannelTimed(channel: int, chunk: *Mix_Chunk, loops: int, ticks: int) int;
export @symbol("Mix_PlayMusic") fn Mix_PlayMusic(music: *Mix_Music, loops: int) int;
export @symbol("Mix_FadeInMusic") fn Mix_FadeInMusic(music: *Mix_Music, loops: int, ms: int) int;
export @symbol("Mix_FadeInMusicPos") fn Mix_FadeInMusicPos(music: *Mix_Music, loops: int, ms: int, position: f64) int;
export @symbol("Mix_FadeInChannel") fn Mix_FadeInChannel(channel: int, chunk: *Mix_Chunk, loops: int, ms: int) int;
export @symbol("Mix_FadeInChannelTimed") fn Mix_FadeInChannelTimed(channel: int, chunk: *Mix_Chunk, loops: int, ms: int, ticks: int) int;
export @symbol("Mix_Volume") fn Mix_Volume(channel: int, volume: int) int;
export @symbol("Mix_VolumeChunk") fn Mix_VolumeChunk(chunk: *Mix_Chunk, volume: int) int;
export @symbol("Mix_VolumeMusic") fn Mix_VolumeMusic(volume: int) int;
export @symbol("Mix_GetMusicVolume") fn Mix_GetMusicVolume(music: *Mix_Music) int;
export @symbol("Mix_MasterVolume") fn Mix_MasterVolume(volume: int) int;
export @symbol("Mix_HaltChannel") fn Mix_HaltChannel(channel: int) int;
export @symbol("Mix_HaltGroup") fn Mix_HaltGroup(tag: int) int;
export @symbol("Mix_HaltMusic") fn Mix_HaltMusic() int;
export @symbol("Mix_ExpireChannel") fn Mix_ExpireChannel(channel: int, ticks: int) int;
export @symbol("Mix_FadeOutChannel") fn Mix_FadeOutChannel(which: int, ms: int) int;
export @symbol("Mix_FadeOutGroup") fn Mix_FadeOutGroup(tag: int, ms: int) int;
export @symbol("Mix_FadeOutMusic") fn Mix_FadeOutMusic(ms: int) int;
export @symbol("Mix_FadingMusic") fn Mix_FadingMusic() Mix_Fading;
export @symbol("Mix_FadingChannel") fn Mix_FadingChannel(which: int) Mix_Fading;
export @symbol("Mix_Pause") fn Mix_Pause(channel: int) void;
export @symbol("Mix_Resume") fn Mix_Resume(channel: int) void;
export @symbol("Mix_Paused") fn Mix_Paused(channel: int) int;
export @symbol("Mix_PauseMusic") fn Mix_PauseMusic() void;
export @symbol("Mix_ResumeMusic") fn Mix_ResumeMusic() void;
export @symbol("Mix_RewindMusic") fn Mix_RewindMusic() void;
export @symbol("Mix_PausedMusic") fn Mix_PausedMusic() int;
export @symbol("Mix_ModMusicJumpToOrder") fn Mix_ModMusicJumpToOrder(order: int) int;
export @symbol("Mix_StartTrack") fn Mix_StartTrack(music: *Mix_Music, track: int) int;
export @symbol("Mix_GetNumTracks") fn Mix_GetNumTracks(music: *Mix_Music) int;
export @symbol("Mix_SetMusicPosition") fn Mix_SetMusicPosition(position: f64) int;
export @symbol("Mix_GetMusicPosition") fn Mix_GetMusicPosition(music: *Mix_Music) f64;
export @symbol("Mix_MusicDuration") fn Mix_MusicDuration(music: *Mix_Music) f64;
export @symbol("Mix_GetMusicLoopStartTime") fn Mix_GetMusicLoopStartTime(music: *Mix_Music) f64;
export @symbol("Mix_GetMusicLoopEndTime") fn Mix_GetMusicLoopEndTime(music: *Mix_Music) f64;
export @symbol("Mix_GetMusicLoopLengthTime") fn Mix_GetMusicLoopLengthTime(music: *Mix_Music) f64;
export @symbol("Mix_Playing") fn Mix_Playing(channel: int) int;
export @symbol("Mix_PlayingMusic") fn Mix_PlayingMusic() int;
export @symbol("Mix_SetMusicCMD") fn Mix_SetMusicCMD(command: *c::char) int;
export @symbol("Mix_SetSynchroValue") fn Mix_SetSynchroValue(value: int) int;
export @symbol("Mix_GetSynchroValue") fn Mix_GetSynchroValue() int;
export @symbol("Mix_SetSoundFonts") fn Mix_SetSoundFonts(paths: *c::char) int;
export @symbol("Mix_GetSoundFonts") fn Mix_GetSoundFonts() *c::char;
export @symbol("Mix_SetTimidityCfg") fn Mix_SetTimidityCfg(path: *c::char) int;
export @symbol("Mix_GetTimidityCfg") fn Mix_GetTimidityCfg() *c::char;
export @symbol("Mix_GetChunk") fn Mix_GetChunk(channel: int) *Mix_Chunk;
export @symbol("Mix_CloseAudio") fn Mix_CloseAudio() void;
