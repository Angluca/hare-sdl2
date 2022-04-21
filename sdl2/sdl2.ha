export def SDL_INIT_TIMER: uint = 0x00000001u;
export def SDL_INIT_AUDIO: uint = 0x00000010u;
export def SDL_INIT_VIDEO: uint = 0x00000020u;
export def SDL_INIT_JOYSTICK: uint = 0x00000200u;
export def SDL_INIT_HAPTIC: uint = 0x00001000u;
export def SDL_INIT_GAMECONTROLLER: uint = 0x00002000u;
export def SDL_INIT_EVENTS: uint = 0x00004000u;
export def SDL_INIT_SENSOR: uint = 0x00008000u;
export def SDL_INIT_NOPARACHUTE: uint = 0x00100000u;
export def SDL_INIT_EVERYTHING: uint = SDL_INIT_TIMER | SDL_INIT_AUDIO | SDL_INIT_VIDEO
	| SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC
	| SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR;

@symbol("SDL_Init") fn _SDL_Init(flags: uint) int;

// This function initializes the subsystems specified by 'flags'.
export fn SDL_Init(flags: uint) (void | error) = {
	return wrapvoid(_SDL_Init(flags));
};

// This function cleans up all initialized subsystems. You should call it upon
// all exit conditions.
export @symbol("SDL_Quit") fn SDL_Quit() void;
