use fmt;
use os;
use sdl2::{event_type, window_flags, renderer_flags};
use sdl2;
use sdl2::image;
use strings;

type texture = struct {
	tex: *sdl2::texture,
	w: int,
	h: int,
};

type state = struct {
	window: *sdl2::window,
	render: *sdl2::renderer,
	hare: texture,
	cat: texture,
	hare_x: int,
	hare_y: int,
	hare_dx: int,
	hare_dy: int,
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
		window = win,
		render = render,
		hare = load_texture(render, "mascot.jpg"),
		cat = load_texture(render, "cat.png"),
		hare_x = 100,
		hare_y = 100,
		hare_dx = 2,
		hare_dy = 2,
		...
	};
	defer sdl2::destroy_texture(state.hare.tex);
	defer sdl2::destroy_texture(state.cat.tex);

	let ev = sdl2::event { ... };
	for (true) {
		if (sdl2::poll_event(&ev) == 1) switch (ev.event_type) {
		case event_type::QUIT =>
			break;
		case => void;
		};

		update(&state);
		draw(&state);

		sdl2::delay(1000 / 60);
	};

	os::exit(0); // https://todo.sr.ht/~sircmpwn/hare/525
};

fn load_texture(render: *sdl2::renderer, path: str) texture = {
	const path = strings::to_c(path);
	defer free(path);

	const tex = match (image::load_texture(render, path)) {
	case let tex: *sdl2::texture =>
		yield tex;
	case null =>
		fmt::fatal("sdl2::image::load_texture failed for cat.png");
	};

	let w = 0, h = 0;
	sdl2::query_texture(tex, null, null, &w, &h);
	return texture {
		tex = tex,
		w = w,
		h = h,
	};
};

fn update(state: *state) void = {
	let width = 0, height = 0;
	sdl2::get_window_size(state.window, &width, &height);

	state.hare_x += state.hare_dx;
	state.hare_y += state.hare_dy;
	if (state.hare_x <= 0 || state.hare_x + state.hare.w >= width) {
		state.hare_dx = -state.hare_dx;
	};
	if (state.hare_y <= 0 || state.hare_y + state.hare.h >= height) {
		state.hare_dy = -state.hare_dy;
	};
};

fn draw(state: *state) void = {
	sdl2::set_render_draw_color(state.render, 50, 50, 50, 255);
	sdl2::render_clear(state.render);
	draw_tex(state, &state.hare, state.hare_x, state.hare_y);
	draw_tex(state, &state.cat, state.cat_x, state.cat_y);
	sdl2::render_present(state.render);
};

fn draw_tex(state: *state, tex: *texture, x: int, y: int) void = {
	sdl2::render_copy(state.render, tex.tex, null, &sdl2::rect {
		x = x,
		y = y,
		w = tex.w,
		h = tex.h,
	});
};
