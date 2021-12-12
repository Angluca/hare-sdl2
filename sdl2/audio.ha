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
export type audio_format = u16;

// Unsigned 8-bit samples
export def AUDIO_U8: audio_format = 0x0008;
// Signed 8-bit samples
export def AUDIO_S8: audio_format = 0x8008;
// Unsigned 16-bit samples, little-endian
export def AUDIO_U16LSB: audio_format = 0x0010;
// Signed 16-bit samples, little-endian
export def AUDIO_S16LSB: audio_format = 0x8010;
// Unsigned 16-bit samples, big-endian
export def AUDIO_U16MSB: audio_format = 0x1010;
// Signed 16-bit samples, big-endian
export def AUDIO_S16MSB: audio_format = 0x9010;
// Unsigned 16-bit samples
export def AUDIO_U16: audio_format = AUDIO_U16LSB;
// Signed 16-bit samples
export def AUDIO_S16: audio_format = AUDIO_S16LSB;
