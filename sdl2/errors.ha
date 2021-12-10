use strings;

// Returned when an error occurs in an SDL function.
export type error = !str;

// Converts an SDL error into a human-friendly string.
export fn strerror(err: error) str = {
	return err: str;
};

@symbol("SDL_GetError") fn geterror() const *char;

export fn wrapvoid(ret: int) (void | error) = {
	wrapint(ret)?;
};

export fn wrapint(ret: int) (int | error) = {
	if (ret < 0) {
		return strings::fromc(geterror()): error;
	};
	return ret;
};

export fn wrapptr(ret: nullable *void) (*void | error) = {
	match (ret) {
	case let v: *void =>
		return v;
	case null =>
		return strings::fromc(geterror()): error;
	};
};
