use sdl::v2c::*;

// Fields shared by every event.
export type event_common = struct {
	timestamp: u32, // In milliseconds, populated using [[get_ticks]].
};

// Fields common to all display events.
export type display_event_common = struct {
	event_common,
	display: u32, // The associated display index.
};

// Display has been added to the system.
export type display_connected = display_event_common;

// Display has been removed from the system.
export type display_disconnected = display_event_common;

// Display has changed position.
export type display_moved = display_event_common;

// Display orientation has changed.
export type display_orientation_changed = struct {
	common: display_event_common, // XXX try to remove this common
	orientation: display_orientation, // The new orientation.
};

// Fields common to all window events.
export type window_event_common = struct {
	event_common,
	window_id: u32, // The associated window.
};

// Window has been shown.
export type window_shown = window_event_common;

// Window has been hidden.
export type window_hidden = window_event_common;

// Window has been exposed.
export type window_exposed = window_event_common;

// Window has been moved.
export type window_moved = struct {
	common: window_event_common, // XXX try to remove this common
	x: int, // New x.
	y: int, // New y.
};

// Window has been resized.
export type window_resized = struct {
	common: window_event_common, // XXX try to remove this common
	w: int, // New w.
	h: int, // New h.
};

// The window size has changed, either as a result of an API call or through the
// system or user changing the window size.
export type window_size_changed = struct {
	common: window_event_common, // XXX try to remove this common
	w: int, // New w.
	h: int, // New h.
};

// Window has been minimized.
export type window_minimized = window_event_common;

// Window has been maximized.
export type window_maximized = window_event_common;

// Window has been restored to normal size and position.
export type window_restored = window_event_common;

// Window has gained mouse focus.
export type window_entered = window_event_common;

// Window has lost mouse focus.
export type window_left = window_event_common;

// Window has gained keyboard focus.
export type window_focus_gained = window_event_common;

// Window has lost keyboard focus.
export type window_focus_lost = window_event_common;

// The window manager requests that the window be closed.
export type window_closed = window_event_common;

// The window is being offered a focus (should [[set_window_input_focus]] on
// itself or a subwindow, or ignore.
export type window_take_focus = window_event_common;

// Window had a hit test that wasn't NORMAL.
export type window_hit_test = window_event_common;

// The ICC profile of the window's display has changed.
export type window_iccprof_changed = window_event_common;

// Window has been moved to a new display.
export type window_display_changed = struct {
	common: window_event_common, // XXX try to remove this common
	display: int, // The new display.
};

// A keyboard key was pressed.
export type key_pressed = struct {
	event_common,
	window_id: u32, // The window with keyboard focus, if any.
	repeat: bool, // Whether this is a key repeat or not.
	keysym: keysym, // The key that was pressed.
};

// A keyboard key was released.
export type key_released = struct {
	event_common,
	window_id: u32, // The window with keyboard focus, if any.
	keysym: keysym, // The key that was pressed.
};

// The mouse moved.
export type mouse_moved = struct {
	event_common,
	window_id: u32, // The window with mouse focus, if any.
	which: u32, // The mouse instance ID, or TOUCH_MOUSEID.
	state: u32, // The current button state.
	x: i32, // X coordinate, relative to the window.
	y: i32, // Y coordinate, relative to the window.
	xrel: i32, // Relative motion in the x direction.
	yrel: i32, // Relative motion in the y direction.
};

// Common to mouse press and release.
export type mouse_event_common = struct {
	event_common,
	window_id: u32, // The window with mouse focus, if any.
	which: u32, // The mouse instance ID, or TOUCH_MOUSEID.
	button: u8, // Mouse button index.
	clicks: u8, // 1 for single-click, 2 for double-click, etc.
	x: i32, // X coordinate, relative to the window.
	y: i32, // Y coordinate, relative to the window.
};

// Mouse button pressed.
export type mouse_button_pressed = mouse_event_common;

// Mouse button released.
export type mouse_button_released = mouse_event_common;

// Mouse wheel scrolled.
export type mouse_wheel_scrolled = struct {
	event_common,
	window_id: u32, // The window with mouse focus, if any.
	which: u32, // The mouse instance ID, or TOUCH_MOUSEID.
	x: i32, // The amount scrolled horizontally, positive to the right.
	y: i32, // The amount scrolled vertically, positive away from the user.
	precise_x: f32, // Float precision horizontal scroll.
	precise_y: f32, // Float precision vertical scroll.
	mouse_x: i32, // X coordinate relative to window.
	mouse_y: i32, // Y coordinate relative to window.
};

// The "quit requested" event.
export type quit_requested = struct {
	event_common,
};

type event_not_implemented = SDL_EventType;

// General event tagged union.
// TODO: App events, text editing events, joy events, controller events, touch
//       events, clipboard update, drop events, audio events, sensor events,
//       render events, user events.
export type event = (quit_requested | display_connected | display_disconnected
	| display_moved | display_orientation_changed | window_shown
	| window_hidden | window_exposed | window_moved | window_resized
	| window_size_changed | window_minimized | window_maximized
	| window_restored | window_entered | window_left | window_focus_gained
	| window_focus_lost | window_closed | window_take_focus | window_hit_test
	| window_iccprof_changed | window_display_changed | key_pressed
	| key_released | mouse_moved | mouse_button_pressed
	| mouse_button_released | mouse_wheel_scrolled);

// Pump the event loop, gathering events from the input devices.
// 
// This function updates the event queue and internal input device state.
// 
// **WARNING**: This should only be run in the thread that initialized the video
// subsystem, and for extra safety, you should consider only doing those things
// on the main thread in any case.
// 
// [[pump_events]] gathers all the pending input information from devices and
// places it in the event queue. Without calls to [[pump_events]] no events
// would ever be placed on the queue. Often the need for calls to
// [[pump_events]] is hidden from the user since [[poll_event]] and
// wait_event implicitly call [[pump_events]]. However, if you are not
// polling or waiting for events (e.g. you are filtering them), then you must
// call [[pump_events]] to force an event queue update.
export fn pump_events() void = SDL_PumpEvents();

// [[poll_event]] is the favored way of receiving system events since it can be
// done from the main loop and does not suspend the main loop while waiting on
// an event to be posted.
// 
// The common practice is to fully process the event queue once every frame,
// usually as a first step before updating the game's state:
//
//	for :loop (true) {
//		for (true) match (sdl::poll_event()) {
//		case void =>
//			break;
//		case quit_requested =>
//			break :loop;
//		// more cases
//		};
//
//		// update game state, draw the current frame
//	};
//
// Returns an [[event]] or void if there are none in the queue.
export fn poll_event() (void | ...event) = {
	for (true) match (_poll_event()) {
	case void =>
		return void;
	case event_not_implemented =>
		continue;
	case let e: event =>
		return e;
	};
};

fn _poll_event() (void | event_not_implemented | ...event) = {
	const ev = SDL_Event { ... };
	if (SDL_PollEvent(&ev) == 0)
		return void;
	switch (ev.type_) {
	case SDL_EventType::SDL_QUIT =>
		return quit_requested { timestamp = ev.common.timestamp };
	case SDL_EventType::SDL_DISPLAYEVENT =>
		return disp_event(&ev);
	case SDL_EventType::SDL_WINDOWEVENT =>
		return window_event(&ev);
	case SDL_EventType::SDL_KEYDOWN =>
		return key_pressed {
			timestamp = ev.common.timestamp,
			window_id = ev.key.window_id,
			repeat = ev.key.repeat != 0,
			keysym = *(&ev.key.keysym: *keysym),
		};
	case SDL_EventType::SDL_KEYUP =>
		return key_released {
			timestamp = ev.common.timestamp,
			window_id = ev.key.window_id,
			keysym = *(&ev.key.keysym: *keysym),
		};
	case SDL_EventType::SDL_MOUSEMOTION =>
		return mouse_moved {
			timestamp = ev.common.timestamp,
			window_id = ev.motion.window_id,
			which = ev.motion.which,
			state = ev.motion.state,
			x = ev.motion.x,
			y = ev.motion.y,
			xrel = ev.motion.xrel,
			yrel = ev.motion.yrel,
		};
	case SDL_EventType::SDL_MOUSEBUTTONDOWN =>
		return mbc(&ev): mouse_button_pressed;
	case SDL_EventType::SDL_MOUSEBUTTONUP =>
		return mbc(&ev): mouse_button_released;
	case SDL_EventType::SDL_MOUSEWHEEL =>
		return mouse_wheel(&ev);
	case =>
		return ev.type_: event_not_implemented;
	};
};

fn disp_event(ev: *SDL_Event) event = {
	const dc = display_event_common {
		timestamp = ev.common.timestamp,
		display = ev.display.display,
	};
	switch (ev.display.event) {
	case SDL_DisplayEventID::SDL_DISPLAYEVENT_ORIENTATION =>
		return display_orientation_changed {
			common = dc,
			orientation = ev.display.data1: display_orientation,
		};
	case SDL_DisplayEventID::SDL_DISPLAYEVENT_CONNECTED =>
		return dc: display_connected;
	case SDL_DisplayEventID::SDL_DISPLAYEVENT_DISCONNECTED =>
		return dc: display_disconnected;
	case SDL_DisplayEventID::SDL_DISPLAYEVENT_MOVED =>
		return dc: display_moved;
	case => abort("Unknown SDL_DisplayEventID");
	};
};

fn window_event(ev: *SDL_Event) event = {
	const wc = window_event_common {
		timestamp = ev.common.timestamp,
		window_id = ev.window.window_id,
	};
	switch (ev.window.event) {
	case SDL_WindowEventID::SDL_WINDOWEVENT_SHOWN =>
		return wc: window_shown;
	case SDL_WindowEventID::SDL_WINDOWEVENT_HIDDEN =>
		return wc: window_hidden;
	case SDL_WindowEventID::SDL_WINDOWEVENT_EXPOSED =>
		return wc: window_exposed;
	case SDL_WindowEventID::SDL_WINDOWEVENT_MOVED =>
		return window_moved {
			common = wc,
			x = ev.window.data1,
			y = ev.window.data2,
		};
	case SDL_WindowEventID::SDL_WINDOWEVENT_RESIZED =>
		return window_resized {
			common = wc,
			w = ev.window.data1,
			h = ev.window.data2,
		};
	case SDL_WindowEventID::SDL_WINDOWEVENT_SIZE_CHANGED =>
		return window_size_changed {
			common = wc,
			w = ev.window.data1,
			h = ev.window.data2,
		};
	case SDL_WindowEventID::SDL_WINDOWEVENT_MINIMIZED =>
		return wc: window_minimized;
	case SDL_WindowEventID::SDL_WINDOWEVENT_MAXIMIZED =>
		return wc: window_maximized;
	case SDL_WindowEventID::SDL_WINDOWEVENT_RESTORED =>
		return wc: window_restored;
	case SDL_WindowEventID::SDL_WINDOWEVENT_ENTER =>
		return wc: window_entered;
	case SDL_WindowEventID::SDL_WINDOWEVENT_LEAVE =>
		return wc: window_left;
	case SDL_WindowEventID::SDL_WINDOWEVENT_FOCUS_GAINED =>
		return wc: window_focus_gained;
	case SDL_WindowEventID::SDL_WINDOWEVENT_FOCUS_LOST =>
		return wc: window_focus_lost;
	case SDL_WindowEventID::SDL_WINDOWEVENT_CLOSE =>
		return wc: window_closed;
	case SDL_WindowEventID::SDL_WINDOWEVENT_TAKE_FOCUS =>
		return wc: window_take_focus;
	case SDL_WindowEventID::SDL_WINDOWEVENT_HIT_TEST =>
		return wc: window_hit_test;
	case SDL_WindowEventID::SDL_WINDOWEVENT_ICCPROF_CHANGED =>
		return wc: window_iccprof_changed;
	case SDL_WindowEventID::SDL_WINDOWEVENT_DISPLAY_CHANGED =>
		return window_display_changed {
			common = wc,
			display = ev.window.data1,
		};
	case => abort("Unknown SDL_WindowEventID");
	};
};

fn mbc(ev: *SDL_Event) mouse_event_common = {
	return mouse_event_common {
		timestamp = ev.common.timestamp,
		window_id = ev.button.window_id,
		which = ev.button.which,
		button = ev.button.button,
		clicks = ev.button.clicks,
		x = ev.button.x,
		y = ev.button.y,
	};
};

fn mouse_wheel(ev: *SDL_Event) mouse_wheel_scrolled = {
	const flipfac = 1i32;
	if (ev.wheel.direction
			== SDL_MouseWheelDirection::SDL_MOUSEWHEEL_FLIPPED) {
		flipfac = -1;
	};

	return mouse_wheel_scrolled {
		timestamp = ev.common.timestamp,
		window_id = ev.wheel.window_id,
		which = ev.wheel.which,
		x = ev.wheel.x * flipfac,
		y = ev.wheel.y * flipfac,
		precise_x = ev.wheel.preciseX * flipfac: f32,
		precise_y = ev.wheel.preciseY * flipfac: f32,
		mouse_x = ev.wheel.mouseX,
		mouse_y = ev.wheel.mouseY,
	};
};
