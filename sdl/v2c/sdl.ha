export def SDL_INIT_TIMER = 0x00000001u;
export def SDL_INIT_AUDIO = 0x00000010u;
export def SDL_INIT_VIDEO = 0x00000020u;
export def SDL_INIT_JOYSTICK = 0x00000200u;
export def SDL_INIT_HAPTIC = 0x00001000u;
export def SDL_INIT_GAMECONTROLLER = 0x00002000u;
export def SDL_INIT_EVENTS = 0x00004000u;
export def SDL_INIT_SENSOR = 0x00008000u;
export def SDL_INIT_NOPARACHUTE = 0x00100000u;
export def SDL_INIT_EVERYTHING = SDL_INIT_TIMER | SDL_INIT_AUDIO
	| SDL_INIT_VIDEO | SDL_INIT_EVENTS | SDL_INIT_JOYSTICK | SDL_INIT_HAPTIC
	| SDL_INIT_GAMECONTROLLER | SDL_INIT_SENSOR;

export @symbol("SDL_Init") fn SDL_Init(flags: u32) int;
export @symbol("SDL_InitSubSystem") fn SDL_InitSubSystem(flags: u32) int;
export @symbol("SDL_QuitSubSystem") fn SDL_QuitSubSystem(flags: u32) void;
export @symbol("SDL_WasInit") fn SDL_WasInit(flags: u32) u32;
export @symbol("SDL_Quit") fn SDL_Quit() void;
