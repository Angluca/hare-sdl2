use fmt;
use os;
use sdl2::{event_type, window_flags, renderer_flags};
use sdl2;
use sdl2::image;
use strings;

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO);
	defer sdl2::quit();
	image::init(image::init_flags::PNG);
	defer image::quit();

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

	const path = strings::to_c("cat.png");
	defer free(path);
	const texture = match (image::load_texture(render, path)) {
	case let tex: *sdl2::texture =>
		yield tex;
	case null =>
		fmt::fatal("sdl2::image::load_texture failed");
	};
	defer sdl2::destroy_texture(texture);

	let width = 0, height = 0;
	sdl2::query_texture(texture, null, null, &width, &height);

	sdl2::set_render_draw_color(render, 50, 50, 50, 255);
	sdl2::render_clear(render);
	sdl2::render_copy(render, texture, null, &sdl2::rect {
		x = 0,
		y = 0,
		w = width,
		h = height,
	});
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
