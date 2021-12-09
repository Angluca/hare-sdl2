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

// Check if the given joystick is supported by the game controller interface.
// 
// 'joystick_index' is the same as the 'device_index' passed to
// [[joystick_open]].
// 
// Returns SDL_TRUE if the given joystick is supported by the game controller
// interface, SDL_FALSE if it isn't or it's an invalid index.
export @symbol("SDL_IsGameController") fn is_game_controller(
	joystick_index: int) bool;

// Get the SDL_GameController associated with an instance id.
//
// Returns a [[controller]] on success or NULL on failure.
export @symbol("SDL_GameControllerOpen") fn game_controller_open(
	joystick_index: int) *gamecontroller;

// Close a game controller previously opened with [[game_controller_open]].
export @symbol("SDL_GameControllerClose") fn game_controller_close(
	gamecontroller: *gamecontroller) void;
