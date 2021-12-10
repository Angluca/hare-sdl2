// TODO: Flesh me out

// Minimum value for a joystick axis.
export def JOYSTICK_AXIS_MIN: i16 = -32768;

// Minimum value for a joystick axis.
export def JOYSTICK_AXIS_MAX: i16 = 32767;

@symbol("SDL_NumJoysticks") fn _numjoysticks() int;

// Returns the number of joysticks attached to the system.
export fn numjoysticks() (int | error) = wrapint(_numjoysticks());
