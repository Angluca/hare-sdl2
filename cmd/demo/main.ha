use fmt;
use fs;
use sdl2;
use sdl2::{ SDL_GameControllerAxis, SDL_EventType, SDL_RendererFlags, SDL_WindowFlags };
use sdl2::image;
use sdl2::mixer;
use strings;

type object = struct {
	tex: *sdl2::SDL_Texture,
	w: int, h: int,
	x: int, y: int,
	dx: int, dy: int,
};

type state = struct {
	quit: bool,
	window: *sdl2::SDL_Window,
	render: *sdl2::SDL_Renderer,
	nbutton: int,
	hare: object,
	cat: object,
};

export fn main() void = {
	match (run()) {
	case let err: sdl2::error =>
		fmt::fatal("SDL2 error: {}", sdl2::strerror(err));
	case let err: fs::error =>
		fmt::fatal("Error: {}", fs::strerror(err));
	case void => void;
	};
};

fn run() (void | fs::error | sdl2::error) = {
	sdl2::SDL_Init(sdl2::SDL_INIT_VIDEO
		| sdl2::SDL_INIT_AUDIO
		| sdl2::SDL_INIT_GAMECONTROLLER)!;
	defer sdl2::SDL_Quit();
	image::IMG_Init(image::IMG_InitFlags::PNG | image::IMG_InitFlags::JPG)!;
	defer image::IMG_Quit();

	mixer::Mix_Init(mixer::MIX_InitFlags::OGG)!;
	defer mixer::Mix_Quit();
	mixer::Mix_OpenAudio(mixer::MIX_DEFAULT_FREQUENCY, mixer::MIX_DEFAULT_FORMAT,
		mixer::MIX_DEFAULT_CHANNELS, 1024)!;
	defer mixer::Mix_CloseAudio();

	const win = sdl2::SDL_CreateWindow("Hare SDL2 demo",
		sdl2::SDL_WINDOWPOS_UNDEFINED, sdl2::SDL_WINDOWPOS_UNDEFINED,
		640, 480, SDL_WindowFlags::NONE)?;
	defer sdl2::SDL_DestroyWindow(win);

	const render = sdl2::SDL_CreateRenderer(win, -1, SDL_RendererFlags::NONE)?;
	defer sdl2::SDL_DestroyRenderer(render);

	let controller: nullable *sdl2::SDL_GameController = null;
	for (let i = 0; i < sdl2::SDL_NumJoysticks()?; i += 1) {
		if (!sdl2::SDL_IsGameController(i)) {
			continue;
		};
		match (sdl2::SDL_GameControllerOpen(i)) {
		case let c: *sdl2::SDL_GameController =>
			controller = c;
			sdl2::SDL_GameControllerRumble(c, 0x4000, 0x4000, 1000): void;
			break;
		case sdl2::error => void;
		};
	};
	defer match (controller) {
	case null => void;
	case let c: *sdl2::SDL_GameController =>
		sdl2::SDL_GameControllerClose(c);
	};

	let sample = mixer::load_file("sample.ogg")?;
	defer mixer::Mix_FreeChunk(sample);
	mixer::Mix_PlayChannelTimed(0, sample, -1)?;

	let state = state {
		window = win,
		render = render,
		hare = load_object(render, "mascot.jpg")?,
		cat = load_object(render, "cat.png")?,
		...
	};
	defer sdl2::SDL_DestroyTexture(state.hare.tex);
	defer sdl2::SDL_DestroyTexture(state.cat.tex);

	state.hare.dx = 2;
	state.hare.dy = 2;

	for (!state.quit) {
		update(&state)?;
		draw(&state)?;
		sdl2::SDL_Delay(1000 / 60);
	};
};

fn update(state: *state) (void | sdl2::error) = {
	let ev = sdl2::event { ... };
	for (sdl2::SDL_PollEvent(&ev)? == 1) switch (ev.event_type) {
	case SDL_EventType::QUIT =>
		state.quit = true;
		return;
	case SDL_EventType::CONTROLLERAXISMOTION =>
		let delta = ev.caxis.value: int * 10 / sdl2::SDL_JOYSTICK_AXIS_MAX;
		if (axis_x(ev.caxis.axis)) {
			state.cat.dx = delta;
		};
		if (axis_y(ev.caxis.axis)) {
			state.cat.dy = delta;
		};
	case SDL_EventType::CONTROLLERBUTTONDOWN =>
		state.nbutton += 1;
	case SDL_EventType::CONTROLLERBUTTONUP =>
		state.nbutton -= 1;
	case => void;
	};

	let width = 0, height = 0;
	sdl2::SDL_GetWindowSize(state.window, &width, &height);

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

fn draw(state: *state) (void | sdl2::error) = {
	if (state.nbutton == 0) {
		sdl2::SDL_SetRenderDrawColor(state.render, 50, 50, 50, 255)?;
	} else {
		sdl2::SDL_SetRenderDrawColor(state.render, 50, 50, 200, 255)?;
	};
	sdl2::SDL_RenderClear(state.render)?;

	draw_object(state, &state.hare)?;
	draw_object(state, &state.cat)?;
	sdl2::SDL_RenderPresent(state.render);
};

fn draw_object(state: *state, obj: *object) (void | sdl2::error) = {
	sdl2::SDL_RenderCopy(state.render, obj.tex, null, &sdl2::SDL_Rect {
		x = obj.x,
		y = obj.y,
		w = obj.w,
		h = obj.h,
	})?;
};

fn axis_x(axis: SDL_GameControllerAxis) bool = {
	switch (axis) {
	case SDL_GameControllerAxis::LEFTX, SDL_GameControllerAxis::RIGHTX =>
		return true;
	case =>
		return false;
	};
};

fn axis_y(axis: SDL_GameControllerAxis) bool = {
	switch (axis) {
	case SDL_GameControllerAxis::LEFTY, SDL_GameControllerAxis::RIGHTY =>
		return true;
	case =>
		return false;
	};
};

fn load_object(render: *sdl2::SDL_Renderer, path: str) (object | sdl2::error) = {
	const tex = image::IMG_LoadTexture(render, path)?;
	let w = 0, h = 0;
	sdl2::SDL_QueryTexture(tex, null, null, &w, &h)?;
	return object {
		tex = tex,
		w = w,
		h = h,
		...
	};
};
