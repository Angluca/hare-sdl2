export type glcontext = void;

export type glprofile = enum int {
	GL_CONTEXT_PROFILE_CORE = 0x0001,
	GL_CONTEXT_PROFILE_COMPATIBILITY = 0x0002,
	GL_CONTEXT_PROFILE_ES = 0x0004,
};

export type glattr = enum {
	GL_RED_SIZE,
	GL_GREEN_SIZE,
	GL_BLUE_SIZE,
	GL_ALPHA_SIZE,
	GL_BUFFER_SIZE,
	GL_DOUBLEBUFFER,
	GL_DEPTH_SIZE,
	GL_STENCIL_SIZE,
	GL_ACCUM_RED_SIZE,
	GL_ACCUM_GREEN_SIZE,
	GL_ACCUM_BLUE_SIZE,
	GL_ACCUM_ALPHA_SIZE,
	GL_STEREO,
	GL_MULTISAMPLEBUFFERS,
	GL_MULTISAMPLESAMPLES,
	GL_ACCELERATED_VISUAL,
	GL_RETAINED_BACKING,
	GL_CONTEXT_MAJOR_VERSION,
	GL_CONTEXT_MINOR_VERSION,
	GL_CONTEXT_EGL,
	GL_CONTEXT_FLAGS,
	GL_CONTEXT_PROFILE_MASK,
	GL_SHARE_WITH_CURRENT_CONTEXT,
	GL_FRAMEBUFFER_SRGB_CAPABLE,
	GL_CONTEXT_RELEASE_BEHAVIOR,
	GL_CONTEXT_RESET_NOTIFICATION,
	GL_CONTEXT_NO_ERROR,
};

export @symbol("SDL_GL_CreateContext") fn gl_create_context(
	window: *window) *glcontext;
export @symbol("SDL_GL_GetProcAddress") fn gl_get_proc_address(
	proc: *const char) *void;
export @symbol("SDL_GL_SetAttribute") fn gl_set_attribute(
	attr: glattr, value: int) *void;
export @symbol("SDL_GL_SwapWindow") fn gl_swap_window(window: *window) void;
