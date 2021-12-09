use fmt;
use os;
use sdl2::{event_type, window_flags, renderer_flags};
use sdl2;
use strings;

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO);
	defer sdl2::quit();

	const title = strings::to_c("Hare SDL2 demo");
	defer free(title);
	const win = match (sdl2::create_window(title,
		sdl2::WINDOWPOS_UNDEFINED, sdl2::WINDOWPOS_UNDEFINED,
		640, 480, window_flags::NONE)) {
	case let win: *sdl2::window =>
		yield win;
	case null =>
		fmt::fatal("sdl2::create_window failed");
	};
	defer sdl2::destroy_window(win);

	const render = match (sdl2::create_renderer(win, -1, renderer_flags::NONE)) {
	case let rend: *sdl2::renderer =>
		yield rend;
	case null =>
		fmt::fatal("sdl2::create_renderer failed");
	};
	defer sdl2::destroy_renderer(render);

	sdl2::set_render_draw_color(render, 255, 0, 0, 255);
	sdl2::render_clear(render);
	sdl2::render_present(render);

	let ev = sdl2::event { ... };
	for (sdl2::wait_event(&ev) == 1) {
		switch (ev.event_type) {
		case event_type::QUIT =>
			break;
		case => void;
		};
	};

	os::exit(0); // https://todo.sr.ht/~sircmpwn/hare/525
};
