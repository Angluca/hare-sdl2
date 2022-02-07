// These are the flags which may be passed to [[SDL_Init]]. You should specify the
// subsystems which you will be using in your application.
export type init_flags = enum uint {
	TIMER = 0x00000001u,
	AUDIO = 0x00000010u,
	VIDEO = 0x00000020u,
	JOYSTICK = 0x00000200u,
	HAPTIC = 0x00001000u,
	GAMECONTROLLER = 0x00002000u,
	EVENTS = 0x00004000u,
	SENSOR = 0x00008000u,
	NOPARACHUTE = 0x00100000u,
	EVERYTHING = TIMER | AUDIO | VIDEO | EVENTS | JOYSTICK | HAPTIC | GAMECONTROLLER | SENSOR,
};

@symbol("SDL_Init") fn _SDL_Init(flags: init_flags) int;

// This function initializes the subsystems specified by 'flags'.
export fn SDL_Init(flags: init_flags) (void | error) = {
	return wrapvoid(_SDL_Init(flags));
};

// This function cleans up all initialized subsystems. You should call it upon
// all exit conditions.
export @symbol("SDL_Quit") fn SDL_Quit() void;
