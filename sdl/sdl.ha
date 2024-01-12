use sdl::v2c::*;

// These are the flags which may be passed to [[init]]. You should specify the
// subsystems which you will be using in your application.
export type init_flags = enum u32 {
	TIMER          = 0x00000001, // timer subsystem
	AUDIO          = 0x00000010, // audio subsystem
	VIDEO          = 0x00000020, // video subsystem, implies events
	JOYSTICK       = 0x00000200, // joystick subsystem, implies events
	HAPTIC         = 0x00001000, // haptic (force feedback) subsystem
	GAMECONTROLLER = 0x00002000, // gamecontroller subsystem, implies joystick
	EVENTS         = 0x00004000, // events subsystem
	SENSOR         = 0x00008000, // sensor subsystem
	EVERYTHING     = TIMER | AUDIO | VIDEO | EVENTS | JOYSTICK | HAPTIC
		| GAMECONTROLLER | SENSOR, // all of the above subsystems
};

// Initialize the SDL library.
// 
// The file I/O and threading subsystems are initialized by default. Message
// boxes (show_simple_message_box) also attempt to work without initializing the
// video subsystem, in hopes of being useful in showing an error dialog when
// init fails. You must specifically initialize other subsystems if you use them
// in your application.
export fn init(flags: init_flags) (void | error) = wrapvoid(SDL_Init(flags));

// Get a mask of the specified subsystems which are currently initialized.
// 
// Returns a mask of all initialized subsystems if flags is 0, otherwise it
// returns the initialization status of the specified subsystems.
export fn was_init(flags: init_flags) init_flags =
	SDL_WasInit(flags): init_flags;

// Clean up all initialized subsystems.
// 
// It is safe to call this function even in the case of errors in
// initialization.
export fn quit() void = SDL_Quit();
