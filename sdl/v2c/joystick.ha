use types::c;

export type SDL_Joystick = opaque;

export type SDL_JoystickID = i32;

export type SDL_JoystickGUID = SDL_GUID;

export type SDL_JoystickType = enum {
	SDL_JOYSTICK_TYPE_UNKNOWN,
	SDL_JOYSTICK_TYPE_GAMECONTROLLER,
	SDL_JOYSTICK_TYPE_WHEEL,
	SDL_JOYSTICK_TYPE_ARCADE_STICK,
	SDL_JOYSTICK_TYPE_FLIGHT_STICK,
	SDL_JOYSTICK_TYPE_DANCE_PAD,
	SDL_JOYSTICK_TYPE_GUITAR,
	SDL_JOYSTICK_TYPE_DRUM_KIT,
	SDL_JOYSTICK_TYPE_ARCADE_PAD,
	SDL_JOYSTICK_TYPE_THROTTLE,
};

export type SDL_JoystickPowerLevel = enum i32 {
	SDL_JOYSTICK_POWER_UNKNOWN = -1,
	SDL_JOYSTICK_POWER_EMPTY,
	SDL_JOYSTICK_POWER_LOW,
	SDL_JOYSTICK_POWER_MEDIUM,
	SDL_JOYSTICK_POWER_FULL,
	SDL_JOYSTICK_POWER_WIRED,
	SDL_JOYSTICK_POWER_MAX,
};

export type SDL_VirtualJoystickDesc = struct {
	version: u16,
	type_: u16,
	naxes: u16,
	nbuttons: u16,
	nhats: u16,
	vendor_id: u16,
	product_id: u16,
	padding: u16,
	button_maxk: u32,
	axis_mask: u32,

	name: *c::char,
	userdata: *opaque,

	Update: *fn(userdata: *opaque) void,
	SetPlayerIndex: *fn(userdata: *opaque, player_index: int) void,
	Rumble: *fn(userdata: *opaque, low_frequency_rumble: u16, high_frequency_rumble: u16) int,
	RumbleTriggers: *fn(userdata: *opaque, left_rumble: u16, right_rumble: u16) int,
	SetLED: *fn(userdata: *opaque, red: u8, green: u8, blue: u8) int,
	SendEffect: *fn(userdata: *opaque, data: *opaque, sz: size) int,
};

export def SDL_JOYSTICK_AXIS_MAX = 32767i16;
export def SDL_JOYSTICK_AXIS_MIN = -32768i16;

export def SDL_HAT_CENTERED = 0x00i8;
export def SDL_HAT_UP = 0x01i8;
export def SDL_HAT_RIGHT = 0x02i8;
export def SDL_HAT_DOWN = 0x04i8;
export def SDL_HAT_LEFT = 0x08i8;
export def SDL_HAT_RIGHTUP = SDL_HAT_RIGHT | SDL_HAT_UP;
export def SDL_HAT_RIGHTDOWN = SDL_HAT_RIGHT | SDL_HAT_DOWN;
export def SDL_HAT_LEFTUP = SDL_HAT_LEFT | SDL_HAT_UP;
export def SDL_HAT_LEFTDOWN = SDL_HAT_LEFT | SDL_HAT_DOWN;

export @symbol("SDL_LockJoysticks") fn SDL_LockJoysticks() void;
export @symbol("SDL_UnlockJoysticks") fn SDL_UnlockJoysticks() void;
export @symbol("SDL_NumJoysticks") fn SDL_NumJoysticks() int;
export @symbol("SDL_JoystickNameForIndex") fn SDL_JoystickNameForIndex(device_index: int) nullable *c::char;
export @symbol("SDL_JoystickPathForIndex") fn SDL_JoystickPathForIndex(device_index: int) nullable *c::char;
export @symbol("SDL_JoystickGetDevicePlayerIndex") fn SDL_JoystickGetDevicePlayerIndex(device_index: int) int;
export @symbol("SDL_JoystickGetDeviceGUID") fn SDL_JoystickGetDeviceGUID(device_index: int) SDL_JoystickGUID;
export @symbol("SDL_JoystickGetDeviceVendor") fn SDL_JoystickGetDeviceVendor(device_index: int) u16;
export @symbol("SDL_JoystickGetDeviceProduct") fn SDL_JoystickGetDeviceProduct(device_index: int) u16;
export @symbol("SDL_JoystickGetDeviceProductVersion") fn SDL_JoystickGetDeviceProductVersion(device_index: int) u16;
export @symbol("SDL_JoystickGetDeviceType") fn SDL_JoystickGetDeviceType(device_index: int) SDL_JoystickType;
export @symbol("SDL_JoystickGetDeviceInstanceID") fn SDL_JoystickGetDeviceInstanceID(device_index: int) SDL_JoystickID;
export @symbol("SDL_JoystickOpen") fn SDL_JoystickOpen(device_index: int) nullable *SDL_Joystick;
export @symbol("SDL_JoystickFromInstanceID") fn SDL_JoystickFromInstanceID(instance_id: SDL_JoystickID) nullable *SDL_Joystick;
export @symbol("SDL_JoystickFromPlayerIndex") fn SDL_JoystickFromPlayerIndex(player_index: int) nullable *SDL_Joystick;
export @symbol("SDL_JoystickAttachVirtual") fn SDL_JoystickAttachVirtual(type_: SDL_JoystickType, naxes: int, nbuttons: int, nhats: int) int;
export @symbol("SDL_JoystickAttachVirtualEx") fn SDL_JoystickAttachVirtualEx(desc: *SDL_VirtualJoystickDesc) int;
export @symbol("SDL_JoystickDetachVirtual") fn SDL_JoystickDetachVirtual(device_index: int) int;
export @symbol("SDL_JoystickIsVirtual") fn SDL_JoystickIsVirtual(device_index: int) bool;
export @symbol("SDL_JoystickSetVirtualAxis") fn SDL_JoystickSetVirtualAxis(joystick: *SDL_Joystick, axis: int, value: i16) int;
export @symbol("SDL_JoystickSetVirtualButton") fn SDL_JoystickSetVirtualButton(joystick: *SDL_Joystick, button: int, value: u8) int;
export @symbol("SDL_JoystickSetVirtualHat") fn SDL_JoystickSetVirtualHat(joystick: *SDL_Joystick, hat: int, value: u8) int;
export @symbol("SDL_JoystickName") fn SDL_JoystickName(joystick: *SDL_Joystick) nullable *c::char;
export @symbol("SDL_JoystickPath") fn SDL_JoystickPath(joystick: *SDL_Joystick) nullable *c::char;
export @symbol("SDL_JoystickGetPlayerIndex") fn SDL_JoystickGetPlayerIndex(joystick: *SDL_Joystick) int;
export @symbol("SDL_JoystickSetPlayerIndex") fn SDL_JoystickSetPlayerIndex(joystick: *SDL_Joystick, player_index: int) void;
export @symbol("SDL_JoystickGetGUID") fn SDL_JoystickGetGUID(joystick: *SDL_Joystick) SDL_JoystickGUID;
export @symbol("SDL_JoystickGetVendor") fn SDL_JoystickGetVendor(joystick: *SDL_Joystick) u16;
export @symbol("SDL_JoystickGetProduct") fn SDL_JoystickGetProduct(joystick: *SDL_Joystick) u16;
export @symbol("SDL_JoystickGetProductVersion") fn SDL_JoystickGetProductVersion(joystick: *SDL_Joystick) u16;
export @symbol("SDL_JoystickGetFirmwareVersion") fn SDL_JoystickGetFirmwareVersion(joystick: *SDL_Joystick) u16;
export @symbol("SDL_JoystickGetSerial") fn SDL_JoystickGetSerial(joystick: *SDL_Joystick) nullable *c::char;
export @symbol("SDL_JoystickGetType") fn SDL_JoystickGetType(joystick: *SDL_Joystick) SDL_JoystickType;
export @symbol("SDL_JoystickGetGUIDString") fn SDL_JoystickGetGUIDString(guid: SDL_JoystickGUID, pszGUID: *c::char, cbGUID: int) void;
export @symbol("SDL_JoystickGetGUIDFromString") fn SDL_JoystickGetGUIDFromString(pchGUID: *c::char) SDL_JoystickGUID;
export @symbol("SDL_GetJoystickGUIDInfo") fn SDL_GetJoystickGUIDInfo(guid: SDL_JoystickGUID, vendor: *u16, product: *u16, version: *u16, crc16: *u16) void;
export @symbol("SDL_JoystickGetAttached") fn SDL_JoystickGetAttached(joystick: *SDL_Joystick) bool;
export @symbol("SDL_JoystickInstanceID") fn SDL_JoystickInstanceID(joystick: *SDL_Joystick) SDL_JoystickID;
export @symbol("SDL_JoystickNumAxes") fn SDL_JoystickNumAxes(joystick: *SDL_Joystick) int;
export @symbol("SDL_JoystickNumBalls") fn SDL_JoystickNumBalls(joystick: *SDL_Joystick) int;
export @symbol("SDL_JoystickNumHats") fn SDL_JoystickNumHats(joystick: *SDL_Joystick) int;
export @symbol("SDL_JoystickNumButtons") fn SDL_JoystickNumButtons(joystick: *SDL_Joystick) int;
export @symbol("SDL_JoystickUpdate") fn SDL_JoystickUpdate() void;
export @symbol("SDL_JoystickEventState") fn SDL_JoystickEventState(state: int) int;
export @symbol("SDL_JoystickGetAxis") fn SDL_JoystickGetAxis(joystick: *SDL_Joystick, axis: int) i16;
export @symbol("SDL_JoystickGetAxisInitialState") fn SDL_JoystickGetAxisInitialState(joystick: *SDL_Joystick, axis: int, state: *i16) bool;
export @symbol("SDL_JoystickGetHat") fn SDL_JoystickGetHat(joystick: *SDL_Joystick, hat: int) u8;
export @symbol("SDL_JoystickGetBall") fn SDL_JoystickGetBall(joystick: *SDL_Joystick, ball: int, dx: *int, dy: *int) int;
export @symbol("SDL_JoystickGetButton") fn SDL_JoystickGetButton(joystick: *SDL_Joystick, button: int) u8;
export @symbol("SDL_JoystickRumble") fn SDL_JoystickRumble(joystick: *SDL_Joystick, low_frequency_rumble: u16, high_frequency_rumble: u16, duration_ms: u32) int;
export @symbol("SDL_JoystickRumbleTriggers") fn SDL_JoystickRumbleTriggers(joystick: *SDL_Joystick, left_rumble: u16, right_rumble: u16, duration_ms: u32) int;
export @symbol("SDL_JoystickHasLED") fn SDL_JoystickHasLED(joystick: *SDL_Joystick) bool;
export @symbol("SDL_JoystickHasRumble") fn SDL_JoystickHasRumble(joystick: *SDL_Joystick) bool;
export @symbol("SDL_JoystickHasRumbleTriggers") fn SDL_JoystickHasRumbleTriggers(joystick: *SDL_Joystick) bool;
export @symbol("SDL_JoystickSetLED") fn SDL_JoystickSetLED(joystick: *SDL_Joystick, red: u8, green: u8, blue: u8) int;
export @symbol("SDL_JoystickSendEffect") fn SDL_JoystickSendEffect(joystick: *SDL_Joystick, data: *opaque, size_: int) int;
export @symbol("SDL_JoystickClose") fn SDL_JoystickClose(joystick: *SDL_Joystick) void;
export @symbol("SDL_JoystickCurrentPowerLevel") fn SDL_JoystickCurrentPowerLevel(joystick: *SDL_Joystick) SDL_JoystickPowerLevel;
