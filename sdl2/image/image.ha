// TODO: Flesh me out
// TODO: SDL_RWops
use sdl2;
use strings;

// Flags for [[IMG_Init]].
export type IMG_InitFlags = enum int {
	NONE = 0,
	JPG = 0x00000001,
	PNG = 0x00000002,
	TIF = 0x00000004,
	WEBP = 0x00000008,
};

@symbol("IMG_Init") fn _IMG_Init(flags: IMG_InitFlags) int;

// Loads dynamic libraries and prepares them for use. Flags should be one or
// more flags from [[IMG_InitFlags]] OR'd together.
export fn IMG_Init(flags: IMG_InitFlags) (void | sdl2::error) = {
	return sdl2::wrapvoid(_IMG_Init(flags));
};

// Unloads libraries loaded with [[IMG_Init]]
export @symbol("IMG_Quit") fn IMG_Quit() void;

@symbol("IMG_Load") fn _IMG_Load(file: const *char) nullable *sdl2::SDL_Surface;

// Load an image from a file path.
export fn IMG_Load(file: str) (*sdl2::SDL_Surface | sdl2::error) = {
	const file = strings::to_c(file);
	defer free(file);
	return sdl2::wrapptr(_IMG_Load(file))?: *sdl2::SDL_Surface;
};

@symbol("IMG_LoadTexture") fn _IMG_LoadTexture(SDL_Renderer: *sdl2::SDL_Renderer,
	file: const *char) nullable *sdl2::SDL_Texture;

// Load an image directly into a render texture.
export fn IMG_LoadTexture(
	SDL_Renderer: *sdl2::SDL_Renderer,
	file: str,
) (*sdl2::SDL_Texture | sdl2::error) = {
	const file = strings::to_c(file);
	defer free(file);
	return sdl2::wrapptr(_IMG_LoadTexture(SDL_Renderer, file))?: *sdl2::SDL_Texture;
};
