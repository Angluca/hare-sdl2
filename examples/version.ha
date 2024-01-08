use fmt;
use sdl;
use img = sdl::image;
use mix = sdl::mixer;
use ttf = sdl::ttf;

export fn main() void = {
	let v = sdl::version { ... };
	sdl::get_version(&v);
	fmt::printfln("SDL version: {}.{}.{}", v.major, v.minor, v.patch)!;
	fmt::printfln("SDL revision: {}", sdl::get_revision())!;

	let iv = img::linked_version();
	fmt::printfln("IMG version: {}.{}.{}", iv.major, iv.minor, iv.patch)!;

	let mv = mix::linked_version();
	fmt::printfln("Mix version: {}.{}.{}", mv.major, mv.minor, mv.patch)!;

	let tv = ttf::linked_version();
	fmt::printfln("TTF version: {}.{}.{}", tv.major, tv.minor, tv.patch)!;

	ttf::init()!;
	defer ttf::quit();

	let fvmajor = 0, fvminor = 0, fvpatch = 0;
	ttf::get_free_type_version(&fvmajor, &fvminor, &fvpatch);
	fmt::printfln("Freetype version: {}.{}.{}", fvmajor, fvminor, fvpatch)!;

	let hvmajor = 0, hvminor = 0, hvpatch = 0;
	ttf::get_harf_buzz_version(&hvmajor, &hvminor, &hvpatch);
	fmt::printfln("HarfBuzz version: {}.{}.{}", hvmajor, hvminor, hvpatch)!;
};
