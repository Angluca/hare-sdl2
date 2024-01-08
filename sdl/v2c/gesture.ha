export type SDL_GestureID = i64;

export @symbol("SDL_RecordGesture") fn SDL_RecordGesture(touchId: SDL_TouchID) int;
export @symbol("SDL_SaveAllDollarTemplates") fn SDL_SaveAllDollarTemplates(dst: *SDL_RWops) int;
export @symbol("SDL_SaveDollarTemplate") fn SDL_SaveDollarTemplate(gestureId: SDL_GestureID, dst: *SDL_RWops) int;
export @symbol("SDL_LoadDollarTemplates") fn SDL_LoadDollarTemplates(touchId: SDL_TouchID, src: *SDL_RWops) int;
