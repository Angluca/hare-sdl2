use io;
use sdl;
use sdl = sdl::render;
use sdl = sdl::surface;
use sdl::image::v2c::*;
use sdl::v2c::*;
use types::c;

// This function gets the version of the dynamically linked SDL_image library.
export fn linked_version() *sdl::version = IMG_Linked_Version(): *sdl::version;

// Initialization flags.
export type init_flags = enum {
	JPG    = 0x00000001,
	PNG    = 0x00000002,
	TIF    = 0x00000004,
	WEBP   = 0x00000008,
	JXL    = 0x00000010,
	AVIF   = 0x00000020,
};

// Initialize SDL_image.
//
// This function loads dynamic libraries that SDL_image needs, and prepares
// them for use. This must be the first function you call in SDL_image, and if
// it fails you should not continue with the library.
//
// Flags should be one or more flags from [[init_flags]] OR'd together. It
// returns the flags successfully initialized, or error if at least one of the
// flags could not be initialized.
//
// More flags may be added in a future SDL_image release.
//
// This function may need to load external shared libraries to support various
// codecs, which means this function can fail to initialize that support on an
// otherwise-reasonable system if the library isn't available; this is not
// just a question of exceptional circumstances like running out of memory at
// startup!
//
// Note that you may call this function more than once to initialize with
// additional flags. The return value will reflect both new flags that
// successfully initialized, and also include flags that had previously been
// initialized as well.
//
// As this will return previously-initialized flags, it's legal to call this
// with zero (no flags set). This is a safe no-op that can be used to query
// the current initialization state without changing it at all.
//
// Unlike other SDL satellite libraries, calls to init do not stack; a single
// call to [[quit]] will deinitialize everything and does not have to be paired
// with a matching init call. For that reason, it's considered best practice to
// have a single init and quit call in your program. While this isn't required,
// be aware of the risks of deviating from that behavior.
export fn init(flags: int) (int | error) = {
	let ret = IMG_Init(flags);
	if (ret & flags != flags)
		return get_error();
	return ret;
};

// Deinitialize SDL_image.
//
// This should be the last function you call in SDL_image, after freeing all
// other resources. This will unload any shared libraries it is using for
// various codecs. You can safely call [[init]] to reload various codec
// support after this call.
export fn quit() void = IMG_Quit();

// Load an image from a filesystem path into a software surface.
//
// A surface is a buffer of pixels in memory accessible by the CPU. Use this if
// you plan to hand the data to something else or manipulate it further in code.
//
// There are no guarantees about what format the new surface data will be; in
// many cases, SDL_image will attempt to supply a surface that exactly matches
// the provided image, but in others it might have to convert (either because
// the image is in a format that SDL doesn't directly support or because it's
// compressed data that could reasonably uncompress to various formats and
// SDL_image had to pick one). You can inspect a surface for its specifics, and
// and use convert_surface to then migrate to any supported format.
//
// If the image format supports a transparent pixel, SDL will set the colorkey
// for the surface. You can enable RLE acceleration on the surface afterwards
// by calling:
//
//	set_color_key(img, sdl::surface_flags::RLEACCEL, image.format.colorkey)
//
// If you are using SDL's 2D rendering API, there is an equivalent call to load
// images directly into a texture for use by the GPU without using a software
// surface: call [[load_texture]] instead.
//
// When done with the returned surface, the app should dispose of it with a
// call to free_surface.
export fn load(file: str) (*sdl::surface | error) = {
	let f = c::fromstr(file);
	defer free(f);
	return wrapptr(IMG_Load(f))?: *sdl::surface;
};

// Load an image from a filesystem path into a GPU texture.
//
// A texture represents an image in GPU memory, usable by SDL's 2D Render API.
// This can be significantly more efficient than using a CPU-bound surface if
// you don't need to manipulate the image directly after loading it.
//
// If the loaded image has transparency or a colorkey, a texture with an alpha
// channel will be created. Otherwise, SDL_image will attempt to create a
// texture in the format that most reasonably represents the image data (but in
// many cases, this will just end up being 32-bit RGB or 32-bit RGBA).
//
// If you would rather decode an image to a surface (a buffer of pixels in CPU
// memory), call [[load]] instead.
//
// When done with the returned texture, the app should dispose of it with a
// call to destroy_texture.
export fn load_texture(
	renderer: *sdl::renderer,
	file: str,
) (*sdl::texture | error) = {
	let f = c::fromstr(file);
	defer free(f);
	return wrapptr(IMG_LoadTexture(renderer: *SDL_Renderer,
		f))?: *sdl::texture;
};

// Save a surface into a PNG image file.
//
// If the file already exists, it will be overwritten.
export fn save_png(surface: *sdl::surface, file: str) (void | error) = {
	let f = c::fromstr(file);
	defer free(f);
	return wrapvoid(IMG_SavePNG(surface: *SDL_Surface, f));
};

// Save a surface into a JPEG image file.
//
// If the file already exists, it will be overwritten.
// quality: [0; 33] is lowest quality, [34; 66] is middle quality, [67; 100]
// is highest quality.
export fn save_jpg(
	surface: *sdl::surface,
	file: str,
	quality: int,
) (void | error) = {
	let f = c::fromstr(file);
	defer free(f);
	return wrapvoid(IMG_SaveJPG(surface: *SDL_Surface, f, quality));
};

// Animated image support.
// Currently only animated GIFs are supported.
export type animation = struct {
        w: int,
	h: int,
        count: int,
        frames: **sdl::surface,
        delays: *int,
};

// Load an animation from a file.
//
// When done with the returned animation, the app should dispose of it with a
// call to [[free_animation]].
export fn load_animation(file: str) (*animation | error) = {
	let f = c::fromstr(file);
	defer free(f);
	return wrapptr(IMG_LoadAnimation(f))?: *animation;
};

// Dispose of an [[animation]] and free its resources.
//
// The provided anim pointer is not valid once this call returns.
export fn free_animation(anim: *animation) void =
	IMG_FreeAnimation(anim: *IMG_Animation);

// Load an image from an SDL data source into a software surface. See [[load]].
//
// type is a filename extension that represent this data ("BMP", "GIF", "PNG",
// etc).
export fn load_typed_h(src: io::handle, type_: str) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	const type__c = c::fromstr(type_);
	defer free(type__c);
	return wrapptr(IMG_LoadTyped_RW(&src_rw, 0, type__c))?: *sdl::surface;
};

// Load an image from an io::handle into a software surface. See [[load]].
export fn load_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_Load_RW(&src_rw, 0))?: *sdl::surface;
};

// Load an image from an SDL data source into a GPU texture. See
// [[load_texture]].
export fn load_texture_h(
	renderer: *sdl::renderer,
	src: io::handle,
) (*sdl::texture | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadTexture_RW(renderer: *SDL_Renderer, &src_rw,
		0))?: *sdl::texture;
};

// Load an image from an SDL data source into a GPU texture. See
// [[load_texture]].
//
// type is a filename extension that represent this data ("BMP", "GIF", "PNG",
// etc).
export fn load_texture_typed_h(
	renderer: *sdl::renderer,
	src: io::handle,
	type_: str,
) (*sdl::texture | error) = {
	const src_rw = SDL_rw_from_handle(src);
	const type__c = c::fromstr(type_);
	defer free(type__c);
	return wrapptr(IMG_LoadTextureTyped_RW(renderer: *SDL_Renderer, &src_rw,
		0, type__c))?: *sdl::texture;
};

// Detect AVIF image data on a readable/seekable handle.
//
// This function attempts to determine if a file is a given filetype, reading
// the least amount possible from the io::handle (usually a few bytes). There is
// no distinction made between "not the filetype in question" and basic I/O
// errors.
//
// This function will always attempt to seek the handle back to where it started
// when the function was called, but it will not report any errors in doing so.
// Assuming seeking works, this means you can immediately use it with a
// different is_type function, or load the image without further seeking.
//
// You do not need to call this function to load data; SDL_image can work to
// determine file type in many cases in its standard load functions.
export fn is_avif(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isAVIF(&src_rw) != 0;
};

// Detect ICO image data on a readable/seekable handle. See [[is_avif]].
export fn is_ico(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isICO(&src_rw) != 0;
};

// Detect CUR image data on a readable/seekable handle. See [[is_avif]].
export fn is_cur(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isCUR(&src_rw) != 0;
};

// Detect BMP image data on a readable/seekable handle. See [[is_avif]].
export fn is_bmp(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isBMP(&src_rw) != 0;
};

// Detect GIF image data on a readable/seekable handle. See [[is_avif]].
export fn is_gif(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isGIF(&src_rw) != 0;
};

// Detect JPG image data on a readable/seekable handle. See [[is_avif]].
export fn is_jpg(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isJPG(&src_rw) != 0;
};

// Detect JXL image data on a readable/seekable handle. See [[is_avif]].
export fn is_jxl(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isJXL(&src_rw) != 0;
};

// Detect LBM image data on a readable/seekable handle. See [[is_avif]].
export fn is_lbm(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isLBM(&src_rw) != 0;
};

// Detect PCX image data on a readable/seekable handle. See [[is_avif]].
export fn is_pcx(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isPCX(&src_rw) != 0;
};

// Detect PNG image data on a readable/seekable handle. See [[is_avif]].
export fn is_png(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isPNG(&src_rw) != 0;
};

// Detect PNM image data on a readable/seekable handle. See [[is_avif]].
export fn is_pnm(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isPNM(&src_rw) != 0;
};

// Detect SVG image data on a readable/seekable handle. See [[is_avif]].
export fn is_svg(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isSVG(&src_rw) != 0;
};

// Detect QOI image data on a readable/seekable handle. See [[is_avif]].
export fn is_qoi(src: io::handle) bool= {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isQOI(&src_rw) != 0;
};

// Detect TIFF image data on a readable/seekable handle. See [[is_avif]].
export fn is_tif(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isTIF(&src_rw) != 0;
};

// Detect XCF image data on a readable/seekable handle. See [[is_avif]].
export fn is_xcf(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isXCF(&src_rw) != 0;
};

// Detect XPM image data on a readable/seekable handle. See [[is_avif]].
export fn is_xpm(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isXPM(&src_rw) != 0;
};

// Detect XV image data on a readable/seekable handle. See [[is_avif]].
export fn is_xv(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isXV(&src_rw) != 0;
};

// Detect WEBP image data on a readable/seekable handle. See [[is_avif]].
export fn is_webp(src: io::handle) bool = {
	const src_rw = SDL_rw_from_handle(src);
	return IMG_isWEBP(&src_rw) != 0;
};

// Load a AVIF image directly.
//
// If you know you definitely have an AVIF image, you can call this function,
// which will skip SDL_image's file format detection routines. Generally it's
// better to use the abstract interfaces; also, there is only an io::handle
// interface available here.
export fn load_avif_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadAVIF_RW(&src_rw))?: *sdl::surface;
};

// Load a ICO image directly. See [[load_avif_h]].
export fn load_ico_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadICO_RW(&src_rw))?: *sdl::surface;
};

// Load a CUR image directly. See [[load_avif_h]].
export fn load_cur_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadCUR_RW(&src_rw))?: *sdl::surface;
};

// Load a BMP image directly. See [[load_avif_h]].
export fn load_bmp_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadBMP_RW(&src_rw))?: *sdl::surface;
};

// Load a GIF image directly. See [[load_avif_h]].
export fn load_gif_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadGIF_RW(&src_rw))?: *sdl::surface;
};

// Load a JPG image directly. See [[load_avif_h]].
export fn load_jpg_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadJPG_RW(&src_rw))?: *sdl::surface;
};

// Load a JXL image directly. See [[load_avif_h]].
export fn load_jxl_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadJXL_RW(&src_rw))?: *sdl::surface;
};

// Load a LBM image directly. See [[load_avif_h]].
export fn load_lbm_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadLBM_RW(&src_rw))?: *sdl::surface;
};

// Load a PCX image directly. See [[load_avif_h]].
export fn load_pcx_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadPCX_RW(&src_rw))?: *sdl::surface;
};

// Load a PNG image directly. See [[load_avif_h]].
export fn load_png_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadPNG_RW(&src_rw))?: *sdl::surface;
};

// Load a PNM image directly. See [[load_avif_h]].
export fn load_pnm_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadPNM_RW(&src_rw))?: *sdl::surface;
};

// Load a SVG image directly. See [[load_avif_h]].
export fn load_svg_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadSVG_RW(&src_rw))?: *sdl::surface;
};

// Load a QOI image directly. See [[load_avif_h]].
export fn load_qoi_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadQOI_RW(&src_rw))?: *sdl::surface;
};

// Load a TGA image directly. See [[load_avif_h]].
export fn load_tga_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadTGA_RW(&src_rw))?: *sdl::surface;
};

// Load a TIFF image directly. See [[load_avif_h]].
export fn load_tif_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadTIF_RW(&src_rw))?: *sdl::surface;
};

// Load a XCF image directly. See [[load_avif_h]].
export fn load_xcf_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadXCF_RW(&src_rw))?: *sdl::surface;
};

// Load a XPM image directly. See [[load_avif_h]].
export fn load_xpm_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadXPM_RW(&src_rw))?: *sdl::surface;
};

// Load a XV image directly. See [[load_avif_h]].
export fn load_xv_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadXV_RW(&src_rw))?: *sdl::surface;
};

// Load a WEBP image directly. See [[load_avif_h]].
export fn load_webp_h(src: io::handle) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadWEBP_RW(&src_rw))?: *sdl::surface;
};

// Load an SVG image, scaled to a specific size. See [[load_avif_h]].
//
// Since SVG files are resolution-independent, you specify the size you would
// like the output image to be and it will be generated at those dimensions.
//
// Either width or height may be 0 and the image will be auto-sized to
// preserve aspect ratio.
export fn load_sized_svg_h(
	src: io::handle,
	width: int,
	height: int,
) (*sdl::surface | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadSizedSVG_RW(&src_rw, width,
		height))?: *sdl::surface;
};

// Save an SDL_Surface into PNG image data, via an io::handle.
export fn save_png_h(surface: *sdl::surface, dst: io::handle) (void | error) = {
	const dst_rw = SDL_rw_from_handle(dst);
	return wrapvoid(IMG_SavePNG_RW(surface: *SDL_Surface, &dst_rw, 0));
};

// Save an SDL_Surface into JPEG image data, via an io::handle.
//
// quality goes from 0 to 100.
export fn save_jpg_h(
	surface: *sdl::surface,
	dst: io::handle,
	quality: int,
) (void | error) = {
	const dst_rw = SDL_rw_from_handle(dst);
	return wrapvoid(IMG_SaveJPG_RW(surface: *SDL_Surface, &dst_rw, 0,
		quality));
};

// Load an animation from an io::handle.
//
// When done with the returned animation, the app should dispose of it with a
// call to [[free_animation]].
export fn load_animation_h(src: io::handle) (*animation | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadAnimation_RW(&src_rw, 0))?: *animation;
};

// Load an animation from an SDL datasource
//
// Even though this function accepts a file type, SDL_image may still try
// other decoders that are capable of detecting file type from the contents of
// the image data, but may rely on the caller-provided type string for formats
// that it cannot autodetect.
//
// When done with the returned animation, the app should dispose of it with a
// call to [[free_animation]].
//
// type is a filename extension that represent this data ("GIF", etc).
export fn load_animation_typed_h(
	src: io::handle,
	type_: str,
) (*animation | error) = {
	const src_rw = SDL_rw_from_handle(src);
	const type__c = c::fromstr(type_);
	defer free(type__c);
	return wrapptr(IMG_LoadAnimationTyped_RW(&src_rw, 0,
		type__c))?: *animation;
};

// Load a GIF animation directly.
export fn load_gif_animation_h(src: io::handle) (*animation | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadGIFAnimation_RW(&src_rw))?: *animation;
};

// Load a WEBP animation directly.
export fn load_webp_animation_h(src: io::handle) (*animation | error) = {
	const src_rw = SDL_rw_from_handle(src);
	return wrapptr(IMG_LoadWEBPAnimation_RW(&src_rw))?: *animation;
};
