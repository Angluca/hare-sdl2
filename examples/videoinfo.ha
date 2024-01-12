use fmt;
use sdl;
use sdl = sdl::render;
use sdl = sdl::video;

export fn main() void = {
	sdl::init(sdl::init_flags::VIDEO)!;
	defer sdl::quit();

	let ndrivers = sdl::get_num_video_drivers()!;
	fmt::println("Num video drivers:", ndrivers)!;
	for (let d = 0; d < ndrivers; d += 1) {
		fmt::printfln("\t{}: {}", d, sdl::get_video_driver(d)!)!;
	};
	fmt::println("Current video driver:",
		sdl::get_current_video_driver() as str)!;

	let ndisp = sdl::get_num_video_displays()!;
	fmt::println("Num video displays:", ndisp)!;
	for (let d = 0; d < ndisp; d += 1) {
		fmt::printfln("\t{}: {}", d, sdl::get_display_name(d)!)!;
		let bounds = sdl::get_display_bounds(d)!;
		fmt::printfln("\t\tBounds: x {} y {} w {} h {}",
			bounds.x, bounds.y, bounds.w, bounds.h)!;
		let ubounds = sdl::get_display_usable_bounds(d)!;
		fmt::printfln("\t\tUsable bounds: x {} y {} w {} h {}",
			ubounds.x, ubounds.y, ubounds.w, ubounds.h)!;
		let dpi = sdl::get_display_dpi(d)!;
		fmt::printfln("\t\tDPI: d {} h {} v {}",
			dpi.ddpi, dpi.hdpi, dpi.vdpi)!;
		let o = switch (sdl::get_display_orientation(d)) {
		case sdl::display_orientation::UNKNOWN =>
			yield "unknown";
		case sdl::display_orientation::LANDSCAPE =>
			yield "landscape";
		case sdl::display_orientation::LANDSCAPE_FLIPPED =>
			yield "landscape flipped";
		case sdl::display_orientation::PORTRAIT =>
			yield "portrait";
		case sdl::display_orientation::PORTRAIT_FLIPPED =>
			yield "portrait flipped";
		};
		fmt::printfln("\t\tOrientation: {}", o)!;

		let nmodes = sdl::get_num_display_modes(d)!;
		fmt::println("\t\tNum display modes:", nmodes)!;
		for (let m = 0; m < nmodes && m < 5; m += 1) {
			let mode = sdl::get_display_mode(d, m)!;
			fmt::printfln("\t\t\t{}: {}x{} {} Hz ...",
				m, mode.w, mode.h, mode.refresh_rate)!;
		};
		if (nmodes > 5) fmt::println("\t\t\t...")!;
	};

	let nrend = sdl::get_num_render_drivers()!;
	fmt::println("Num render drivers:", nrend)!;
	for (let r = 0; r < nrend; r += 1) {
		let ri = sdl::get_render_driver_info(r)!;
		fmt::printfln("\t{}: {}", r, ri.name)!;
		fmt::print("\t\tFlags: ")!;
		if (ri.flags & sdl::renderer_flags::SOFTWARE != 0)
			fmt::print("software ")!;
		if (ri.flags & sdl::renderer_flags::ACCELERATED != 0)
			fmt::print("accelerated ")!;
		if (ri.flags & sdl::renderer_flags::PRESENTVSYNC != 0)
			fmt::print("v-sync ")!;
		if (ri.flags & sdl::renderer_flags::TARGETTEXTURE != 0)
			fmt::print("render-to-texture")!;
		fmt::println()!;
		fmt::printfln("\t\tn texture formats: {}",
			len(ri.texture_formats))!;
		fmt::printfln("\t\tmax texture width: {}",
			ri.max_texture_width)!;
		fmt::printfln("\t\tmax texture height: {}",
			ri.max_texture_height)!;
	};
};
