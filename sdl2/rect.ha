// TODO: Flesh me out

// The structure that defines a point (integer)
export type SDL_Point = struct {
	x: int,
	y: int,
};

// The structure that defines a point (floating point)
export type SDL_FPoint = struct {
	x: f32,
	y: f32,
};

// A rectangle, with the origin at the upper left (integer).
export type SDL_Rect = struct {
	x: int,
	y: int,
	w: int,
	h: int,
};

// A rectangle, with the origin at the upper left (floating point).
export type SDL_FRect = struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
};
