use types::c;

export type SDL_TouchID = i64;
export type SDL_FingerID = i64;

export type SDL_TouchDeviceType = enum {
	SDL_TOUCH_DEVICE_INVALID = -1,
	SDL_TOUCH_DEVICE_DIRECT,
	SDL_TOUCH_DEVICE_INDIRECT_ABSOLUTE,
	SDL_TOUCH_DEVICE_INDIRECT_RELATIVE,
};

export type SDL_Finger = struct {
	id: SDL_FingerID,
	x: f32,
	y: f32,
	pressure: f32,
};

export def SDL_TOUCH_MOUSEID = 0xFFFFFFFFu32;
export def SDL_MOUSE_TOUCHID = -1i64;

export @symbol("SDL_GetNumTouchDevices") fn SDL_GetNumTouchDevices() int;
export @symbol("SDL_GetTouchDevice") fn SDL_GetTouchDevice(index: int) SDL_TouchID;
export @symbol("SDL_GetTouchName") fn SDL_GetTouchName(index: int) nullable *c::char;
export @symbol("SDL_GetTouchDeviceType") fn SDL_GetTouchDeviceType(touchID: SDL_TouchID) SDL_TouchDeviceType;
export @symbol("SDL_GetNumTouchFingers") fn SDL_GetNumTouchFingers(touchID: SDL_TouchID) int;
export @symbol("SDL_GetTouchFinger") fn SDL_GetTouchFinger(touchID: SDL_TouchID, index: int) nullable *SDL_Finger;
