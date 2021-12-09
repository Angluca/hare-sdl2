// TODO: Flesh me out

// The structure that defines a point (integer)
export type point = struct {
	x: int,
	y: int,
};

// The structure that defines a point (floating point)
export type fpoint = struct {
	x: f32,
	y: f32,
};

// A rectangle, with the origin at the upper left (integer).
export type rect = struct {
	x: int,
	y: int,
	w: int,
	h: int,
};

// A rectangle, with the origin at the upper left (floating point).
export type frect = struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
};
