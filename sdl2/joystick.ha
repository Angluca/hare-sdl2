// TODO: Flesh me out

// Minimum value for a joystick axis.
export def SDL_JOYSTICK_AXIS_MIN: i16 = -32768;

// Minimum value for a joystick axis.
export def SDL_JOYSTICK_AXIS_MAX: i16 = 32767;

@symbol("SDL_NumJoysticks") fn _SDL_NumJoysticks() int;

// Returns the number of joysticks attached to the system.
export fn SDL_NumJoysticks() (int | error) = wrapint(_SDL_NumJoysticks());
