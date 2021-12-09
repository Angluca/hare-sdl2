use fmt;
use os;
use sdl2::{event_type, window_flags, renderer_flags};
use sdl2;
use sdl2::image;
use strings;

type state = struct {
	hare: *sdl2::texture,
	cat: *sdl2::texture,
	hare_x: int,
	hare_y: int,
	cat_x: int,
	cat_y: int,
};

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO);
	defer sdl2::quit();
	let flags = image::init(image::init_flags::PNG | image::init_flags::JPG);
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

	let state = state {
		hare = {
			const path = strings::to_c("mascot.jpg");
			defer free(path);
			yield match (image::load_texture(render, path)) {
			case let tex: *sdl2::texture =>
				yield tex;
			case null =>
				fmt::fatal("sdl2::image::load_texture failed for mascot.jpg");
			};
		},
		cat = {
			const path = strings::to_c("cat.png");
			defer free(path);
			yield match (image::load_texture(render, path)) {
			case let tex: *sdl2::texture =>
				yield tex;
			case null =>
				fmt::fatal("sdl2::image::load_texture failed for cat.png");
			};
		},
		hare_x = 100,
		hare_y = 100,
		...
	};
	defer sdl2::destroy_texture(state.hare);
	defer sdl2::destroy_texture(state.cat);

	draw_frame(&state, render);

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

fn draw_frame(state: *state, render: *sdl2::renderer) void = {
	sdl2::set_render_draw_color(render, 50, 50, 50, 255);
	sdl2::render_clear(render);
	draw_tex(render, state.cat, state.cat_x, state.cat_y);
	draw_tex(render, state.hare, state.hare_x, state.hare_y);
	sdl2::render_present(render);
};

fn draw_tex(
	render: *sdl2::renderer,
	tex: *sdl2::texture,
	x: int,
	y: int,
) void = {
	let width = 0, height = 0;
	sdl2::query_texture(tex, null, null, &width, &height);
	sdl2::render_copy(render, tex, null, &sdl2::rect {
		x = x,
		y = y,
		w = width,
		h = height,
	});
};
