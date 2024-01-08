use types::c;

export type SDL_EventType = enum u32 {
	SDL_FIRSTEVENT = 0,

	SDL_QUIT = 0x100,

	SDL_APP_TERMINATING,
	SDL_APP_LOWMEMORY,
	SDL_APP_WILLENTERBACKGROUND,
	SDL_APP_DIDENTERBACKGROUND,
	SDL_APP_WILLENTERFOREGROUND,
	SDL_APP_DIDENTERFOREGROUND,
	SDL_LOCALECHANGED,

	SDL_DISPLAYEVENT = 0x150,

	SDL_WINDOWEVENT = 0x200,
	SDL_SYSWMEVENT,

	SDL_KEYDOWN = 0x300,
	SDL_KEYUP,
	SDL_TEXTEDITING,
	SDL_TEXTINPUT,
	SDL_KEYMAPCHANGED,
	SDL_TEXTEDITING_EXT,

	SDL_MOUSEMOTION = 0x400,
	SDL_MOUSEBUTTONDOWN,
	SDL_MOUSEBUTTONUP,
	SDL_MOUSEWHEEL,

	SDL_JOYAXISMOTION = 0x600,
	SDL_JOYBALLMOTION,
	SDL_JOYHATMOTION,
	SDL_JOYBUTTONDOWN,
	SDL_JOYBUTTONUP,
	SDL_JOYDEVICEADDED,
	SDL_JOYDEVICEREMOVED,
	SDL_JOYBATTERYUPDATED,

	SDL_CONTROLLERAXISMOTION = 0x650,
	SDL_CONTROLLERBUTTONDOWN,
	SDL_CONTROLLERBUTTONUP,
	SDL_CONTROLLERDEVICEADDED,
	SDL_CONTROLLERDEVICEREMOVED,
	SDL_CONTROLLERDEVICEREMAPPED,
	SDL_CONTROLLERTOUCHPADDOWN,
	SDL_CONTROLLERTOUCHPADMOTION,
	SDL_CONTROLLERTOUCHPADUP,
	SDL_CONTROLLERSENSORUPDATE,

	SDL_FINGERDOWN = 0x700,
	SDL_FINGERUP,
	SDL_FINGERMOTION,

	SDL_DOLLARGESTURE = 0x800,
	SDL_DOLLARRECORD,
	SDL_MULTIGESTURE,

	SDL_CLIPBOARDUPDATE = 0x900,

	SDL_DROPFILE = 0x1000,
	SDL_DROPTEXT,
	SDL_DROPBEGIN,
	SDL_DROPCOMPLETE,

	SDL_AUDIODEVICEADDED = 0x1100,
	SDL_AUDIODEVICEREMOVED,

	SDL_SENSORUPDATE = 0x1200,

	SDL_RENDER_TARGETS_RESET = 0x2000,
	SDL_RENDER_DEVICE_RESET,

	SDL_USEREVENT = 0x8000,

	SDL_LASTEVENT = 0xFFFF
};

export type SDL_CommonEvent = struct {
	type_: SDL_EventType,
	timestamp: u32,
};

export type SDL_DisplayEvent = struct {
	SDL_CommonEvent,
	display: u32,
	event: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	data1: i32,
};

export type SDL_WindowEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	event: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	data1: i32,
	data2: i32,
};

export type SDL_KeyboardEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	state: u8,
	repeat: u8,
	padding2: u8,
	padding3: u8,
	keysym: SDL_Keysym,
};

export def SDL_TEXTEDITINGEVENT_TEXT_SIZE: size = 32;

export type SDL_TextEditingEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	text: [SDL_TEXTEDITINGEVENT_TEXT_SIZE]c::char,
	start: i32,
	length: i32,
};

export type SDL_TextEditingExtEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	text: *c::char,
	start: i32,
	length: i32,
};

export def SDL_TEXTINPUTEVENT_TEXT_SIZE: size = 32;

export type SDL_TextInputEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	text: [SDL_TEXTINPUTEVENT_TEXT_SIZE]c::char,
};

export type SDL_MouseMotionEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	which: u32,
	state: u32,
	x: i32,
	y: i32,
	xrel: i32,
	yrel: i32,
};

export type SDL_MouseButtonEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	which: u32,
	button: u8,
	state: u8,
	clicks: u8,
	padding1: u8,
	x: i32,
	y: i32,
};

export type SDL_MouseWheelEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	which: u32,
	x: i32,
	y: i32,
	direction: u32,
	preciseX: f32,
	preciseY: f32,
	mouseX: i32,
	mouseY: i32,
};

export type SDL_JoyAxisEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	axis: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	value: i16,
	padding4: u16,
};

export type SDL_JoyBallEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	ball: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	xrel: i16,
	yrel: i16,
};

export type SDL_JoyHatEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	hat: u8,
	value: u8,
	padding1: u8,
	padding2: u8,
};

export type SDL_JoyButtonEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	button: u8,
	state: u8,
	padding1: u8,
	padding2: u8,
};

export type SDL_JoyDeviceEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
};

export type SDL_JoyBatteryEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	level: SDL_JoystickPowerLevel,
};

export type SDL_ControllerAxisEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	axis: SDL_GameControllerAxis,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	value: i16,
	padding4: u16,
};

export type SDL_ControllerButtonEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	button: u8,
	state: u8,
	padding1: u8,
	padding2: u8,
};

export type SDL_ControllerDeviceEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
};

export type SDL_ControllerTouchpadEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	touchpad: i32,
	finger: i32,
	x: f32,
	y: f32,
	pressure: f32,
};

export type SDL_ControllerSensorEvent = struct {
	SDL_CommonEvent,
	which: SDL_JoystickID,
	sensor: i32,
	data: [3]f32,
	timestamp_us: u64,
};

export type SDL_AudioDeviceEvent = struct {
	SDL_CommonEvent,
	which: u32,
	iscapture: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
};

export type SDL_TouchFingerEvent = struct {
	SDL_CommonEvent,
	touch_id: SDL_TouchID,
	finger_id: SDL_FingerID,
	x: f32,
	y: f32,
	dx: f32,
	dy: f32,
	pressure: f32,
};

export type SDL_MultiGestureEvent = struct {
	SDL_CommonEvent,
	touch_id: SDL_TouchID,
	dtheta: f32,
	ddist: f32,
	x: f32,
	y: f32,
	num_fingers: u16,
	padding: u16,
};

export type SDL_DollarGestureEvent = struct {
	SDL_CommonEvent,
	touch_id: SDL_TouchID,
	gesture_id: SDL_GestureID,
	num_fingers: u32,
	error: f32,
	x: f32,
	y: f32,
};

export type SDL_DropEvent = struct {
	SDL_CommonEvent,
	file: *c::char,
	window_id: u32,
};

export type SDL_SensorEvent = struct {
	SDL_CommonEvent,
	which: i32,
	data: [6]f32,
};

export type SDL_QuitEvent = struct {
	SDL_CommonEvent,
};

export type SDL_UserEvent = struct {
	SDL_CommonEvent,
	window_id: u32,
	code: i32,
	data1: *opaque,
	data2: *opaque,
};

export type SDL_SysWMEvent = struct {
	SDL_CommonEvent,
	msg: *opaque, // TODO
};

export type SDL_Event = union {
	type_: SDL_EventType,
	common: SDL_CommonEvent,
	display: SDL_DisplayEvent,
	window: SDL_WindowEvent,
	key: SDL_KeyboardEvent,
	edit: SDL_TextEditingEvent,
	editExt: SDL_TextEditingExtEvent,
	text: SDL_TextInputEvent,
	motion: SDL_MouseMotionEvent,
	button: SDL_MouseButtonEvent,
	wheel: SDL_MouseWheelEvent,
	jaxis: SDL_JoyAxisEvent,
	jball: SDL_JoyBallEvent,
	jhat: SDL_JoyHatEvent,
	jbutton: SDL_JoyButtonEvent,
	jdevice: SDL_JoyDeviceEvent,
	caxis: SDL_ControllerAxisEvent,
	cbutton: SDL_ControllerButtonEvent,
	cdevice: SDL_ControllerDeviceEvent,
	ctouchpad: SDL_ControllerTouchpadEvent,
	csensor: SDL_ControllerSensorEvent,
	adevice: SDL_AudioDeviceEvent,
	sensor: SDL_SensorEvent,
	quit: SDL_QuitEvent,
	user: SDL_UserEvent,
	syswm: SDL_SysWMEvent,
	tfinger: SDL_TouchFingerEvent,
	mgesture: SDL_MultiGestureEvent,
	dgesture: SDL_DollarGestureEvent,
	drop: SDL_DropEvent,

	padding: [56]u8,
};

export @symbol("SDL_PumpEvents") fn SDL_PumpEvents() void;

export type SDL_eventaction = enum {
	SDL_ADDEVENT,
	SDL_PEEKEVENT,
	SDL_GETEVENT,
};

export @symbol("SDL_PeepEvents") fn SDL_PeepEvents(events: *SDL_Event, numevents: int, action: SDL_eventaction, mintype: SDL_EventType, maxtype: SDL_EventType) int;
export @symbol("SDL_HasEvent") fn SDL_HasEvent(event_type: SDL_EventType) bool;
export @symbol("SDL_HasEvents") fn SDL_HasEvents(mintype: SDL_EventType, maxtype: SDL_EventType) bool;
export @symbol("SDL_FlushEvent") fn SDL_FlushEvent(event_type: SDL_EventType) void;
export @symbol("SDL_FlushEvents") fn SDL_FlushEvents(mintype: SDL_EventType, maxtype: SDL_EventType) void;
export @symbol("SDL_PollEvent") fn SDL_PollEvent(event: nullable *SDL_Event) int;
export @symbol("SDL_WaitEvent") fn SDL_WaitEvent(event: nullable *SDL_Event) int;
export @symbol("SDL_WaitEventTimeout") fn SDL_WaitEventTimeout(event: nullable *SDL_Event, timeout: int) int;
export @symbol("SDL_PushEvent") fn SDL_PushEvent(event: *SDL_Event) int;

export type SDL_EventFilter = *fn(userdata: *opaque, event: *SDL_Event) int;

export @symbol("SDL_SetEventFilter") fn SDL_SetEventFilter(filter: SDL_EventFilter, userdata: *opaque) void;
export @symbol("SDL_GetEventFilter") fn SDL_GetEventFilter(filter: SDL_EventFilter, userdata: **opaque) bool;
export @symbol("SDL_AddEventWatch") fn SDL_AddEventWatch(filter: SDL_EventFilter, userdata: *opaque) void;
export @symbol("SDL_DelEventWatch") fn SDL_DelEventWatch(filter: SDL_EventFilter, userdata: *opaque) void;
export @symbol("SDL_FilterEvents") fn SDL_FilterEvents(filter: SDL_EventFilter, userdata: *opaque) void;

export def SDL_QUERY = -1;
export def SDL_IGNORE = 0;
export def SDL_DISABLE = 0;
export def SDL_ENABLE = 1;

export @symbol("SDL_EventState") fn SDL_EventState(event_type: SDL_EventType, state: int) u8;
export @symbol("SDL_RegisterEvents") fn SDL_RegisterEvents(numevents: int) u32;
