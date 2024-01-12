use fs;
use io;
use os;
use sdl;
use sdl::v2c::*;
use strings;
use types;
use types::c;

// Audio format flags.
//
// Current representation (unspecified bits are always zero):
//
// 	++-----------------------sample is signed if set
// 	||
// 	||       ++-----------sample is bigendian if set
// 	||       ||
// 	||       ||          ++---sample is float if set
// 	||       ||          ||
// 	||       ||          || +---sample bit size---+
// 	||       ||          || |                     |
// 	15 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00
export type audio_format = enum u16 {
	U8     = 0x0008, // Unsigned 8-bit samples.
	S8     = 0x8008, // Signed 8-bit samples.
	U16LSB = 0x0010, // Unsigned 16-bit samples.
	S16LSB = 0x8010, // Signed 16-bit samples.
	U16MSB = 0x1010, // As above, but big-endian byte order.
	S16MSB = 0x9010, // As above, but big-endian byte order.
	U16    = U16LSB,
	S16    = S16LSB,
	S32LSB = 0x8020, // 32-bit integer samples.
	S32MSB = 0x9020, // As above, but big-endian byte order.
	S32    = S32LSB,
	F32LSB = 0x8120, // 32-bit floating point samples.
	F32MSB = 0x9120, // As above, but big-endian byte order.
	F32    = F32LSB,
};

// Allow change flags.
export type allowed_changes = enum {
	FREQUENCY = 0x00000001,
	FORMAT = 0x00000002,
	CHANNELS = 0x00000004,
	SAMPLES = 0x00000008,
	ANY = FREQUENCY | FORMAT | CHANNELS | SAMPLES,
};

// Use this function to get the number of built-in audio drivers.
//
// This function returns a hardcoded number. This never returns a negative
// value; if there are no drivers compiled into this build of SDL, this
// function returns zero. The presence of a driver in this list does not mean
// it will function, it just means SDL is capable of interacting with that
// interface. For example, a build of SDL might have esound support, but if
// there's no esound server available, SDL's esound driver would fail if used.
//
// By default, SDL tries all drivers, in its preferred order, until one is
// found to be usable.
export fn get_num_audio_drivers() int = SDL_GetNumAudioDrivers();

// Use this function to get the name of a built in audio driver.
//
// The list of audio drivers is given in the order that they are normally
// initialized by default; the drivers that seem more reasonable to choose
// first (as far as the SDL developers believe) are earlier in the list.
//
// The names of drivers are all simple, low-ASCII identifiers, like "alsa",
// "coreaudio" or "xaudio2". These never have Unicode characters, and are not
// meant to be proper names.
export fn get_audio_driver(index: int) (str | sdl::error) =
	c::tostr(wrapptr(SDL_GetAudioDriver(index))?: *c::char)!;


// Get the name of the current audio driver.
//
// The returned string points to internal static memory and thus never becomes
// invalid, even if you quit the audio subsystem and initialize a new driver
// (although such a case would return a different static string from another
// call to this function, of course). As such, you should not modify or free
// the returned string.
export fn get_current_audio_driver() (str | sdl::error) =
	c::tostr(wrapptr(SDL_GetCurrentAudioDriver())?: *c::char)!;

// Get the number of built-in audio devices.
//
// This function is only valid after successfully initializing the audio
// subsystem.
//
// This function will return void if an explicit list of devices can't be
// determined. Returning void is not an error. For example, if SDL is set up to
// talk to a remote audio server, it can't list every one available on the
// internet, but it will still allow a specific host to be specified in
// [[open_audio_device]].
//
// In many common cases, when this function returns void, it can still
// successfully open the default device (null for first argument of
// [[open_audio_device]]).
//
// This function may trigger a complete redetect of available hardware. It
// should not be called for each iteration of a loop, but rather once at the
// start of a loop:
//
//	// Don't do this:
//	for (int i = 0; i < get_num_audio_devices(0); i++)
//
//	// Do this instead:
//	let count: int = get_num_audio_devices(0);
//	for (let i = 0; i < count; ++i)
export fn get_num_audio_devices(iscapture: int) (void | int) = {
	let n = SDL_GetNumAudioDevices(iscapture);
	if (n == -1) return void;
	return n;
};

// Get the human-readable name of a specific audio device.
//
// This function is only valid after successfully initializing the audio
// subsystem. The values returned by this function reflect the latest call to
// [[get_num_audio_devices]]; re-call that function to redetect available
// hardware.
//
// The string returned by this function is read-only, and managed internally.
// You are not to free it. If you need to keep the string for any length of
// time, you should make your own copy of it, as it will be invalid next time
// any of several other SDL functions are called.
export fn get_audio_device_name(index: int, iscapture: int) (str | sdl::error) =
	c::tostr(wrapptr(SDL_GetAudioDeviceName(index, iscapture))?: *c::char)!;

//  This function is called when the audio device needs more data.
// 
//  Once the callback returns, the buffer will no longer be valid. Stereo
//  samples are stored in a LRLRLR ordering.
// 
//  You can choose to avoid callbacks and use [[queue_audio]] instead, if you
//  like. Just open your audio device with a null callback.
export type audio_callback = fn(userdata: nullable *opaque, stream: *u8, len_: int) void;

//  For multi-channel audio, the default SDL channel mapping is:
//  2:  FL  FR                          (stereo)
//  3:  FL  FR LFE                      (2.1 surround)
//  4:  FL  FR  BL  BR                  (quad)
//  5:  FL  FR LFE  BL  BR              (4.1 surround)
//  6:  FL  FR  FC LFE  SL  SR          (5.1 surround - last two can also be BL BR)
//  7:  FL  FR  FC LFE  BC  SL  SR      (6.1 surround)
//  8:  FL  FR  FC LFE  BL  BR  SL  SR  (7.1 surround)
// TODO reconsider interface
export type audio_spec = struct {
	freq: int, // DSP frequency -- samples per second.
	format: audio_format, // Audio data format.
	channels: u8, // Number of channels: 1 mono, 2 stereo.
	silence: u8, // Audio buffer silence value (calculated).
	samples: u16, // Audio buffer size in sample FRAMES (total samples divided by channel count).
	padding: u16, // Necessary for some compile environments.
	size_: u32, // Audio buffer size in bytes (calculated).
	callback: nullable *audio_callback, // Callback that feeds the audio device (null to use [[queue_audio]]).
	userdata: nullable *opaque, // Userdata passed to callback (ignored for null callbacks).
};

// Get the preferred audio format of a specific audio device.
//
// This function is only valid after a successfully initializing the audio
// subsystem. The values returned by this function reflect the latest call to
// [[get_num_audio_devices]]; re-call that function to redetect available
// hardware.
export fn get_audio_device_spec(
	index: int,
	iscapture: int,
) (audio_spec | sdl::error) = {
	let spec = audio_spec { format = audio_format::U8, ... };
	if (SDL_GetAudioDeviceSpec(index, iscapture, &spec: *SDL_AudioSpec) != 0)
		return c::tostr(SDL_GetError())!;
	return spec;
};

// Get the name and preferred format of the default audio device.
//
// Some (but not all!) platforms have an isolated mechanism to get information
// about the "default" device. This can actually be a completely different
// device that's not in the list you get from [[get_audio_device_spec]]. It can
// even be a network address!
//
// As a result, this call is not guaranteed to be performant, as it can query
// the sound server directly every time, unlike the other query functions. You
// should call this function sparingly!
//
// Returns a tuple of (name, spec). name must be freed by the caller.
export fn get_default_audio_info(iscapture: int) ((str, audio_spec) | sdl::error) = {
	let n = null: *c::char; // risky business, this
	let s = audio_spec { format = audio_format::U8, ... };
	if (SDL_GetDefaultAudioInfo(&n, &s: *SDL_AudioSpec, iscapture) != 0)
		return c::tostr(SDL_GetError())!;
	defer SDL_free(n);
	return (strings::dup(c::tostr(n)!), s);
};

// SDL audio device IDs.
export type audio_device_id = u32;

// Open a specific audio device.
//
// Passing in a device name of null requests the most reasonable default. The
// device name is a string reported by [[get_audio_device_name]], but some
// drivers allow arbitrary and driver-specific strings, such as a hostname/IP
// address for a remote audio server, or a filename in the diskaudio driver.
//
// An opened audio device starts out paused, and should be enabled for playing
// by calling pause_audio_device(devid, 0) when you are ready for your audio
// callback function to be called. Since the audio driver may modify the
// requested size of the audio buffer, you should allocate any local mixing
// buffers after you open the audio device.
//
// The audio callback runs in a separate thread in most cases; you can prevent
// race conditions between your callback and other threads without fully
// pausing playback with [[lock_audio_device]]. For more information about the
// callback, see [[audio_spec]].
//
// Managing the audio spec via 'desired' and 'obtained':
//
// When filling in the desired audio spec structure:
//
// - desired->freq should be the frequency in sample-frames-per-second (Hz).
// - desired->format should be the audio format (S16SYS, etc).
// - desired->samples is the desired size of the audio buffer, in _sample
//   frames_ (with stereo output, two samples--left and right--would make a
//   single sample frame). This number should be a power of two, and may be
//   adjusted by the audio driver to a value more suitable for the hardware.
//   Good values seem to range between 512 and 8096 inclusive, depending on
//   the application and CPU speed. Smaller values reduce latency, but can
//   lead to underflow if the application is doing heavy processing and cannot
//   fill the audio buffer in time. Note that the number of sample frames is
//   directly related to time by the following formula: ms =
//   (sampleframes*1000)/freq
// - desired->size is the size in _bytes_ of the audio buffer, and is
//   calculated by [[open_audio_device]]. You don't initialize this.
// - desired->silence is the value used to set the buffer to silence, and is
//   calculated by [[open_audio_device]]. You don't initialize this.
// - desired->callback should be set to a function that will be called when
//   the audio device is ready for more data. It is passed a pointer to the
//   audio buffer, and the length in bytes of the audio buffer. This function
//   usually runs in a separate thread, and so you should protect data
//   structures that it accesses by calling [[lock_audio_device]] and
//   [[unlock_audio_device]] in your code. Alternately, you may pass a null
//   pointer here, and call [[queue_audio]] with some frequency, to queue
//   more audio samples to be played (or for capture devices, call
//   [[dequeue_audio]] with some frequency, to obtain audio samples).
// - desired->userdata is passed as the first parameter to your callback
//   function. If you passed a null callback, this value is ignored.
//
// allowed_changes flags specify how SDL should behave when a device cannot
// offer a specific feature. If the application requests a feature that the
// hardware doesn't offer, SDL will always try to get the closest equivalent.
//
// For example, if you ask for float32 audio format, but the sound card only
// supports int16, SDL will set the hardware to int16. If you had set
// allowed_changes, SDL will change the format in the obtained structure. If
// that flag was *not* set, SDL will prepare to convert your callback's float32
// audio to int16 before feeding it to the hardware and will keep the
// originally requested format in the obtained structure.
//
// The resulting audio specs, varying depending on hardware and on what
// changes were allowed, will then be written back to obtained.
//
// If your application can only handle one specific data format, pass a zero
// for allowed_changes and let SDL transparently handle any differences.
export fn open_audio_device(
	device: (str | void),
	iscapture: int,
	desired: *audio_spec,
	obtained: nullable *audio_spec,
	allowed_changes: int,
) (audio_device_id | sdl::error) = {
	let d = match (device) {
	case void => yield null;
	case let s: str => yield c::fromstr(s);
	};
	defer free(d);
	let id = SDL_OpenAudioDevice(d, iscapture, desired: *SDL_AudioSpec,
		obtained: nullable *SDL_AudioSpec, allowed_changes);
	if (id == 0) return get_error();
	return id: audio_device_id;
};

// The current audio state.
export type audio_status = enum {
	STOPPED = 0,
	PLAYING,
	PAUSED,
};

// Use this function to get the current audio state of an audio device.
export fn get_audio_device_status(dev: audio_device_id) audio_status =
	SDL_GetAudioDeviceStatus(dev: SDL_AudioDeviceID): audio_status;

// Use this function to pause and unpause audio playback on a specified
// device.
//
// This function pauses and unpauses the audio callback processing for a given
// device. Newly-opened audio devices start in the paused state, so you must
// call this function with **pause_on**=0 after opening the specified audio
// device to start playing sound. This allows you to safely initialize data
// for your callback function after opening the audio device. Silence will be
// written to the audio device while paused, and the audio callback is
// guaranteed to not be called. Pausing one device does not prevent other
// unpaused devices from running their callbacks.
//
// Pausing state does not stack; even if you pause a device several times, a
// single unpause will start the device playing again, and vice versa. This is
// different from how [[lock_audio_device]] works.
//
// If you just need to protect a few variables from race conditions vs your
// callback, you shouldn't pause the audio device, as it will lead to dropouts
// in the audio playback. Instead, you should use [[lock_audio_device]].
export fn pause_audio_device(dev: audio_device_id, pause_on: bool) void =
	SDL_PauseAudioDevice(dev: SDL_AudioDeviceID, if (pause_on) 1 else 0);

// Load the audio data of a WAVE file into memory.
//
// Loading a WAVE file requires src, spec, audio_buf and audio_len to be valid
// pointers. The entire data portion of the file is then loaded into memory and
// decoded if necessary.
//
// Supported formats are RIFF WAVE files with the formats PCM (8, 16, 24, and
// 32 bits), IEEE Float (32 bits), Microsoft ADPCM and IMA ADPCM (4 bits), and
// A-law and mu-law (8 bits). Other formats are currently unsupported and
// cause an error.
//
// If this function succeeds, the pointer returned by it is equal to spec
// and the pointer to the audio data allocated by the function is written to
// audio_buf and its length in bytes to audio_len. The audio_spec members freq,
// channels, and format are set to the values of the audio data in the buffer.
// The samples member is set to a sane default and all others are set to zero.
//
// It's necessary to use [[free_wav]] to free the audio data returned in
// audio_buf when it is no longer used.
//
// Because of the underspecification of the .WAV format, there are many
// problematic files in the wild that cause issues with strict decoders. To
// provide compatibility with these files, this decoder is lenient in regards
// to the truncation of the file, the fact chunk, and the size of the RIFF
// chunk. The hints HINT_WAVE_RIFF_CHUNK_SIZE,
// HINT_WAVE_TRUNCATION, and HINT_WAVE_FACT_CHUNK can be used to
// tune the behavior of the loading process.
// TODO hints
//
// Any file that is invalid (due to truncation, corruption, or wrong values in
// the headers), too big, or unsupported causes an error. Additionally, any
// critical I/O error from the data source will terminate the loading process
// with an error.
//
// It is required that the data source supports seeking.
//
// Example:
//
//	let f = os::open("sample.wav")!;
//	defer io::close(f)!;
//	load_wav_h(f, &spec, &buf, &len_)!;
//
// Which is equivalent to:
//
//	load_wav("sample.wav", &spec, &buf, &len_)!;
//
// Returns the audio_spec for the data. When done, use [[free_wav]] on the
// buffer.
export fn load_wav_h(
	src: io::handle,
	audio_buf: **u8,
	audio_len: *u32,
) (audio_spec | sdl::error) = {
	const rw = SDL_rw_from_handle(src);
	let spec = audio_spec { format = 0, ... };
	wrapptr(SDL_LoadWAV_RW(&rw, 0, &spec: *SDL_AudioSpec, audio_buf,
		audio_len))?;
	return spec;
};

// Convenience function.
export fn load_wav(
	path: str,
	audio_buf: **u8,
	audio_len: *u32,
) (audio_spec | fs::error | sdl::error) = {
	const f = os::open(path)?;
	defer io::close(f)!;
	return load_wav_h(f, audio_buf, audio_len);
};

// Free data previously allocated with [[load_wav]] or [[load_wav_h]].
export fn free_wav(audio_buf: nullable *u8) void = SDL_FreeWAV(audio_buf);

// A new audio conversion interface.
export type audio_stream = opaque;

// Create a new audio stream.
export fn new_audio_stream(
	src_format: audio_format,
	src_channels: u8,
	src_rate: int,
	dst_format: audio_format,
	dst_channels: u8,
	dst_rate: int,
) (*audio_stream | sdl::error) = {
	return wrapptr(SDL_NewAudioStream(src_format: SDL_AudioFormat,
		src_channels, src_rate, dst_format: SDL_AudioFormat,
		dst_channels, dst_rate))?: *audio_stream;
};

// Add data to be converted/resampled to the stream.
export fn audio_stream_put(stream: *audio_stream, buf: []u8) (void | sdl::error) = {
	let s = &buf: *types::slice;
	return wrapvoid(SDL_AudioStreamPut(stream: *SDL_AudioStream,
		s.data: *opaque, s.length: int));
};

// Get converted/resampled data from the stream
//
// buf is a buffer to fill with audio data
// len_ is the maximum number of bytes to fill
// Returns the number of bytes read from the stream.
// TODO reconsider interface.
export fn audio_stream_get(
	stream: *audio_stream,
	buf: *opaque,
	len_: int,
) (int | sdl::error) = {
	return wrapint(SDL_AudioStreamGet(stream: *SDL_AudioStream, buf, len_));
};

// Get the number of converted/resampled bytes available.
//
// The stream may be buffering data behind the scenes until it has enough to
// resample correctly, so this number might be lower than what you expect, or
// even be zero. Add more data or flush the stream if you need the data now.
export fn audio_stream_available(stream: *audio_stream) int =
	SDL_AudioStreamAvailable(stream: *SDL_AudioStream);

// Tell the stream that you're done sending data, and anything being buffered
// should be converted/resampled and made available immediately.
//
// It is legal to add more data to a stream after flushing, but there will be
// audio gaps in the output. Generally this is intended to signal the end of
// input, so the complete output becomes available.
export fn audio_stream_flush(stream: *audio_stream) int =
	SDL_AudioStreamFlush(stream: *SDL_AudioStream);

// Clear any pending data in the stream without converting it
export fn audio_stream_clear(stream: *audio_stream) void =
	SDL_AudioStreamClear(stream: *SDL_AudioStream);

// Free an audio stream
export fn free_audio_stream(stream: *audio_stream) void =
	SDL_FreeAudioStream(stream: *SDL_AudioStream);

// Mix audio data in a specified format.
//
// This takes an audio buffer src of len_ bytes of format data and mixes it into
// dst, performing addition, volume adjustment, and overflow clipping. The
// buffer pointed to by dst must also be len_ bytes of format data.
//
// This is provided for convenience -- you can mix your own audio data.
//
// Do not use this function for mixing together more than two streams of
// sample data. The output from repeated application of this function may be
// distorted by clipping, because there is no accumulator with greater range
// than the input (not to mention this being an inefficient way of doing it).
//
// It is a common misconception that this function is required to write audio
// data to an output stream in an audio callback. While you can do that,
// [[mix_audio_format]] is really only needed when you're mixing a single
// audio stream with a volume adjustment.
// TODO reconsider interface
export fn mix_audio_format(
	dst: *u8,
	src: *u8,
	format: audio_format,
	len_: u32,
	volume: int,
) void = {
	return SDL_MixAudioFormat(dst, src, format: SDL_AudioFormat, len_,
		volume);
};

// Queue more audio on non-callback devices.
//
// If you are looking to retrieve queued audio from a non-callback capture
// device, you want [[dequeue_audio]] instead. [[queue_audio]] will return
// error if you use it with capture devices.
//
// SDL offers two ways to feed audio to the device: you can either supply a
// callback that SDL triggers with some frequency to obtain more audio (pull
// method), or you can supply no callback, and then SDL will expect you to
// supply data at regular intervals (push method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Queued data will drain to the device as
// necessary without further intervention from you. If the device needs audio
// but there is not enough queued, it will play silence to make up the
// difference. This means you will have skips in your audio playback if you
// aren't routinely queueing sufficient data.
//
// This function copies the supplied data, so you are safe to free it when the
// function returns. This function is thread-safe, but queueing to the same
// device from two threads at once does not promise which buffer will be
// queued first.
//
// You may not queue audio on a device that is using an application-supplied
// callback; doing so returns an error. You have to use the audio callback or
// queue audio with this function, but not both.
//
// You should not call lock_audio on the device before queueing; SDL
// handles locking internally for this function.
//
// Note that SDL2 does not support planar audio. You will need to resample
// from planar audio formats into a non-planar one (see [[audio_format]]
// before queuing audio.
// TODO reconsider interface
export fn queue_audio(
	dev: audio_device_id,
	data: *opaque,
	len_: u32,
) (void | sdl::error) = {
	return wrapvoid(SDL_QueueAudio(dev: SDL_AudioDeviceID, data, len_));
};

// Dequeue more audio on non-callback devices.
//
// If you are looking to queue audio for output on a non-callback playback
// device, you want [[queue_audio]] instead. [[dequeue_audio]] will always
// return 0 if you use it with playback devices.
//
// SDL offers two ways to retrieve audio from a capture device: you can either
// supply a callback that SDL triggers with some frequency as the device
// records more audio data, (push method), or you can supply no callback, and
// then SDL will expect you to retrieve data at regular intervals (pull
// method) with this function.
//
// There are no limits on the amount of data you can queue, short of
// exhaustion of address space. Data from the device will keep queuing as
// necessary without further intervention from you. This means you will
// eventually run out of memory if you aren't routinely dequeueing data.
//
// Capture devices will not queue data when paused; if you are expecting to
// not need captured audio for some length of time, use [[pause_audio_device]]
// to stop the capture device from queueing more data. This can be useful
// during, say, level loading times. When unpaused, capture devices will start
// queueing data from that point, having flushed any capturable data available
// while paused.
//
// This function is thread-safe, but dequeueing from the same device from two
// threads at once does not promise which thread will dequeue data first.
//
// You may not dequeue audio from a device that is using an
// application-supplied callback; doing so returns an error. You have to use
// the audio callback, or dequeue audio with this function, but not both.
//
// You should not call lock_audio on the device before dequeueing; SDL
// handles locking internally for this function.
// May return fewer bytes than requested. Call get_error if so.
// TODO reconsider interface
export fn dequeue_audio(dev: audio_device_id, data: *opaque, len_: u32) u32 = {
	return SDL_DequeueAudio(dev: SDL_AudioDeviceID, data, len_);
};

// Get the number of bytes of still-queued audio.
//
// For playback devices: this is the number of bytes that have been queued for
// playback with [[queue_audio]], but have not yet been sent to the hardware.
//
// Once we've sent it to the hardware, this function can not decide the exact
// byte boundary of what has been played. It's possible that we just gave the
// hardware several kilobytes right before you called this function, but it
// hasn't played any of it yet, or maybe half of it, etc.
//
// For capture devices, this is the number of bytes that have been captured by
// the device and are waiting for you to dequeue. This number may grow at any
// time, so this only informs of the lower-bound of available data.
//
// You may not queue or dequeue audio on a device that is using an
// application-supplied callback; calling this function on such a device
// always returns 0. You have to use the audio callback or queue audio, but
// not both.
//
// You should not call lock_audio on the device before querying; SDL
// handles locking internally for this function.
export fn get_queued_audio_size(dev: audio_device_id) u32 =
	SDL_GetQueuedAudioSize(dev: SDL_AudioDeviceID);

// Drop any queued audio data waiting to be sent to the hardware.
//
// Immediately after this call, [[get_queued_audio_size]] will return 0. For
// output devices, the hardware will start playing silence if more audio isn't
// queued. For capture devices, the hardware will start filling the empty
// queue with new data if the capture device isn't paused.
//
// This will not prevent playback of queued audio that's already been sent to
// the hardware, as we can not undo that, so expect there to be some fraction
// of a second of audio that might still be heard. This can be useful if you
// want to, say, drop any pending music or any unprocessed microphone input
// during a level change in your game.
//
// You may not queue or dequeue audio on a device that is using an
// application-supplied callback.
//
// You should not call lock_audio on the device before clearing the
// queue; SDL handles locking internally for this function.
//
// This function always succeeds and thus returns void.
export fn clear_queued_audio(dev: audio_device_id) void =
	SDL_ClearQueuedAudio(dev: SDL_AudioDeviceID);

// Use this function to lock out the audio callback function for a specified
// device.
//
// The lock manipulated by these functions protects the audio callback
// function specified in [[open_audio_device]]. During a
// [[lock_audio_device]]/[[unlock_audio_device]] pair, you can be guaranteed
// that the callback function for that device is not running, even if the
// device is not paused. While a device is locked, any other unpaused,
// unlocked devices may still run their callbacks.
//
// Calling this function from inside your audio callback is unnecessary. SDL
// obtains this lock before calling your function, and releases it when the
// function returns.
//
// You should not hold the lock longer than absolutely necessary. If you hold
// it too long, you'll experience dropouts in your audio playback. Ideally,
// your application locks the device, sets a few variables and unlocks again.
// Do not do heavy work while holding the lock for a device.
//
// It is safe to lock the audio device multiple times, as long as you unlock
// it an equivalent number of times. The callback will not run until the
// device has been unlocked completely in this way. If your application fails
// to unlock the device appropriately, your callback will never run, you might
// hear repeating bursts of audio, and [[close_audio_device]] will probably
// deadlock.
//
// Internally, the audio device lock is a mutex; if you lock from two threads
// at once, not only will you block the audio callback, you'll block the other
// thread.
export fn lock_audio_device(dev: audio_device_id) void =
	SDL_LockAudioDevice(dev: SDL_AudioDeviceID);

// Use this function to unlock the audio callback function for a specified
// device.
//
// This function should be paired with a previous [[lock_audio_device]] call.
export fn unlock_audio_device(dev: audio_device_id) void =
	SDL_UnlockAudioDevice(dev: SDL_AudioDeviceID);

// Use this function to shut down audio processing and close the audio device.
//
// The application should close open audio devices once they are no longer
// needed. Calling this function will wait until the device's audio callback
// is not running, release the audio hardware and then clean up internal
// state. No further audio will play from this device once this function
// returns.
//
// This function may block briefly while pending audio data is played by the
// hardware, so that applications don't drop the last buffer of data they
// supplied.
//
// The device ID is invalid as soon as the device is closed, and is eligible
// for reuse in a new [[open_audio_device]] call immediately.
export fn close_audio_device(dev: audio_device_id) void =
	SDL_CloseAudioDevice(dev: SDL_AudioDeviceID);
