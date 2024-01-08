export type SDL_Point = struct {
	x: int,
	y: int,
};

export type SDL_FPoint = struct {
	x: f32,
	y: f32,
};

export type SDL_Rect = struct {
	x: int,
	y: int,
	w: int,
	h: int,
};

export type SDL_FRect = struct {
	x: f32,
	y: f32,
	w: f32,
	h: f32,
};

// there are a number of useful macros in here that we can try to add later.

export @symbol("SDL_HasIntersection") fn SDL_HasIntersection(A: *SDL_Rect, B: *SDL_Rect) bool;
export @symbol("SDL_IntersectRect") fn SDL_IntersectRect(A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) bool;
export @symbol("SDL_UnionRect") fn SDL_UnionRect(A: *SDL_Rect, B: *SDL_Rect, result: *SDL_Rect) void;
export @symbol("SDL_EnclosePoints") fn SDL_EnclosePoints(points: *SDL_Point, count: int, clip: nullable *SDL_Rect, result: *SDL_Rect) bool;
export @symbol("SDL_IntersectRectAndLine") fn SDL_IntersectRectAndLine(rect: *SDL_Rect, X1: *int, Y1: *int, X2: *int, Y2: *int) bool;
export @symbol("SDL_HasIntersectionF") fn SDL_HasIntersectionF(A: *SDL_FRect, B: *SDL_FRect) bool;
export @symbol("SDL_IntersectFRect") fn SDL_IntersectFRect(A: *SDL_FRect, B: *SDL_FRect, result: *SDL_FRect) bool;
export @symbol("SDL_UnionFRect") fn SDL_UnionFRect(A: *SDL_FRect, B: *SDL_FRect, result: *SDL_FRect) void;
export @symbol("SDL_EncloseFPoints") fn SDL_EncloseFPoints(points: *SDL_FPoint, count: int, clip: nullable *SDL_FRect, result: *SDL_FRect) bool;
export @symbol("SDL_IntersectFRectAndLine") fn SDL_IntersectFRectAndLine(rect: *SDL_FRect, X1: *f32, Y1: *f32, X2: *f32, Y2: *f32) bool;
