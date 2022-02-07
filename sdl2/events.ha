export type event_type = enum u32 {
	FIRSTEVENT = 0,

	QUIT = 0x100,

	APP_TERMINATING,
	APP_LOWMEMORY,
	APP_WILLENTERBACKGROUND,
	APP_DIDENTERBACKGROUND,
	APP_WILLENTERFOREGROUND,
	APP_DIDENTERFOREGROUND,

	DISPLAYEVENT = 0x150,

	WINDOWEVENT = 0x200,
	SYSWMEVENT,

	KEYDOWN = 0x300,
	KEYUP,
	TEXTEDITING,
	TEXTINPUT,
	KEYMAPCHANGED,

	MOUSEMOTION = 0x400,
	MOUSEBUTTONDOWN,
	MOUSEBUTTONUP,
	MOUSEWHEEL,

	JOYAXISMOTION = 0x600,
	JOYBALLMOTION,
	JOYHATMOTION,
	JOYBUTTONDOWN,
	JOYBUTTONUP,
	JOYDEVICEADDED,
	JOYDEVICEREMOVED,

	CONTROLLERAXISMOTION = 0x650,
	CONTROLLERBUTTONDOWN,
	CONTROLLERBUTTONUP,
	CONTROLLERDEVICEADDED,
	CONTROLLERDEVICEREMOVED,
	CONTROLLERDEVICEREMAPPED,

	FINGERDOWN = 0x700,
	FINGERUP,
	FINGERMOTION,

	DOLLARGESTURE = 0x800,
	DOLLARRECORD,
	MULTIGESTURE,

	CLIPBOARDUPDATE = 0x900,

	DROPFILE = 0x1000,
	DROPTEXT,
	DROPBEGIN,
	DROPCOMPLETE,

	AUDIODEVICEADDED = 0x1100,
	AUDIODEVICEREMOVED,

	SENSORUPDATE = 0x1200,

	RENDER_TARGETS_RESET = 0x2000,
	RENDER_DEVICE_RESET,

	USEREVENT = 0x8000,

	LASTEVENT = 0xFFFF
};

// Fields shared by every event
export type common_event = struct {
	event_type: event_type,
	timestamp: u32,
};

// Display state change event data (event.display.*)
export type display_event = struct {
	common_event,
	display: u32,
	event: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	data1: i32,
};

// Window state change event data (event.window.*)
export type window_event = struct {
	common_event,
	window_id: u32,
	event: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	data1: i32,
	data2: i32,
};

// Keyboard button event structure (event.key.*)
export type keyboard_event = struct {
	common_event,
	window_id: u32,
	state: u8,
	repeat: u8,
	padding2: u8,
	padding3: u8,
	keysym: keysym,
};

// Size of the [[text_editing_event]] 'text' field.
export def TEXTEDITINGEVENT_TEXT_SIZE: size = 32;

// Keyboard text editing event structure (event.edit.*)
export type text_editing_event = struct {
	common_event,
	window_id: u32,
	text: [TEXTEDITINGEVENT_TEXT_SIZE]char,
	start: i32,
	length: i32,
};

// Size of the [[text_input_event]] 'text' field.
export def TEXTINPUTEVENT_TEXT_SIZE: size = 32;

// Keyboard text input event structure (event.text.*)
export type text_input_event = struct {
	common_event,
	window_id: u32,
	text: [TEXTINPUTEVENT_TEXT_SIZE]char,
};

// Mouse motion event structure (event.motion.*)
export type mouse_motion_event = struct {
	common_event,
	window_id: u32,
	which: u32,
	state: u32,
	x: i32,
	y: i32,
	xrel: i32,
	yrel: i32,
};

// Mouse button event structure (event.button.*)
export type mouse_button_event = struct {
	common_event,
	window_id: u32,
	which: u32,
	button: u8,
	state: u8,
	clicks: u8,
	padding1: u8,
	x: i32,
	y: i32,
};

// Mouse wheel event structure (event.wheel.*)
export type mouse_wheel_event = struct {
	common_event,
	window_id: u32,
	which: u32,
	x: i32,
	y: i32,
	direction: u32,
};

// Joystick axis motion event structure (event.jaxis.*)
export type joy_axis_event = struct {
	common_event,
	which: i32, // TODO: Rig me up with the JoystickID type
	axis: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	value: i16,
	padding4: u16,
};

// Joystick trackball motion event structure (event.jball.*)
export type joy_ball_event = struct {
	common_event,
	which: i32, // TODO: Rig me up with the JoystickID type
	ball: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	xrel: i16,
	yrel: i16,
};

// Joystick hat position change event structure (event.jhat.*)
export type joy_hat_event = struct {
	common_event,
	which: i32, // TODO: Rig me up with the JoystickID type
	hat: u8,
	value: u8, // TODO: Rig me up with HAT_UP et al
	padding1: u8,
	padding2: u8,
};

// Joystick button event structure (event.jbutton.*)
export type joy_button_event = struct {
	common_event,
	which: i32, // TODO: Rig me up with the JoystickID type
	button: u8,
	state: u8,
	padding1: u8,
	padding2: u8,
};

// Joystick device event structure (event.jdevice.*)
export type joy_device_event = struct {
	common_event,
	which: i32,
};

// Game controller axis motion event structure (event.caxis.*)
export type controller_axis_event = struct {
	common_event,
	which: i32, // TODO
	axis: controller_axis,
	padding1: u8,
	padding2: u8,
	padding3: u8,
	value: i16,
	padding4: u16,
};

// Game controller button event structure (event.cbutton.*)
export type controller_button_event = struct {
	common_event,
	which: i32,
	button: u8,
	state: u8,
	padding1: u8,
	padding2: u8,
};

// Controller device event structure (event.cdevice.*)
export type controller_device_event = struct {
	common_event,
	which: i32,
};

// Audio device event structure (event.adevice.*)
export type audio_device_event = struct {
	common_event,
	which: u32,
	iscapture: u8,
	padding1: u8,
	padding2: u8,
	padding3: u8,
};

// Touch finger event structure (event.tfinger.*)
export type touch_finger_event = struct {
	common_event,
	touch_id: i64, // TODO
	finger_id: i64, // TODO
	x: f32,
	y: f32,
	dx: f32,
	dy: f32,
	pressure: f32,
};

// Multiple Finger Gesture Event (event.mgesture.*)
export type multi_gesture_event = struct {
	common_event,
	touch_id: i64, // TODO
	dtheta: f32,
	ddist: f32,
	x: f32,
	y: f32,
	num_fingers: u16,
	padding: u16,
};

// Dollar Gesture Event (event.dgesture.*)
export type dollar_gesture_event = struct {
	common_event,
	touch_id: i64, // TODO
	gesture_id: i64, // TODO
	num_fingers: u32,
	error: f32,
	x: f32,
	y: f32,
};

// An event used to request a file open by the system (event.drop.*)
// This event is enabled by default, you can disable it with [[eventstate]].
// If this event is enabled, you must free the filename in the event.
export type drop_event = struct {
	common_event,
	file: *char,
	window_id: u32,
};

// Sensor event structure (event.sensor.*)
export type sensor_event = struct {
	common_event,
	which: i32,
	data: [6]f32,
};

// The "quit requested" event
export type quit_event = struct {
	common_event,
};

// OS Specific event
export type os_event = struct {
	common_event,
};

// A user-defined event type (event.user.*)
export type user_event = struct {
	common_event,
	window_id: u32,
	code: i32,
	data1: *void,
	data2: *void,
};

// A video driver dependent system event (event.syswm.*)
// This event is disabled by default, you can enable it with [[eventstate]].
export type syswm_event = struct {
	common_event,
	msg: *void, // TODO
};

// General event structure
export type event = union {
	event_type: event_type,
	common: common_event,
	display: display_event,
	window: window_event,
	key: keyboard_event,
	edit: text_editing_event,
	text: text_input_event,
	motion: mouse_motion_event,
	button: mouse_button_event,
	wheel: mouse_wheel_event,
	jaxis: joy_axis_event,
	jball: joy_ball_event,
	jhat: joy_hat_event,
	jbutton: joy_button_event,
	jdevice: joy_device_event,
	caxis: controller_axis_event,
	cbutton: controller_button_event,
	cdevice: controller_device_event,
	adevice: audio_device_event,
	sensor: sensor_event,
	quit: quit_event,
	user: user_event,
	syswm: syswm_event,
	tfinger: touch_finger_event,
	mgesture: multi_gesture_event,
	dgestures: dollar_gesture_event,
	drop: drop_event,

	padding: [56]u8,
};

// Pumps the event loop, gathering events from the input devices.
//
// This function updates the event queue and internal input device state.
//
// This should only be run in the thread that sets the video mode.
export @symbol("SDL_PumpEvents") fn pump_events() void;

export type eventaction = enum {
	ADDEVENT,
	PEEKEVENT,
	GETEVENT,
};

@symbol("SDL_PeepEvents") fn _peep_events(events: *event, numevents: int,
	action: eventaction, mintype: event_type, maxtype: event_type) int;

// Checks the event queue for messages and optionally returns them.
//
// If 'action' is ADDEVENT, up to 'numevents' events will be added to the back
// of the event queue.
//
// If 'action' is PEEKEVENT, up to 'numevents' events at the front of the event
// queue, within the specified minimum and maximum type, will be returned and
// will not be removed from the queue.
//
// If 'action' is GETEVENT, up to 'numevents' events at the front of the event
// queue, within the specified minimum and maximum type, will be returned and
// will be removed from the queue.
//
// This function is thread-safe.
export fn peep_events(
	events: *event,
	numevents: int,
	action: eventaction,
	mintype: event_type,
	maxtype: event_type,
) (int | error) = {
	return wrapint(_peep_events(events, numevents, action, mintype, maxtype));
};

// Checks to see if certain event types are in the event queue.
export @symbol("SDL_HasEvent") fn has_event(event_type: event_type) bool;

// Checks to see if certain event types are in the event queue.
export @symbol("SDL_HasEvents") fn has_events(mintype: event_type, maxtype: event_type) bool;

// This function clears events from the event queue
// This function only affects currently queued events. If you want to make
// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
// on the main thread immediately before the flush call.
export @symbol("SDL_FlushEvent") fn flush_event(event_type: event_type) void;

// This function clears events from the event queue
// This function only affects currently queued events. If you want to make
// sure that all pending OS events are flushed, you can call SDL_PumpEvents()
// on the main thread immediately before the flush call.
export @symbol("SDL_FlushEvents") fn flush_events(mintype: event_type, maxtype: event_type) void;

@symbol("SDL_PollEvent") fn _poll_event(event: nullable *event) int;

// Polls for currently pending events.
//
// Returns 1 if there are any pending events, or 0 if there are none available.
//
// If 'event' is not null, the next event is removed from the queue and stored
// in that area.
export fn poll_event(event: nullable *event) (int | error) = {
	return wrapint(_poll_event(event));
};

@symbol("SDL_WaitEvent") fn _wait_event(event: nullable *event) int;

// Waits indefinitely for the next available event.
//
// If 'event' is not null, the next event is removed from the queue and stored
// in that area.
export fn wait_event(event: nullable *event) (void | error) = {
	return wrapvoid(_wait_event(event));
};

@symbol("SDL_WaitEventTimeout") fn _wait_event_timeout(
	event: nullable *event, timeout: int) int;

// Waits until the specified timeout (in milliseconds) for the next available event.
// 
// If 'event' is not null, the next event is removed from the queue and stored
// in that area. The 'timeout' is the time (in milliseconds) to wait for next
// event.
export fn wait_event_timeout(
	event: nullable *event,
	timeout: int,
) (void | error) = {
	return wrapvoid(_wait_event_timeout(event, timeout));
};

@symbol("SDL_PushEvent") fn _push_event(event: *event) int;

// Add an event to the event queue.
export fn push_event(event: *event) (void | error) = {
	return wrapvoid(_push_event(event));
};

// TODO: Finish rigging up other SDL_events.h bits
