// Draw a black window.
use types::c;
use sdl::v2c::*;

export fn main() void = {
	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
		abort(c::tostr(SDL_GetError())!);
	};
	defer SDL_Quit();

	const title = c::fromstr("hi");
	defer free(title);
	const window = match (SDL_CreateWindow(title,
		SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
		800, 600, SDL_WindowFlags::SDL_WINDOW_RESIZABLE)) {
	case null =>
		abort(c::tostr(SDL_GetError())!);
	case let w: *SDL_Window =>
		yield w;
	};
	defer SDL_DestroyWindow(window);

	const renderer = match (SDL_CreateRenderer(window, -1,
		SDL_RendererFlags::SDL_RENDERER_PRESENTVSYNC)) {
	case null =>
		abort(c::tostr(SDL_GetError())!);
	case let r: *SDL_Renderer =>
		yield r;
	};
	defer SDL_DestroyRenderer(renderer);

	for :loop (true) {
		let ev = SDL_Event { ... };
		for (SDL_PollEvent(&ev) == 1) switch (ev.type_) {
		case SDL_EventType::SDL_QUIT =>
			break :loop;
		case => void;
		};

		assert(SDL_RenderClear(renderer) == 0);
		SDL_RenderPresent(renderer);
	};
};
