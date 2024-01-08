use types::c;

export type SDL_hid_device = opaque;

export type SDL_hid_device_info = struct {
	path: *c::char,
	vendor_id: u16,
	product_id: u16,
	serial_number: *i32,
	release_number: u16,
	manufacturer_string: *i32,
	product_string: *i32,
	usage_page: u16,
	usage: u16,
	interface_number: int,
	interface_class: int,
	interface_subclass: int,
	interface_protocol: int,
	next: nullable *SDL_hid_device_info,
};

export @symbol("SDL_hid_init") fn SDL_hid_init() int;
export @symbol("SDL_hid_exit") fn SDL_hid_exit() int;
export @symbol("SDL_hid_device_change_count") fn SDL_hid_device_change_count() u32;
export @symbol("SDL_hid_enumerate") fn SDL_hid_enumerate(vendor_id: i16, product_id: i16) nullable *SDL_hid_device_info;
export @symbol("SDL_hid_free_enumeration") fn SDL_hid_free_enumeration(devs: *SDL_hid_device_info) void;
export @symbol("SDL_hid_open") fn SDL_hid_open(vendor_id: i16, product_id: i16, serial_number: nullable *i32) nullable *SDL_hid_device;
export @symbol("SDL_hid_open_path") fn SDL_hid_open_path(path: *c::char, bExclusive: int) nullable *SDL_hid_device;
export @symbol("SDL_hid_write") fn SDL_hid_write(dev: *SDL_hid_device, data: *c::char, length: size) int;
export @symbol("SDL_hid_read_timeout") fn SDL_hid_read_timeout(dev: *SDL_hid_device, data: *c::char, length: size, milliseconds: int) int;
export @symbol("SDL_hid_read") fn SDL_hid_read(dev: *SDL_hid_device, data: *c::char, length: size) int;
export @symbol("SDL_hid_set_nonblocking") fn SDL_hid_set_nonblocking(dev: *SDL_hid_device, nonblock: int) int;
export @symbol("SDL_hid_send_feature_report") fn SDL_hid_send_feature_report(dev: *SDL_hid_device, data: *c::char, length: size) int;
export @symbol("SDL_hid_get_feature_report") fn SDL_hid_get_feature_report(dev: *SDL_hid_device, data: *c::char, length: size) int;
export @symbol("SDL_hid_close") fn SDL_hid_close(dev: *SDL_hid_device) void;
export @symbol("SDL_hid_get_manufacturer_string") fn SDL_hid_get_manufacturer_string(dev: *SDL_hid_device, string: *i32, maxlen: size) int;
export @symbol("SDL_hid_get_product_string") fn SDL_hid_get_product_string(dev: *SDL_hid_device, string: *i32, maxlen: size) int;
export @symbol("SDL_hid_get_serial_number_string") fn SDL_hid_get_serial_number_string(dev: *SDL_hid_device, string: *i32, maxlen: size) int;
export @symbol("SDL_hid_get_indexed_string") fn SDL_hid_get_indexed_string(dev: *SDL_hid_device, string_index: int, string: *i32, maxlen: size) int;
export @symbol("SDL_hid_ble_scan") fn SDL_hid_ble_scan(active: bool) void;
