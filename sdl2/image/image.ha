// TODO: Flesh me out
// TODO: SDL_RWops
use sdl2;

// Flags for [[init]].
export type init_flags = enum int {
	NONE = 0,
	JPG = 0x00000001,
	PNG = 0x00000002,
	TIF = 0x00000004,
	WEBP = 0x00000008,
};

// Loads dynamic libraries and prepares them for use. Flags should be one or
// more flags from IMG_InitFlags OR'd together.
//
// Returns the flags successfully initialized, or 0 on failure.
export @symbol("IMG_Init") fn init(flags: init_flags) int;

// Unloads libraries loaded with [[init]]
export @symbol("IMG_Quit") fn quit() void;

// Load an image from a file path.
export @symbol("IMG_Load") fn load(file: const *char) nullable *sdl2::surface;

// Load an image directly into a render texture.
export @symbol("IMG_LoadTexture") fn load_texture(renderer: *sdl2::renderer,
	file: const *char) nullable *sdl2::texture;
