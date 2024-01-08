// let harriet bounce around
use sdl;
use img = sdl::image;

export fn main() void = {
	// load up SDL and SDL_image
	sdl::init(sdl::init_flags::VIDEO)!;
	defer sdl::quit();
	img::init(img::init_flags::PNG)!;
	defer img::quit();

	// make a window and a renderer
	const window = sdl::create_window("hi",
		sdl::WINDOWPOS_UNDEFINED, sdl::WINDOWPOS_UNDEFINED,
		800, 600, sdl::window_flags::RESIZABLE)!;
	defer sdl::destroy_window(window);
	const renderer = sdl::create_renderer(window, -1,
		sdl::renderer_flags::PRESENTVSYNC)!;
	defer sdl::destroy_renderer(renderer);
	sdl::set_render_draw_color(renderer, 0xFF, 0xFF, 0xFF, 0xFF)!;

	// load up harriet
	const harriet = img::load_texture(renderer, "mascot.png")!;
	defer sdl::destroy_texture(harriet);

	// find out how big harriet's texture is.
	let harepos = sdl::rect { ... };
	sdl::query_texture(harriet, null, null, &harepos.w, &harepos.h)!;

	// start the main loop
	let vx = 200, vy = 333;
	let last_tick = sdl::get_ticks(): int;
	for :loop (true) {
		// handle events
		for (true) match (sdl::poll_event()) {
		case void =>
			break;
		case sdl::quit_requested =>
			break :loop;
		case => void;
		};

		// move harriet
		const tick = sdl::get_ticks(): int;
		harepos.x += vx * (tick - last_tick) / 1000;
		harepos.y += vy * (tick - last_tick) / 1000;
		last_tick = tick;

		// if we hit the window edges, turn around. can get stuck.
		let ww = 0, wh = 0;
		sdl::get_renderer_output_size(renderer, &ww, &wh)!;
		if (harepos.x < 0 || harepos.x + harepos.w > ww) vx = -vx;
		if (harepos.y < 0 || harepos.y + harepos.h > wh) vy = -vy;

		// draw harriet
		sdl::render_clear(renderer)!;
		sdl::render_copy(renderer, harriet, null, &harepos)!;
		sdl::render_present(renderer);
	};
};
