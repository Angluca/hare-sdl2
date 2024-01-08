use types::c;

export type SDL_Haptic = opaque;

export def SDL_HAPTIC_CONSTANT = 1u<<0;
export def SDL_HAPTIC_SINE = 1u<<1;
export def SDL_HAPTIC_LEFTRIGHT = 1u<<2;
export def SDL_HAPTIC_TRIANGLE = 1u<<3;
export def SDL_HAPTIC_SAWTOOTHUP = 1u<<4;
export def SDL_HAPTIC_SAWTOOTHDOWN = 1u<<5;
export def SDL_HAPTIC_RAMP = 1u<<6;
export def SDL_HAPTIC_SPRING = 1u<<7;
export def SDL_HAPTIC_DAMPER = 1u<<8;
export def SDL_HAPTIC_INERTIA = 1u<<9;
export def SDL_HAPTIC_FRICTION = 1u<<10;
export def SDL_HAPTIC_CUSTOM = 1u<<11;
export def SDL_HAPTIC_GAIN = 1u<<12;
export def SDL_HAPTIC_AUTOCENTER = 1u<<13;
export def SDL_HAPTIC_STATUS = 1u<<14;
export def SDL_HAPTIC_PAUSE = 1u<<15;

export def SDL_HAPTIC_POLAR = 0;
export def SDL_HAPTIC_CARTESIAN = 1;
export def SDL_HAPTIC_SPHERICAL = 2;
export def SDL_HAPTIC_STEERING_AXIS = 3;

export def SDL_HAPTIC_INFINITY = 4294967295u32;

export type SDL_HapticDirection = struct {
	type_: u8,
	dir: [3]i32,
};

export type SDL_HapticConstant = struct {
	type_: u16,
	direction: SDL_HapticDirection,
	length: u32,
	delay: u16,
	button: u16,
	interval: u16,
	level: i16,
	attack_length: u16,
	attack_level: u16,
	fade_length: u16,
	fade_level: u16,
};

export type SDL_HapticPeriodic = struct {
	type_: u16,
	direction: SDL_HapticDirection,
	length: u32,
	delay: u16,
	button: u16,
	interval: u16,
	period: u16,
	magnitude: i16,
	offset_: i16,
	phase: u16,
	attack_length: u16,
	attack_level: u16,
	fade_length: u16,
	fade_level: u16,
};

export type SDL_HapticCondition = struct {
	type_: u16,
	direction: SDL_HapticDirection,
	length: u32,
	delay: u16,
	button: u16,
	interval: u16,
	right_sat: [3]u16,
	left_sat: [3]u16,
	right_coeff: [3]i16,
	left_coeff: [3]i16,
	deadband: [3]u16,
	center: [3]i16,
};

export type SDL_HapticRamp = struct {
	type_: u16,
	direction: SDL_HapticDirection,
	length: u32,
	delay: u16,
	button: u16,
	interval: u16,
	start: i16,
	end: i16,
	attack_length: u16,
	attack_level: u16,
	fade_length: u16,
	fade_level: u16,
};

export type SDL_HapticLeftRight = struct {
	type_: u16,
	length: u32,
	large_magnitude: u16,
	small_magnitude: u16,
};

export type SDL_HapticCustom = struct {
	type_: u16,
	direction: SDL_HapticDirection,
	length: u32,
	delay: u16,
	button: u16,
	interval: u16,
	channels: u8,
	period: u16,
	samples: u16,
	data: *u16,
	attack_length: u16,
	attack_level: u16,
	fade_length: u16,
	fade_level: u16,
};

export type SDL_HapticEffect = union {
    type_: u16,
    constant: SDL_HapticConstant,
    periodic: SDL_HapticPeriodic,
    condition: SDL_HapticCondition,
    ramp: SDL_HapticRamp,
    leftright: SDL_HapticLeftRight,
    custom: SDL_HapticCustom,
};

export @symbol("SDL_NumHaptics") fn SDL_NumHaptics() int;
export @symbol("SDL_HapticName") fn SDL_HapticName(device_index: int) nullable *c::char;
export @symbol("SDL_HapticOpen") fn SDL_HapticOpen(device_index: int) nullable *SDL_Haptic;
export @symbol("SDL_HapticOpened") fn SDL_HapticOpened(device_index: int) int;
export @symbol("SDL_HapticIndex") fn SDL_HapticIndex(haptic: *SDL_Haptic) int;
export @symbol("SDL_MouseIsHaptic") fn SDL_MouseIsHaptic() int;
export @symbol("SDL_HapticOpenFromMouse") fn SDL_HapticOpenFromMouse() nullable *SDL_Haptic;
export @symbol("SDL_JoystickIsHaptic") fn SDL_JoystickIsHaptic(joystick: *SDL_Joystick) int;
export @symbol("SDL_HapticOpenFromJoystick") fn SDL_HapticOpenFromJoystick(joystick: *SDL_Joystick) nullable *SDL_Haptic;
export @symbol("SDL_HapticClose") fn SDL_HapticClose(haptic: *SDL_Haptic) void;
export @symbol("SDL_HapticNumEffects") fn SDL_HapticNumEffects(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticNumEffectsPlaying") fn SDL_HapticNumEffectsPlaying(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticQuery") fn SDL_HapticQuery(haptic: *SDL_Haptic) uint;
export @symbol("SDL_HapticNumAxes") fn SDL_HapticNumAxes(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticEffectSupported") fn SDL_HapticEffectSupported(haptic: *SDL_Haptic, effect: *SDL_HapticEffect) int;
export @symbol("SDL_HapticNewEffect") fn SDL_HapticNewEffect(haptic: *SDL_Haptic, effect: *SDL_HapticEffect) int;
export @symbol("SDL_HapticUpdateEffect") fn SDL_HapticUpdateEffect(haptic: *SDL_Haptic, effect: int, data: *SDL_HapticEffect) int;
export @symbol("SDL_HapticRunEffect") fn SDL_HapticRunEffect(haptic: *SDL_Haptic, effect: int, iterations: u32) int;
export @symbol("SDL_HapticStopEffect") fn SDL_HapticStopEffect(haptic: *SDL_Haptic, effect: int) int;
export @symbol("SDL_HapticDestroyEffect") fn SDL_HapticDestroyEffect(haptic: *SDL_Haptic, effect: int) void;
export @symbol("SDL_HapticGetEffectStatus") fn SDL_HapticGetEffectStatus(haptic: *SDL_Haptic, effect: int) int;
export @symbol("SDL_HapticSetGain") fn SDL_HapticSetGain(haptic: *SDL_Haptic, gain: int) int;
export @symbol("SDL_HapticSetAutocenter") fn SDL_HapticSetAutocenter(haptic: *SDL_Haptic, autocenter: int) int;
export @symbol("SDL_HapticPause") fn SDL_HapticPause(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticUnpause") fn SDL_HapticUnpause(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticStopAll") fn SDL_HapticStopAll(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticRumbleSupported") fn SDL_HapticRumbleSupported(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticRumbleInit") fn SDL_HapticRumbleInit(haptic: *SDL_Haptic) int;
export @symbol("SDL_HapticRumblePlay") fn SDL_HapticRumblePlay(haptic: *SDL_Haptic, strength: f32, length: u32) int;
export @symbol("SDL_HapticRumbleStop") fn SDL_HapticRumbleStop(haptic: *SDL_Haptic) int;
