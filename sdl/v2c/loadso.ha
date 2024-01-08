use types::c;

export @symbol("SDL_LoadObject") fn SDL_LoadObject(sofile: *c::char) nullable *opaque;
export @symbol("SDL_LoadFunction") fn SDL_LoadFunction(handle: *opaque, name: *c::char) nullable *opaque;
export @symbol("SDL_UnloadObject") fn SDL_UnloadObject(handle: *opaque) void;
