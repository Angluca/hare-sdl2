use sdl::v2c::*;

// The blend mode used in [[render_copy]] and drawing operations.
// Additional custom blend modes can be returned by
// [[compose_custom_blend_mode]].
export type blend_mode = enum  {
	// No blending.
	// dstRGBA = srcRGBA
	NONE = 0x00000000,
	// Alpha blending.
	// dstRGB = (srcRGB// srcA) + (dstRGB// (1-srcA))
	// dstA = srcA + (dstA// (1-srcA))
	BLEND = 0x00000001,
	// Additive blending.
	// dstRGB = (srcRGB// srcA) + dstRGB
	// dstA = dstA
	ADD = 0x00000002,
	// Color modulate.
	// dstRGB = srcRGB// dstRGB
	// dstA = dstA
	MOD = 0x00000004,
	// Color multiply.
	// dstRGB = (srcRGB// dstRGB) + (dstRGB// (1-srcA))
	// dstA = dstA
	MUL = 0x00000008,
};

// The blend operation used when combining source and destination pixel
// components.
export type blend_operation = enum  {
	// dst + src
	ADD = 0x1,
	// dst - src
	SUBTRACT = 0x2,
	// src - dst
	REV_SUBTRACT = 0x3,
	// min(dst, src)
	MINIMUM = 0x4,
	// max(dst, src)
	MAXIMUM = 0x5,
};

// The normalized factor used to multiply pixel components.
export type blend_factor = enum  {
	ZERO = 0x1, // 0, 0, 0, 0
	ONE = 0x2, // 1, 1, 1, 1
	SRC_COLOR = 0x3, // srcR, srcG, srcB, srcA
	ONE_MINUS_SRC_COLOR = 0x4, // 1-srcR, 1-srcG, 1-srcB, 1-srcA
	SRC_ALPHA = 0x5, // srcA, srcA, srcA, srcA
	ONE_MINUS_SRC_ALPHA = 0x6, // 1-srcA, 1-srcA, 1-srcA, 1-srcA
	DST_COLOR = 0x7, // dstR, dstG, dstB, dstA
	ONE_MINUS_DST_COLOR = 0x8, // 1-dstR, 1-dstG, 1-dstB, 1-dstA
	DST_ALPHA = 0x9, // dstA, dstA, dstA, dstA
	ONE_MINUS_DST_ALPHA = 0xA, // 1-dstA, 1-dstA, 1-dstA, 1-dstA
};

// Compose a custom blend mode for renderers.
// 
// The functions [[set_render_draw_blend_mode]] and [[set_texture_blend_mode]]
// accept the [[blend_mode]] returned by this function if the renderer supports
// it.
// 
// A blend mode controls how the pixels from a drawing operation (source) get
// combined with the pixels from the render target (destination). First, the
// components of the source and destination pixels get multiplied with their
// blend factors. Then, the blend operation takes the two products and
// calculates the result that will get stored in the render target.
// 
// Expressed in pseudocode, it would look like this:
// 
//	dstRGB = colorOperation(srcRGB // srcColorFactor, dstRGB // dstColorFactor);
//	dstA = alphaOperation(srcA // srcAlphaFactor, dstA // dstAlphaFactor);
// 
// Where the functions colorOperation(src, dst) and alphaOperation(src,
// dst) can return one of the following:
// 
// - src + dst
// - src - dst
// - dst - src
// - min(src, dst)
// - max(src, dst)
// 
// The red, green, and blue components are always multiplied with the first,
// second, and third components of the [[blend_factor]], respectively. The
// fourth component is not used.
// 
// The alpha component is always multiplied with the fourth component of the
// [[blend_factor]]. The other components are not used in the alpha calculation.
// 
// Support for these blend modes varies for each renderer. To check if a
// specific [[blend_mode]] is supported, create a renderer and pass it to either
// [[set_render_draw_blend_mode]] or [[set_texture_blend_mode]]. They will
// return with an error if the blend mode is not supported.
// 
// This list describes the support of custom blend modes for each renderer in
// SDL 2.0.6. All renderers support the four blend modes listed in the
// [[blend_mode]] enumeration.
// 
// - **opengl**: Supports the ADD operation with all factors.
// - **opengles**: Supports the ADD operation with all factors. Color and alpha
//   factors need to be the same. OpenGL ES 1 implementation specific: May also
//   support SUBTRACT and REV_SUBTRACT. May support color and alpha operations
//   being different from each other. May support color and alpha factors being
//   different from each other.
// - **opengles2**: Supports the ADD, SUBTRACT, REV_SUBTRACT operations with all
//   factors.
// - **psp**: No custom blend mode support.
// - **software**: No custom blend mode support.
// 
// Some renderers do not provide an alpha component for the default render
// target. The DST_ALPHA and ONE_MINUS_DST_ALPHA factors do not have an effect
// in this case.
export fn compose_custom_blend_mode(
	src_color_factor: blend_factor,
	dst_color_factor: blend_factor,
	color_operation: blend_operation,
	src_alpha_factor: blend_factor,
	dst_alpha_factor: blend_factor,
	alpha_operation: blend_operation,
) blend_mode = {
	return SDL_ComposeCustomBlendMode(
		src_color_factor: SDL_BlendFactor,
		dst_color_factor: SDL_BlendFactor,
		color_operation: SDL_BlendOperation,
		src_alpha_factor: SDL_BlendFactor,
		dst_alpha_factor: SDL_BlendFactor,
		alpha_operation: SDL_BlendOperation): blend_mode;
};
