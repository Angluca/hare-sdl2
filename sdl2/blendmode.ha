// TODO: Flesh me out

// The blend mode used in SDL_RenderCopy() and drawing operations.
export type blend_mode = enum {
    NONE = 0x00000000,
    BLEND = 0x00000001,
    ADD = 0x00000002,
    MOD = 0x00000004,
    MUL = 0x00000008,
    INVALID = 0x7FFFFFFF
};
