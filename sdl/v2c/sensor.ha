use types::c;

export type SDL_Sensor = opaque;

export type SDL_SensorID = i32;

export type SDL_SensorType = enum {
	SDL_SENSOR_INVALID = -1,
	SDL_SENSOR_UNKNOWN,
	SDL_SENSOR_ACCEL,
	SDL_SENSOR_GYRO,
	SDL_SENSOR_ACCEL_L,
	SDL_SENSOR_GYRO_L,
	SDL_SENSOR_ACCEL_R,
	SDL_SENSOR_GYRO_R,
};

export def SDL_STANDARD_GRAVITY = 9.80665f32;

export @symbol("SDL_LockSensors") fn SDL_LockSensors() void;
export @symbol("SDL_UnlockSensors") fn SDL_UnlockSensors() void;
export @symbol("SDL_NumSensors") fn SDL_NumSensors() int;
export @symbol("SDL_SensorGetDeviceName") fn SDL_SensorGetDeviceName(device_index: int) nullable *c::char;
export @symbol("SDL_SensorGetDeviceType") fn SDL_SensorGetDeviceType(device_index: int) SDL_SensorType;
export @symbol("SDL_SensorGetDeviceNonPortableType") fn SDL_SensorGetDeviceNonPortableType(device_index: int) int;
export @symbol("SDL_SensorGetDeviceInstanceID") fn SDL_SensorGetDeviceInstanceID(device_index: int) SDL_SensorID;
export @symbol("SDL_SensorOpen") fn SDL_SensorOpen(device_index: int) nullable *SDL_Sensor;
export @symbol("SDL_SensorFromInstanceID") fn SDL_SensorFromInstanceID(instance_id: SDL_SensorID) nullable *SDL_Sensor;
export @symbol("SDL_SensorGetName") fn SDL_SensorGetName(sensor: nullable *SDL_Sensor) nullable *c::char;
export @symbol("SDL_SensorGetType") fn SDL_SensorGetType(sensor: nullable *SDL_Sensor) SDL_SensorType;
export @symbol("SDL_SensorGetNonPortableType") fn SDL_SensorGetNonPortableType(sensor: nullable *SDL_Sensor) int;
export @symbol("SDL_SensorGetInstanceID") fn SDL_SensorGetInstanceID(sensor: nullable *SDL_Sensor) SDL_SensorID;
export @symbol("SDL_SensorGetData") fn SDL_SensorGetData(sensor: *SDL_Sensor, data: *f32, num_values: int) int;
export @symbol("SDL_SensorGetDataWithTimestamp") fn SDL_SensorGetDataWithTimestamp(sensor: *SDL_Sensor, timestamp: *u64, data: *f32, num_values: int) int;
export @symbol("SDL_SensorClose") fn SDL_SensorClose(sensor: *SDL_Sensor) void;
export @symbol("SDL_SensorUpdate") fn SDL_SensorUpdate() void;
