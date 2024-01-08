use sdl::v2c::*;
use types::c;

export type IMG_InitFlags = enum {
	IMG_INIT_JPG    = 0x00000001,
	IMG_INIT_PNG    = 0x00000002,
	IMG_INIT_TIF    = 0x00000004,
	IMG_INIT_WEBP   = 0x00000008,
	IMG_INIT_JXL    = 0x00000010,
	IMG_INIT_AVIF   = 0x00000020,
};

export type IMG_Animation = struct {
	w: int,
	h: int,
	count: int,
	frames: **SDL_Surface,
	delays: *int,
};

export @symbol("IMG_Linked_Version") fn IMG_Linked_Version() *SDL_version;
export @symbol("IMG_Init") fn IMG_Init(flags: int) int;
export @symbol("IMG_Quit") fn IMG_Quit() void;
export @symbol("IMG_LoadTyped_RW") fn IMG_LoadTyped_RW(src: *SDL_RWops, freesrc: int, type_: *c::char) nullable *SDL_Surface;
export @symbol("IMG_Load") fn IMG_Load(file: *c::char) nullable *SDL_Surface;
export @symbol("IMG_Load_RW") fn IMG_Load_RW(src: *SDL_RWops, freesrc: int) nullable *SDL_Surface;
export @symbol("IMG_LoadTexture") fn IMG_LoadTexture(renderer: *SDL_Renderer, file: *c::char) nullable *SDL_Texture;
export @symbol("IMG_LoadTexture_RW") fn IMG_LoadTexture_RW(renderer: *SDL_Renderer, src: *SDL_RWops, freesrc: int) nullable *SDL_Texture;
export @symbol("IMG_LoadTextureTyped_RW") fn IMG_LoadTextureTyped_RW(renderer: *SDL_Renderer, src: *SDL_RWops, freesrc: int, type_: *c::char) nullable *SDL_Texture;
export @symbol("IMG_isAVIF") fn IMG_isAVIF(src: *SDL_RWops) int;
export @symbol("IMG_isICO") fn IMG_isICO(src: *SDL_RWops) int;
export @symbol("IMG_isCUR") fn IMG_isCUR(src: *SDL_RWops) int;
export @symbol("IMG_isBMP") fn IMG_isBMP(src: *SDL_RWops) int;
export @symbol("IMG_isGIF") fn IMG_isGIF(src: *SDL_RWops) int;
export @symbol("IMG_isJPG") fn IMG_isJPG(src: *SDL_RWops) int;
export @symbol("IMG_isJXL") fn IMG_isJXL(src: *SDL_RWops) int;
export @symbol("IMG_isLBM") fn IMG_isLBM(src: *SDL_RWops) int;
export @symbol("IMG_isPCX") fn IMG_isPCX(src: *SDL_RWops) int;
export @symbol("IMG_isPNG") fn IMG_isPNG(src: *SDL_RWops) int;
export @symbol("IMG_isPNM") fn IMG_isPNM(src: *SDL_RWops) int;
export @symbol("IMG_isSVG") fn IMG_isSVG(src: *SDL_RWops) int;
export @symbol("IMG_isQOI") fn IMG_isQOI(src: *SDL_RWops) int;
export @symbol("IMG_isTIF") fn IMG_isTIF(src: *SDL_RWops) int;
export @symbol("IMG_isXCF") fn IMG_isXCF(src: *SDL_RWops) int;
export @symbol("IMG_isXPM") fn IMG_isXPM(src: *SDL_RWops) int;
export @symbol("IMG_isXV") fn IMG_isXV(src: *SDL_RWops) int;
export @symbol("IMG_isWEBP") fn IMG_isWEBP(src: *SDL_RWops) int;
export @symbol("IMG_LoadAVIF_RW") fn IMG_LoadAVIF_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadICO_RW") fn IMG_LoadICO_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadCUR_RW") fn IMG_LoadCUR_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadBMP_RW") fn IMG_LoadBMP_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadGIF_RW") fn IMG_LoadGIF_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadJPG_RW") fn IMG_LoadJPG_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadJXL_RW") fn IMG_LoadJXL_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadLBM_RW") fn IMG_LoadLBM_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadPCX_RW") fn IMG_LoadPCX_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadPNG_RW") fn IMG_LoadPNG_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadPNM_RW") fn IMG_LoadPNM_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadSVG_RW") fn IMG_LoadSVG_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadQOI_RW") fn IMG_LoadQOI_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadTGA_RW") fn IMG_LoadTGA_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadTIF_RW") fn IMG_LoadTIF_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadXCF_RW") fn IMG_LoadXCF_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadXPM_RW") fn IMG_LoadXPM_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadXV_RW") fn IMG_LoadXV_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadWEBP_RW") fn IMG_LoadWEBP_RW(src: *SDL_RWops) nullable *SDL_Surface;
export @symbol("IMG_LoadSizedSVG_RW") fn IMG_LoadSizedSVG_RW(src: *SDL_RWops, width: int, height: int) nullable *SDL_Surface;
export @symbol("IMG_ReadXPMFromArray") fn IMG_ReadXPMFromArray(xpm: **c::char) nullable *SDL_Surface;
export @symbol("IMG_ReadXPMFromArrayToRGB888") fn IMG_ReadXPMFromArrayToRGB888(xpm: **c::char) nullable *SDL_Surface;
export @symbol("IMG_SavePNG") fn IMG_SavePNG(surface: *SDL_Surface, file: *c::char) int;
export @symbol("IMG_SavePNG_RW") fn IMG_SavePNG_RW(surface: *SDL_Surface, dst: *SDL_RWops, freedst: int) int;
export @symbol("IMG_SaveJPG") fn IMG_SaveJPG(surface: *SDL_Surface, file: *c::char, quality: int) int;
export @symbol("IMG_SaveJPG_RW") fn IMG_SaveJPG_RW(surface: *SDL_Surface, dst: *SDL_RWops, freedst: int, quality: int) int;
export @symbol("IMG_LoadAnimation") fn IMG_LoadAnimation(file: *c::char) nullable *IMG_Animation;
export @symbol("IMG_LoadAnimation_RW") fn IMG_LoadAnimation_RW(src: *SDL_RWops, freesrc: int) nullable *IMG_Animation;
export @symbol("IMG_LoadAnimationTyped_RW") fn IMG_LoadAnimationTyped_RW(src: *SDL_RWops, freesrc: int, type_: *c::char) nullable *IMG_Animation;
export @symbol("IMG_FreeAnimation") fn IMG_FreeAnimation(anim: *IMG_Animation) void;
export @symbol("IMG_LoadGIFAnimation_RW") fn IMG_LoadGIFAnimation_RW(src: *SDL_RWops) nullable *IMG_Animation;
export @symbol("IMG_LoadWEBPAnimation_RW") fn IMG_LoadWEBPAnimation_RW(src: *SDL_RWops) nullable *IMG_Animation;
