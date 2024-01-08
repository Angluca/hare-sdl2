use types::c;

export type SDL_version = struct {
	major: u8,
	minor: u8,
	patch: u8,
};

export @symbol("SDL_GetVersion") fn SDL_GetVersion(ver: *SDL_version) void;
export @symbol("SDL_GetRevision") fn SDL_GetRevision() *c::char;
