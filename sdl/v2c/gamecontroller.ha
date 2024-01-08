use types::c;

export type SDL_GameController = opaque;

export type SDL_GameControllerType = enum {
	SDL_CONTROLLER_TYPE_UNKNOWN = 0,
	SDL_CONTROLLER_TYPE_XBOX360,
	SDL_CONTROLLER_TYPE_XBOXONE,
	SDL_CONTROLLER_TYPE_PS3,
	SDL_CONTROLLER_TYPE_PS4,
	SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_PRO,
	SDL_CONTROLLER_TYPE_VIRTUAL,
	SDL_CONTROLLER_TYPE_PS5,
	SDL_CONTROLLER_TYPE_AMAZON_LUNA,
	SDL_CONTROLLER_TYPE_GOOGLE_STADIA,
	SDL_CONTROLLER_TYPE_NVIDIA_SHIELD,
	SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_LEFT,
	SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_RIGHT,
	SDL_CONTROLLER_TYPE_NINTENDO_SWITCH_JOYCON_PAIR,
	SDL_CONTROLLER_TYPE_MAX,
};

export type SDL_GameControllerBindType = enum {
	SDL_CONTROLLER_BINDTYPE_NONE = 0,
	SDL_CONTROLLER_BINDTYPE_BUTTON,
	SDL_CONTROLLER_BINDTYPE_AXIS,
	SDL_CONTROLLER_BINDTYPE_HAT,
};

export type SDL_GameControllerButtonBind = struct {
	bindType: SDL_GameControllerBindType,
	value: union {
		button: int,
		axis: int,
		hat: struct {
			hat: int,
			hat_mask: int,
		},
	},
};

export type SDL_GameControllerAxis = enum {
	SDL_CONTROLLER_AXIS_INVALID = -1,
	SDL_CONTROLLER_AXIS_LEFTX,
	SDL_CONTROLLER_AXIS_LEFTY,
	SDL_CONTROLLER_AXIS_RIGHTX,
	SDL_CONTROLLER_AXIS_RIGHTY,
	SDL_CONTROLLER_AXIS_TRIGGERLEFT,
	SDL_CONTROLLER_AXIS_TRIGGERRIGHT,
	SDL_CONTROLLER_AXIS_MAX,
};

export type SDL_GameControllerButton = enum {
	SDL_CONTROLLER_BUTTON_INVALID = -1,
	SDL_CONTROLLER_BUTTON_A,
	SDL_CONTROLLER_BUTTON_B,
	SDL_CONTROLLER_BUTTON_X,
	SDL_CONTROLLER_BUTTON_Y,
	SDL_CONTROLLER_BUTTON_BACK,
	SDL_CONTROLLER_BUTTON_GUIDE,
	SDL_CONTROLLER_BUTTON_START,
	SDL_CONTROLLER_BUTTON_LEFTSTICK,
	SDL_CONTROLLER_BUTTON_RIGHTSTICK,
	SDL_CONTROLLER_BUTTON_LEFTSHOULDER,
	SDL_CONTROLLER_BUTTON_RIGHTSHOULDER,
	SDL_CONTROLLER_BUTTON_DPAD_UP,
	SDL_CONTROLLER_BUTTON_DPAD_DOWN,
	SDL_CONTROLLER_BUTTON_DPAD_LEFT,
	SDL_CONTROLLER_BUTTON_DPAD_RIGHT,
	SDL_CONTROLLER_BUTTON_MISC1,
	SDL_CONTROLLER_BUTTON_PADDLE1,
	SDL_CONTROLLER_BUTTON_PADDLE2,
	SDL_CONTROLLER_BUTTON_PADDLE3,
	SDL_CONTROLLER_BUTTON_PADDLE4,
	SDL_CONTROLLER_BUTTON_TOUCHPAD,
	SDL_CONTROLLER_BUTTON_MAX,
};

export @symbol("SDL_GameControllerAddMappingsFromRW") fn SDL_GameControllerAddMappingsFromRW(rw: *SDL_RWops, freerw: int) int;
export @symbol("SDL_GameControllerAddMapping") fn SDL_GameControllerAddMapping(mappingString: *c::char) int;
export @symbol("SDL_GameControllerNumMappings") fn SDL_GameControllerNumMappings() int;
export @symbol("SDL_GameControllerMappingForIndex") fn SDL_GameControllerMappingForIndex(mapping_index: int) nullable *c::char;
export @symbol("SDL_GameControllerMappingForGUID") fn SDL_GameControllerMappingForGUID(guid: SDL_JoystickGUID) nullable *c::char;
export @symbol("SDL_GameControllerMapping") fn SDL_GameControllerMapping(gamecontroller: *SDL_GameController) nullable *c::char;
export @symbol("SDL_IsGameController") fn SDL_IsGameController(joystick_index: int) bool;
export @symbol("SDL_GameControllerNameForIndex") fn SDL_GameControllerNameForIndex(joystick_index: int) nullable *c::char;
export @symbol("SDL_GameControllerPathForIndex") fn SDL_GameControllerPathForIndex(joystick_index: int) nullable *c::char;
export @symbol("SDL_GameControllerTypeForIndex") fn SDL_GameControllerTypeForIndex(joystick_index: int) SDL_GameControllerType;
export @symbol("SDL_GameControllerMappingForDeviceIndex") fn SDL_GameControllerMappingForDeviceIndex(joystick_index: int) nullable *c::char;
export @symbol("SDL_GameControllerOpen") fn SDL_GameControllerOpen(joystick_index: int) nullable *SDL_GameController;
export @symbol("SDL_GameControllerFromInstanceID") fn SDL_GameControllerFromInstanceID(joyid: SDL_JoystickID) nullable *SDL_GameController;
export @symbol("SDL_GameControllerFromPlayerIndex") fn SDL_GameControllerFromPlayerIndex(player_index: int) nullable *SDL_GameController;
export @symbol("SDL_GameControllerName") fn SDL_GameControllerName(gamecontroller: *SDL_GameController) nullable *c::char;
export @symbol("SDL_GameControllerPath") fn SDL_GameControllerPath(gamecontroller: *SDL_GameController) nullable *c::char;
export @symbol("SDL_GameControllerGetType") fn SDL_GameControllerGetType(gamecontroller: *SDL_GameController) SDL_GameControllerType;
export @symbol("SDL_GameControllerGetPlayerIndex") fn SDL_GameControllerGetPlayerIndex(gamecontroller: *SDL_GameController) int;
export @symbol("SDL_GameControllerSetPlayerIndex") fn SDL_GameControllerSetPlayerIndex(gamecontroller: *SDL_GameController, player_index: int) void;
export @symbol("SDL_GameControllerGetVendor") fn SDL_GameControllerGetVendor(gamecontroller: *SDL_GameController) u16;
export @symbol("SDL_GameControllerGetProduct") fn SDL_GameControllerGetProduct(gamecontroller: *SDL_GameController) u16;
export @symbol("SDL_GameControllerGetProductVersion") fn SDL_GameControllerGetProductVersion(gamecontroller: *SDL_GameController) u16;
export @symbol("SDL_GameControllerGetFirmwareVersion") fn SDL_GameControllerGetFirmwareVersion(gamecontroller: *SDL_GameController) u16;
export @symbol("SDL_GameControllerGetSerial") fn SDL_GameControllerGetSerial(gamecontroller: *SDL_GameController) nullable *c::char;
export @symbol("SDL_GameControllerGetSteamHandle") fn SDL_GameControllerGetSteamHandle(gamecontroller: *SDL_GameController) u64;
export @symbol("SDL_GameControllerGetAttached") fn SDL_GameControllerGetAttached(gamecontroller: *SDL_GameController) bool;
export @symbol("SDL_GameControllerGetJoystick") fn SDL_GameControllerGetJoystick(gamecontroller: *SDL_GameController) nullable *SDL_Joystick;
export @symbol("SDL_GameControllerEventState") fn SDL_GameControllerEventState(state: int) int;
export @symbol("SDL_GameControllerUpdate") fn SDL_GameControllerUpdate() void;
export @symbol("SDL_GameControllerGetAxisFromString") fn SDL_GameControllerGetAxisFromString(str_: *c::char) SDL_GameControllerAxis;
export @symbol("SDL_GameControllerGetStringForAxis") fn SDL_GameControllerGetStringForAxis(axis: SDL_GameControllerAxis) nullable *c::char;
export @symbol("SDL_GameControllerGetBindForAxis") fn SDL_GameControllerGetBindForAxis(gamecontroller: *SDL_GameController, axis: SDL_GameControllerAxis) SDL_GameControllerButtonBind;
export @symbol("SDL_GameControllerHasAxis") fn SDL_GameControllerHasAxis(gamecontroller: *SDL_GameController, axis: SDL_GameControllerAxis) bool;
export @symbol("SDL_GameControllerGetAxis") fn SDL_GameControllerGetAxis(gamecontroller: *SDL_GameController, axis: SDL_GameControllerAxis) i16;
export @symbol("SDL_GameControllerGetButtonFromString") fn SDL_GameControllerGetButtonFromString(str_: *c::char) SDL_GameControllerButton;
export @symbol("SDL_GameControllerGetStringForButton") fn SDL_GameControllerGetStringForButton(button: SDL_GameControllerButton) nullable *c::char;
export @symbol("SDL_GameControllerGetBindForButton") fn SDL_GameControllerGetBindForButton(gamecontroller: *SDL_GameController, button: SDL_GameControllerButton) SDL_GameControllerButtonBind;
export @symbol("SDL_GameControllerHasButton") fn SDL_GameControllerHasButton(gamecontroller: *SDL_GameController, button: SDL_GameControllerButton) bool;
export @symbol("SDL_GameControllerGetButton") fn SDL_GameControllerGetButton(gamecontroller: *SDL_GameController, button: SDL_GameControllerButton) u8;
export @symbol("SDL_GameControllerGetNumTouchpads") fn SDL_GameControllerGetNumTouchpads(gamecontroller: *SDL_GameController) int;
export @symbol("SDL_GameControllerGetNumTouchpadFingers") fn SDL_GameControllerGetNumTouchpadFingers(gamecontroller: *SDL_GameController, touchpad: int) int;
export @symbol("SDL_GameControllerGetTouchpadFinger") fn SDL_GameControllerGetTouchpadFinger(gamecontroller: *SDL_GameController, touchpad: int, finger: int, state: *u8, x: *f32, y: *f32, pressure: *f32) int;
export @symbol("SDL_GameControllerHasSensor") fn SDL_GameControllerHasSensor(gamecontroller: *SDL_GameController, type_: SDL_SensorType) bool;
export @symbol("SDL_GameControllerSetSensorEnabled") fn SDL_GameControllerSetSensorEnabled(gamecontroller: *SDL_GameController, type_: SDL_SensorType, enabled: bool) int;
export @symbol("SDL_GameControllerIsSensorEnabled") fn SDL_GameControllerIsSensorEnabled(gamecontroller: *SDL_GameController, type_: SDL_SensorType) bool;
export @symbol("SDL_GameControllerGetSensorDataRate") fn SDL_GameControllerGetSensorDataRate(gamecontroller: *SDL_GameController, type_: SDL_SensorType) f32;
export @symbol("SDL_GameControllerGetSensorData") fn SDL_GameControllerGetSensorData(gamecontroller: *SDL_GameController, type_: SDL_SensorType, data: *f32, num_values: int) int;
export @symbol("SDL_GameControllerGetSensorDataWithTimestamp") fn SDL_GameControllerGetSensorDataWithTimestamp(gamecontroller: *SDL_GameController, type_: SDL_SensorType, timestamp: *u64, data: *f32, num_values: int) int;
export @symbol("SDL_GameControllerRumble") fn SDL_GameControllerRumble(gamecontroller: *SDL_GameController, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) int;
export @symbol("SDL_GameControllerRumbleTriggers") fn SDL_GameControllerRumbleTriggers(gamecontroller: *SDL_GameController, left_rumble: u16, right_rumble: u16, duration_ms: u32) int;
export @symbol("SDL_GameControllerHasLED") fn SDL_GameControllerHasLED(gamecontroller: *SDL_GameController) bool;
export @symbol("SDL_GameControllerHasRumble") fn SDL_GameControllerHasRumble(gamecontroller: *SDL_GameController) bool;
export @symbol("SDL_GameControllerHasRumbleTriggers") fn SDL_GameControllerHasRumbleTriggers(gamecontroller: *SDL_GameController) bool;
export @symbol("SDL_GameControllerSetLED") fn SDL_GameControllerSetLED(gamecontroller: *SDL_GameController, red: u8, green: u8, blue: u8) int;
export @symbol("SDL_GameControllerSendEffect") fn SDL_GameControllerSendEffect(gamecontroller: *SDL_GameController, data: *opaque, size_: int) int;
export @symbol("SDL_GameControllerClose") fn SDL_GameControllerClose(gamecontroller: *SDL_GameController) void;
