use types::c;

export type SDL_GUID = struct {
	data: [16]u8,
};

export @symbol("SDL_GUIDToString") fn SDL_GUIDToString(guid: SDL_GUID, pszGUID: *c::char, cbGUID: int) void;
export @symbol("SDL_GUIDFromString") fn SDL_GUIDFromString(pchGUID: *c::char) SDL_GUID;
