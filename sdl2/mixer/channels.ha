use sdl2;

@symbol("Mix_PlayChannelTimed") fn _play_channel_timed(
	channel: int,
	sample: *chunk,
	loops: int,
	ticks: int,
) int;

// Play chunk on channel, or if channel is -1, pick the first free unreserved
// channel. The sample will play for loops+1 number of times, unless stopped by
// halt, or fade out, or setting a new expiration time of less time than it
// would have originally taken to play the loops, or closing the mixer.
export fn play_channel(
	channel: int,
	sample: *chunk,
	loops: int,
) (void | sdl2::error) = {
	return sdl2::wrapvoid(_play_channel_timed(channel, sample, loops, -1));
};
