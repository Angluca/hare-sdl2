use fmt;
use os;
use sdl2::{
	controller_axis,
	event_type,
	renderer_flags,
	window_flags,
};
use sdl2;
use sdl2::image;
use strings;

type texture = struct {
	tex: *sdl2::texture,
	w: int,
	h: int,
};

type state = struct {
	quit: bool,
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
	cat_dx: int,
	cat_dy: int,
};

fn update(state: *state) void = {
	let ev = sdl2::event { ... };
	for (sdl2::poll_event(&ev) == 1) switch (ev.event_type) {
	case event_type::QUIT =>
		state.quit = true;
		return;
	case event_type::CONTROLLERAXISMOTION =>
		let delta = ev.caxis.value: int * 10 / sdl2::JOYSTICK_AXIS_MAX;
		if (axis_x(ev.caxis.axis)) {
			state.cat_dx = delta;
		};
		if (axis_y(ev.caxis.axis)) {
			state.cat_dy = delta;
		};
	case => void;
	};

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

	state.cat_x += state.cat_dx;
	state.cat_y += state.cat_dy;
	if (state.cat_x <= 0) {
		state.cat_x = 0;
	};
	if (state.cat_x > width - state.cat.w) {
		state.cat_x = width - state.cat.w;
	};
	if (state.cat_y <= 0) {
		state.cat_y = 0;
	};
	if (state.cat_y > height - state.cat.h) {
		state.cat_y = height - state.cat.h;
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

fn axis_x(axis: controller_axis) bool = {
	switch (axis) {
	case controller_axis::LEFTX, controller_axis::RIGHTX =>
		return true;
	case =>
		return false;
	};
};

fn axis_y(axis: controller_axis) bool = {
	switch (axis) {
	case controller_axis::LEFTY, controller_axis::RIGHTY =>
		return true;
	case =>
		return false;
	};
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

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO | sdl2::init_flags::GAMECONTROLLER);
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

	let controller: nullable *sdl2::gamecontroller = null;
	for (let i = 0; i < sdl2::numjoysticks(); i += 1) {
		if (!sdl2::is_game_controller(i)) {
			continue;
		};
		controller = sdl2::game_controller_open(i);
		if (controller != null) {
			break;
		};
	};
	defer match (controller) {
	case null => void;
	case let c: *sdl2::gamecontroller =>
		sdl2::game_controller_close(c);
	};

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

	for (!state.quit) {
		update(&state);
		draw(&state);
		sdl2::delay(1000 / 60);
	};

	os::exit(0); // https://todo.sr.ht/~sircmpwn/hare/525
};
