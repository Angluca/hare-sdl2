use types::c;

export type SDL_RendererFlags = enum u32 {
	SDL_RENDERER_SOFTWARE = 0x00000001,
	SDL_RENDERER_ACCELERATED = 0x00000002,
	SDL_RENDERER_PRESENTVSYNC = 0x00000004,
	SDL_RENDERER_TARGETTEXTURE = 0x00000008,
};

export type SDL_RendererInfo = struct {
	name: nullable *c::char,
	flags: u32,
	num_texture_formats: u32,
	texture_formats: [16]u32,
	max_texture_width: int,
	max_texture_height: int,
};

export type SDL_Vertex = struct {
	position: SDL_FPoint,
	color: SDL_Color,
	tex_coord: SDL_FPoint,
};

export type SDL_ScaleMode = enum {
	SDL_ScaleModeNearest,
	SDL_ScaleModeLinear,
	SDL_ScaleModeBest,
};

export type SDL_TextureAccess = enum {
	SDL_TEXTUREACCESS_STATIC,
	SDL_TEXTUREACCESS_STREAMING,
	SDL_TEXTUREACCESS_TARGET,
};

export type SDL_TextureModulate = enum {
	SDL_TEXTUREMODULATE_NONE = 0x00000000,
	SDL_TEXTUREMODULATE_COLOR = 0x00000001,
	SDL_TEXTUREMODULATE_ALPHA = 0x00000002,
};

export type SDL_RendererFlip = enum u32 {
	SDL_FLIP_NONE,
	SDL_FLIP_HORIZONTAL,
	SDL_FLIP_VERTICAL,
};

export type SDL_Renderer = opaque;

export type SDL_Texture = opaque;

export @symbol("SDL_GetNumRenderDrivers") fn SDL_GetNumRenderDrivers() int;
export @symbol("SDL_GetRenderDriverInfo") fn SDL_GetRenderDriverInfo(index: int, info: *SDL_RendererInfo) int;
export @symbol("SDL_CreateWindowAndRenderer") fn SDL_CreateWindowAndRenderer(width: int, height: int, window_flags: u32, window: *nullable *SDL_Window, renderer: *nullable *SDL_Renderer) int;
export @symbol("SDL_CreateRenderer") fn SDL_CreateRenderer(window: *SDL_Window, index: int, flags: u32) nullable *SDL_Renderer;
export @symbol("SDL_CreateSoftwareRenderer") fn SDL_CreateSoftwareRenderer(surface: *SDL_Surface) nullable *SDL_Renderer;
export @symbol("SDL_GetRenderer") fn SDL_GetRenderer(window: *SDL_Window) nullable *SDL_Renderer;
export @symbol("SDL_RenderGetWindow") fn SDL_RenderGetWindow(renderer: *SDL_Renderer) nullable *SDL_Window;
export @symbol("SDL_GetRendererInfo") fn SDL_GetRendererInfo(renderer: *SDL_Renderer, info: *SDL_RendererInfo) int;
export @symbol("SDL_GetRendererOutputSize") fn SDL_GetRendererOutputSize(renderer: *SDL_Renderer, w: nullable *int, h: nullable *int) int;
export @symbol("SDL_CreateTexture") fn SDL_CreateTexture(renderer: *SDL_Renderer, format: u32, access: int, w: int, h: int) nullable *SDL_Texture;
export @symbol("SDL_CreateTextureFromSurface") fn SDL_CreateTextureFromSurface(renderer: *SDL_Renderer, surface: *SDL_Surface) nullable *SDL_Texture;
export @symbol("SDL_QueryTexture") fn SDL_QueryTexture(texture: *SDL_Texture, format: nullable *u32, access: nullable *int, w: nullable *int, h: nullable *int) int;
export @symbol("SDL_SetTextureColorMod") fn SDL_SetTextureColorMod(texture: *SDL_Texture, r: u8, g: u8, b: u8) int;
export @symbol("SDL_GetTextureColorMod") fn SDL_GetTextureColorMod(texture: *SDL_Texture, r: *u8, g: *u8, b: *u8) int;
export @symbol("SDL_SetTextureAlphaMod") fn SDL_SetTextureAlphaMod(texture: *SDL_Texture, alpha: u8) int;
export @symbol("SDL_GetTextureAlphaMod") fn SDL_GetTextureAlphaMod(texture: *SDL_Texture, alpha: *u8) int;
export @symbol("SDL_SetTextureBlendMode") fn SDL_SetTextureBlendMode(texture: *SDL_Texture, blendMode: SDL_BlendMode) int;
export @symbol("SDL_GetTextureBlendMode") fn SDL_GetTextureBlendMode(texture: *SDL_Texture, blendMode: *SDL_BlendMode) int;
export @symbol("SDL_SetTextureScaleMode") fn SDL_SetTextureScaleMode(texture: *SDL_Texture, scaleMode: SDL_ScaleMode) int;
export @symbol("SDL_GetTextureScaleMode") fn SDL_GetTextureScaleMode(texture: *SDL_Texture, scaleMode: *SDL_ScaleMode) int;
export @symbol("SDL_SetTextureUserData") fn SDL_SetTextureUserData(texture: *SDL_Texture, userdata: nullable *opaque) int;
export @symbol("SDL_GetTextureUserData") fn SDL_GetTextureUserData(texture: *SDL_Texture) nullable *opaque;
export @symbol("SDL_UpdateTexture") fn SDL_UpdateTexture(texture: *SDL_Texture, rect: nullable *SDL_Rect, pixels: *opaque, pitch: int) int;
export @symbol("SDL_UpdateYUVTexture") fn SDL_UpdateYUVTexture(texture: *SDL_Texture, rect: nullable *SDL_Rect, Yplane: *u8, Ypitch: int, Uplane: *u8, Upitch: int, Vplane: *u8, Vpitch: int) int;
export @symbol("SDL_UpdateNVTexture") fn SDL_UpdateNVTexture(texture: *SDL_Texture, rect: nullable *SDL_Rect, Yplane: *u8, Ypitch: int, UVplane: *u8, UVpitch: int) int;
export @symbol("SDL_LockTexture") fn SDL_LockTexture(texture: *SDL_Texture, rect: nullable *SDL_Rect, pixels: **opaque, pitch: *int) int;
export @symbol("SDL_LockTextureToSurface") fn SDL_LockTextureToSurface(texture: *SDL_Texture, rect: nullable *SDL_Rect, surface: **SDL_Surface) int;
export @symbol("SDL_UnlockTexture") fn SDL_UnlockTexture(texture: *SDL_Texture) void;
export @symbol("SDL_RenderTargetSupported") fn SDL_RenderTargetSupported(renderer: *SDL_Renderer) bool;
export @symbol("SDL_SetRenderTarget") fn SDL_SetRenderTarget(renderer: *SDL_Renderer, texture: nullable *SDL_Texture) int;
export @symbol("SDL_GetRenderTarget") fn SDL_GetRenderTarget(renderer: *SDL_Renderer) nullable *SDL_Texture;
export @symbol("SDL_RenderSetLogicalSize") fn SDL_RenderSetLogicalSize(renderer: *SDL_Renderer, w: int, h: int) int;
export @symbol("SDL_RenderGetLogicalSize") fn SDL_RenderGetLogicalSize(renderer: *SDL_Renderer, w: *int, h: *int) void;
export @symbol("SDL_RenderSetIntegerScale") fn SDL_RenderSetIntegerScale(renderer: *SDL_Renderer, enable: bool) int;
export @symbol("SDL_RenderGetIntegerScale") fn SDL_RenderGetIntegerScale(renderer: *SDL_Renderer) bool;
export @symbol("SDL_RenderSetViewport") fn SDL_RenderSetViewport(renderer: *SDL_Renderer, rect: nullable *SDL_Rect) int;
export @symbol("SDL_RenderGetViewport") fn SDL_RenderGetViewport(renderer: *SDL_Renderer, rect: *SDL_Rect) void;
export @symbol("SDL_RenderSetClipRect") fn SDL_RenderSetClipRect(renderer: *SDL_Renderer, rect: nullable *SDL_Rect) int;
export @symbol("SDL_RenderGetClipRect") fn SDL_RenderGetClipRect(renderer: *SDL_Renderer, rect: *SDL_Rect) void;
export @symbol("SDL_RenderIsClipEnabled") fn SDL_RenderIsClipEnabled(renderer: *SDL_Renderer) bool;
export @symbol("SDL_RenderSetScale") fn SDL_RenderSetScale(renderer: *SDL_Renderer, scaleX: f32, scaleY: f32) int;
export @symbol("SDL_RenderGetScale") fn SDL_RenderGetScale(renderer: *SDL_Renderer, scaleX: *f32, scaleY: *f32) void;
export @symbol("SDL_RenderWindowToLogical") fn SDL_RenderWindowToLogical(renderer: *SDL_Renderer, windowX: int, windowY: int, logicalX: *f32, logicalY: *f32) void;
export @symbol("SDL_RenderLogicalToWindow") fn SDL_RenderLogicalToWindow(renderer: *SDL_Renderer, logicalX: f32, logicalY: f32, windowX: *int, windowY: *int) void;
export @symbol("SDL_SetRenderDrawColor") fn SDL_SetRenderDrawColor(renderer: *SDL_Renderer, r: u8, g: u8, b: u8, a: u8) int;
export @symbol("SDL_GetRenderDrawColor") fn SDL_GetRenderDrawColor(renderer: *SDL_Renderer, r: *u8, g: *u8, b: *u8, a: *u8) int;
export @symbol("SDL_SetRenderDrawBlendMode") fn SDL_SetRenderDrawBlendMode(renderer: *SDL_Renderer, blendMode: SDL_BlendMode) int;
export @symbol("SDL_GetRenderDrawBlendMode") fn SDL_GetRenderDrawBlendMode(renderer: *SDL_Renderer, blendMode: *SDL_BlendMode) int;
export @symbol("SDL_RenderClear") fn SDL_RenderClear(renderer: *SDL_Renderer) int;
export @symbol("SDL_RenderDrawPoint") fn SDL_RenderDrawPoint(renderer: *SDL_Renderer, x: int, y: int) int;
export @symbol("SDL_RenderDrawPoints") fn SDL_RenderDrawPoints(renderer: *SDL_Renderer, points: *SDL_Point, count: int) int;
export @symbol("SDL_RenderDrawLine") fn SDL_RenderDrawLine(renderer: *SDL_Renderer, x1: int, y1: int, x2: int, y2: int) int;
export @symbol("SDL_RenderDrawLines") fn SDL_RenderDrawLines(renderer: *SDL_Renderer, points: *SDL_Point, count: int) int;
export @symbol("SDL_RenderDrawRect") fn SDL_RenderDrawRect(renderer: *SDL_Renderer, rect: nullable *SDL_Rect) int;
export @symbol("SDL_RenderDrawRects") fn SDL_RenderDrawRects(renderer: *SDL_Renderer, rects: *SDL_Rect, count: int) int;
export @symbol("SDL_RenderFillRect") fn SDL_RenderFillRect(renderer: *SDL_Renderer, rect: nullable *SDL_Rect) int;
export @symbol("SDL_RenderFillRects") fn SDL_RenderFillRects(renderer: *SDL_Renderer, rects: *SDL_Rect, count: int) int;
export @symbol("SDL_RenderCopy") fn SDL_RenderCopy(renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: nullable *SDL_Rect, dstrect: nullable *SDL_Rect) int;
export @symbol("SDL_RenderCopyEx") fn SDL_RenderCopyEx(renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: nullable *SDL_Rect, dstrect: nullable *SDL_Rect, angle: f64, center: nullable *SDL_Point, flip: SDL_RendererFlip) int;
export @symbol("SDL_RenderDrawPointF") fn SDL_RenderDrawPointF(renderer: *SDL_Renderer, x: f32, y: f32) int;
export @symbol("SDL_RenderDrawPointsF") fn SDL_RenderDrawPointsF(renderer: *SDL_Renderer, points: *SDL_FPoint, count: int) int;
export @symbol("SDL_RenderDrawLineF") fn SDL_RenderDrawLineF(renderer: *SDL_Renderer, x1: f32, y1: f32, x2: f32, y2: f32) int;
export @symbol("SDL_RenderDrawLinesF") fn SDL_RenderDrawLinesF(renderer: *SDL_Renderer, points: *SDL_FPoint, count: int) int;
export @symbol("SDL_RenderDrawRectF") fn SDL_RenderDrawRectF(renderer: *SDL_Renderer, rect: nullable *SDL_FRect) int;
export @symbol("SDL_RenderDrawRectsF") fn SDL_RenderDrawRectsF(renderer: *SDL_Renderer, rects: *SDL_FRect, count: int) int;
export @symbol("SDL_RenderFillRectF") fn SDL_RenderFillRectF(renderer: *SDL_Renderer, rect: nullable *SDL_FRect) int;
export @symbol("SDL_RenderFillRectsF") fn SDL_RenderFillRectsF(renderer: *SDL_Renderer, rects: *SDL_FRect, count: int) int;
export @symbol("SDL_RenderCopyF") fn SDL_RenderCopyF(renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: nullable *SDL_Rect, dstrect: nullable *SDL_FRect) int;
export @symbol("SDL_RenderCopyExF") fn SDL_RenderCopyExF(renderer: *SDL_Renderer, texture: *SDL_Texture, srcrect: nullable *SDL_Rect, dstrect: nullable *SDL_FRect, angle: f64, center: nullable *SDL_FPoint, flip: SDL_RendererFlip) int;
export @symbol("SDL_RenderGeometry") fn SDL_RenderGeometry(renderer: *SDL_Renderer, texture: nullable *SDL_Texture, vertices: *SDL_Vertex, num_vertices: int, indices: nullable *int, num_indices: int) int;
export @symbol("SDL_RenderGeometryRaw") fn SDL_RenderGeometryRaw(renderer: *SDL_Renderer, texture: nullable *SDL_Texture, xy: *f32, xy_stride: int, color: *SDL_Color, color_stride: int, uv: *f32, uv_stride: int, num_vertices: int, indices: nullable *opaque, num_indices: int, size_indices: int) int;
export @symbol("SDL_RenderReadPixels") fn SDL_RenderReadPixels(renderer: *SDL_Renderer, rect: nullable *SDL_Rect, format: u32, pixels: *opaque, pitch: int) int;
export @symbol("SDL_RenderPresent") fn SDL_RenderPresent(renderer: *SDL_Renderer) void;
export @symbol("SDL_DestroyTexture") fn SDL_DestroyTexture(texture: *SDL_Texture) void;
export @symbol("SDL_DestroyRenderer") fn SDL_DestroyRenderer(renderer: *SDL_Renderer) void;
export @symbol("SDL_RenderFlush") fn SDL_RenderFlush(renderer: *SDL_Renderer) int;
export @symbol("SDL_GL_BindTexture") fn SDL_GL_BindTexture(texture: *SDL_Texture, texw: nullable *f32, texh: nullable *f32) int;
export @symbol("SDL_GL_UnbindTexture") fn SDL_GL_UnbindTexture(texture: *SDL_Texture) int;
export @symbol("SDL_RenderSetVSync") fn SDL_RenderSetVSync(renderer: *SDL_Renderer, vsync: int) int;
