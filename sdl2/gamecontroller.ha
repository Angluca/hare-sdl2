// TODO: Flesh me out

// The gamecontroller structure used to identify an SDL game controller.
// (Opaque)
export type gamecontroller = void;

// The list of axes available from a controller
//
// Thumbstick axis values range from [[JOYSTICK_AXIS_MIN]] to
// [[JOYSTICK_AXIS_MAX]], and are centered within ~8000 of zero, though advanced
// UI will allow users to set or autodetect the dead zone, which varies between
// controllers.
//
// Trigger axis values range from 0 to [[JOYSTICK_AXIS_MAX]].
export type controller_axis = enum u8 {
    LEFTX,
    LEFTY,
    RIGHTX,
    RIGHTY,
    TRIGGERLEFT,
    TRIGGERRIGHT,
    INVALID = 255,
};

// The list of buttons available from a controller
export type controller_button = enum u8 {
	INVALID = 255,
	A = 0,
	B,
	X,
	Y,
	BACK,
	GUIDE,
	START,
	LEFTSTICK,
	RIGHTSTICK,
	LEFTSHOULDER,
	RIGHTSHOULDER,
	DPAD_UP,
	DPAD_DOWN,
	DPAD_LEFT,
	DPAD_RIGHT,
	MISC1,
	PADDLE1,
	PADDLE2,
	PADDLE3,
	PADDLE4,
	TOUCHPAD,
};

// Check if the given joystick is supported by the game controller interface.
// 
// 'joystick_index' is the same as the 'device_index' passed to
// [[joystick_open]].
// 
// Returns true if the given joystick is supported by the game controller
// interface, false if it isn't or it's an invalid index.
export @symbol("SDL_IsGameController") fn is_game_controller(
	joystick_index: int) bool;

@symbol("SDL_GameControllerOpen") fn _game_controller_open(
	joystick_index: int) nullable *gamecontroller;

// Get the SDL_GameController associated with an instance id.
export fn game_controller_open(
	joystick_index: int,
) (*gamecontroller | error) = {
	return wrapptr(_game_controller_open(joystick_index))?: *gamecontroller;
};

// Close a game controller previously opened with [[game_controller_open]].
export @symbol("SDL_GameControllerClose") fn game_controller_close(
	gamecontroller: *gamecontroller) void;

@symbol("SDL_GameControllerRumble") fn _game_controller_rumble(
	gamecontroller: *gamecontroller,
	low_frequency_rumble: u16,
	high_frequency_rumble: u16,
	duration_ms: u32) int;

// Start a rumble effect on a game controller.
//
// Each call to this function cancels any previous rumble effect, and calling
// it with 0 intensity stops any rumbling.
//
// The low-frequency motor is generally on the left, and the high-frequency
// motor is generally on the right.
export fn game_controller_rumble(
	gamecontroller: *gamecontroller,
	low_frequency_rumble: u16,
	high_frequency_rumble: u16,
	duration_ms: u32,
) (void | error) = {
	return wrapvoid(_game_controller_rumble(
		gamecontroller,
		low_frequency_rumble,
		high_frequency_rumble,
		duration_ms));
};
