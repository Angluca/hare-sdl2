// TODO: Flesh me out

// Minimum value for a joystick axis.
export def JOYSTICK_AXIS_MIN: i16 = -32768;

// Minimum value for a joystick axis.
export def JOYSTICK_AXIS_MAX: i16 = 32767;

// Count the number of joysticks attached to the system.
//
// Returns the number of attached joysticks on success or a negative error code
// on failure.
export @symbol("SDL_NumJoysticks") fn numjoysticks() int;
