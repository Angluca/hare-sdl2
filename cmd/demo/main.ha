use fmt;
use os;
use sdl2;
use sdl2::{ controller_axis, event_type, renderer_flags, window_flags };
use sdl2::image;
use strings;

type object = struct {
	tex: *sdl2::texture,
	w: int, h: int,
	x: int, y: int,
	dx: int, dy: int,
};

type state = struct {
	quit: bool,
	window: *sdl2::window,
	render: *sdl2::renderer,
	nbutton: int,
	hare: object,
	cat: object,
};

export fn main() void = {
	sdl2::init(sdl2::init_flags::VIDEO | sdl2::init_flags::GAMECONTROLLER);
	defer sdl2::quit();
	image::init(image::init_flags::PNG | image::init_flags::JPG);
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
		hare = load_object(render, "mascot.jpg"),
		cat = load_object(render, "cat.png"),
		...
	};
	defer sdl2::destroy_texture(state.hare.tex);
	defer sdl2::destroy_texture(state.cat.tex);

	state.hare.dx = 2;
	state.hare.dy = 2;

	for (!state.quit) {
		update(&state);
		draw(&state);
		sdl2::delay(1000 / 60);
	};
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
			state.cat.dx = delta;
		};
		if (axis_y(ev.caxis.axis)) {
			state.cat.dy = delta;
		};
	case event_type::CONTROLLERBUTTONDOWN =>
		state.nbutton += 1;
	case event_type::CONTROLLERBUTTONUP =>
		state.nbutton -= 1;
	case => void;
	};

	let width = 0, height = 0;
	sdl2::get_window_size(state.window, &width, &height);

	state.hare.x += state.hare.dx;
	state.hare.y += state.hare.dy;
	if (state.hare.x <= 0 || state.hare.x + state.hare.w >= width) {
		state.hare.dx = -state.hare.dx;
	};
	if (state.hare.y <= 0 || state.hare.y + state.hare.h >= height) {
		state.hare.dy = -state.hare.dy;
	};

	state.cat.x += state.cat.dx;
	state.cat.y += state.cat.dy;
	if (state.cat.x <= 0) {
		state.cat.x = 0;
	};
	if (state.cat.x > width - state.cat.w) {
		state.cat.x = width - state.cat.w;
	};
	if (state.cat.y <= 0) {
		state.cat.y = 0;
	};
	if (state.cat.y > height - state.cat.h) {
		state.cat.y = height - state.cat.h;
	};
};

fn draw(state: *state) void = {
	if (state.nbutton == 0) {
		sdl2::set_render_draw_color(state.render, 50, 50, 50, 255);
	} else {
		sdl2::set_render_draw_color(state.render, 50, 50, 200, 255);
	};
	sdl2::render_clear(state.render);

	draw_object(state, &state.hare);
	draw_object(state, &state.cat);
	sdl2::render_present(state.render);
};

fn draw_object(state: *state, obj: *object) void = {
	sdl2::render_copy(state.render, obj.tex, null, &sdl2::rect {
		x = obj.x,
		y = obj.y,
		w = obj.w,
		h = obj.h,
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

fn load_object(render: *sdl2::renderer, path: str) object = {
	const path = strings::to_c(path);
	defer free(path);

	const tex = match (image::load_texture(render, path)) {
	case let tex: *sdl2::texture =>
		yield tex;
	case null =>
		fmt::fatal("sdl2::image::load_texture failed for {}", path);
	};

	let w = 0, h = 0;
	sdl2::query_texture(tex, null, null, &w, &h);
	return object {
		tex = tex,
		w = w,
		h = h,
		...
	};
};
