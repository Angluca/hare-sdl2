use types::c;
use sdl::v2c::*;

// Information about the version of SDL in use.
//
// Represents the library's version as three levels: major revision (increments
// with massive changes, additions, and enhancements), minor revision with
// backwards-compatible changes to the major revision), and patchlevel
// (increments with fixes to the minor revision).
export type version = struct {
	major: u8,
	minor: u8,
	patch: u8,
};

// Get the version of SDL that is linked against your program.
//
// This function may be called safely at any time, even before init().
//
// ver is the version structure that contains the version information.
export fn get_version(ver: *version) void = SDL_GetVersion(ver: *SDL_version);

// Get the code revision of SDL that is linked against your program.
// 
// The revision is arbitrary string (a hash value) uniquely identifying the
// exact revision of the SDL library in use, and is only useful in comparing
// against other revisions. It is NOT an incrementing number.
// 
// If SDL wasn't built from a git repository with the appropriate tools, this
// will return an empty string.
// 
// Prior to SDL 2.0.16, before development moved to GitHub, this returned a hash
// for a Mercurial repository.
// 
// You shouldn't use this function for anything but logging it for debugging
// purposes. The string is not intended to be reliable in any way.
// 
// Returns an arbitrary string, uniquely identifying the exact revision of the
// SDL library in use.
export fn get_revision() str = c::tostr(SDL_GetRevision())!;
