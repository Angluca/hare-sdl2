use strings;

export type SDL_Scancode = enum uint {
	UNKNOWN = 0,

	// Usage page 0x07
	// These values are from usage page 0x07 (USB keyboard page).

	A = 4,
	B = 5,
	C = 6,
	D = 7,
	E = 8,
	F = 9,
	G = 10,
	H = 11,
	I = 12,
	J = 13,
	K = 14,
	L = 15,
	M = 16,
	N = 17,
	O = 18,
	P = 19,
	Q = 20,
	R = 21,
	S = 22,
	T = 23,
	U = 24,
	V = 25,
	W = 26,
	X = 27,
	Y = 28,
	Z = 29,

	ONE = 30,
	TWO = 31,
	THREE = 32,
	FOUR = 33,
	FIVE = 34,
	SIX = 35,
	SEVEN = 36,
	EIGHT = 37,
	NINE = 38,
	ZERO = 39,

	RETURN = 40,
	ESCAPE = 41,
	BACKSPACE = 42,
	TAB = 43,
	SPACE = 44,

	MINUS = 45,
	EQUALS = 46,
	LEFTBRACKET = 47,
	RIGHTBRACKET = 48,
	// Located at the lower left of the return
	// key on ISO keyboards and at the right end
	// of the QWERTY row on ANSI keyboards.
	// Produces REVERSE SOLIDUS (backslash) and
	// VERTICAL LINE in a US layout, REVERSE
	// SOLIDUS and VERTICAL LINE in a UK Mac
	// layout, NUMBER SIGN and TILDE in a UK
	// Windows layout, DOLLAR SIGN and POUND SIGN
	// in a Swiss German layout, NUMBER SIGN and
	// APOSTROPHE in a German layout, GRAVE
	// ACCENT and POUND SIGN in a French Mac
	// layout, and ASTERISK and MICRO SIGN in a
	// French Windows layout.
	BACKSLASH = 49,
	NONUSHASH = 50,
	// ISO USB keyboards actually use this code
	// instead of 49 for the same key, but all
	// OSes I've seen treat the two codes
	// identically. So, as an implementor, unless
	// your keyboard generates both of those
	// codes and your OS treats them differently,
	// you should generate BACKSLASH
	// instead of this code. As a user, you
	// should not rely on this code because SDL
	// will never generate it with most (all?)
	// keyboards.
	SEMICOLON = 51,
	APOSTROPHE = 52,
	// Located in the top left corner (on both ANSI
	// and ISO keyboards). Produces GRAVE ACCENT and
	// TILDE in a US Windows layout and in US and UK
	// Mac layouts on ANSI keyboards, GRAVE ACCENT
	// and NOT SIGN in a UK Windows layout, SECTION
	// SIGN and PLUS-MINUS SIGN in US and UK Mac
	// layouts on ISO keyboards, SECTION SIGN and
	// DEGREE SIGN in a Swiss German layout (Mac:
	// only on ISO keyboards), CIRCUMFLEX ACCENT and
	// DEGREE SIGN in a German layout (Mac: only on
	// ISO keyboards), SUPERSCRIPT TWO and TILDE in a
	// French Windows layout, COMMERCIAL AT and
	// NUMBER SIGN in a French Mac layout on ISO
	// keyboards, and LESS-THAN SIGN and GREATER-THAN
	// SIGN in a Swiss German, German, or French Mac
	// layout on ANSI keyboards.
	GRAVE = 53,
	COMMA = 54,
	PERIOD = 55,
	SLASH = 56,

	CAPSLOCK = 57,

	F1 = 58,
	F2 = 59,
	F3 = 60,
	F4 = 61,
	F5 = 62,
	F6 = 63,
	F7 = 64,
	F8 = 65,
	F9 = 66,
	F10 = 67,
	F11 = 68,
	F12 = 69,

	PRINTSCREEN = 70,
	SCROLLLOCK = 71,
	PAUSE = 72,
	// insert on PC, help on some Mac keyboards (but does send code 73,
	// not 117)
	INSERT = 73,
	HOME = 74,
	PAGEUP = 75,
	DELETE = 76,
	END = 77,
	PAGEDOWN = 78,
	RIGHT = 79,
	LEFT = 80,
	DOWN = 81,
	UP = 82,

	NUMLOCKCLEAR = 83, // num lock on PC, clear on Mac keyboards
	KP_DIVIDE = 84,
	KP_MULTIPLY = 85,
	KP_MINUS = 86,
	KP_PLUS = 87,
	KP_ENTER = 88,
	KP_1 = 89,
	KP_2 = 90,
	KP_3 = 91,
	KP_4 = 92,
	KP_5 = 93,
	KP_6 = 94,
	KP_7 = 95,
	KP_8 = 96,
	KP_9 = 97,
	KP_0 = 98,
	KP_PERIOD = 99,

	// This is the additional key that ISO
	// keyboards have over ANSI ones,
	// located between left shift and Y.
	// Produces GRAVE ACCENT and TILDE in a
	// US or UK Mac layout, REVERSE SOLIDUS
	// (backslash) and VERTICAL LINE in a
	// US or UK Windows layout, and
	// LESS-THAN SIGN and GREATER-THAN SIGN
	// in a Swiss German, German, or French
	// layout. */
	NONUSBACKSLASH = 100,
	APPLICATION = 101, // windows contextual menu, compose
	// The USB document says this is a status flag, not a physical key - but
	// some Mac keyboards do have a power key.
	POWER = 102,
	KP_EQUALS = 103,
	F13 = 104,
	F14 = 105,
	F15 = 106,
	F16 = 107,
	F17 = 108,
	F18 = 109,
	F19 = 110,
	F20 = 111,
	F21 = 112,
	F22 = 113,
	F23 = 114,
	F24 = 115,
	EXECUTE = 116,
	HELP = 117,
	MENU = 118,
	SELECT = 119,
	STOP = 120,
	AGAIN = 121, // redo
	UNDO = 122,
	CUT = 123,
	COPY = 124,
	PASTE = 125,
	FIND = 126,
	MUTE = 127,
	VOLUMEUP = 128,
	VOLUMEDOWN = 129,
// not sure whether there's a reason to enable these
//	LOCKINGCAPSLOCK = 130,
//	LOCKINGNUMLOCK = 131,
//	LOCKINGSCROLLLOCK = 132,
	KP_COMMA = 133,
	KP_EQUALSAS400 = 134,

	// used on Asian keyboards, see footnotes in USB doc
	INTERNATIONAL1 = 135,
	INTERNATIONAL2 = 136,
	INTERNATIONAL3 = 137, // Yen
	INTERNATIONAL4 = 138,
	INTERNATIONAL5 = 139,
	INTERNATIONAL6 = 140,
	INTERNATIONAL7 = 141,
	INTERNATIONAL8 = 142,
	INTERNATIONAL9 = 143,
	LANG1 = 144, // Hangul/English toggle
	LANG2 = 145, // Hanja conversion
	LANG3 = 146, // Katakana
	LANG4 = 147, // Hiragana
	LANG5 = 148, // Zenkaku/Hankaku
	LANG6 = 149, // reserved
	LANG7 = 150, // reserved
	LANG8 = 151, // reserved
	LANG9 = 152, // reserved

	ALTERASE = 153, // Erase-Eaze
	SYSREQ = 154,
	CANCEL = 155,
	CLEAR = 156,
	PRIOR = 157,
	RETURN2 = 158,
	SEPARATOR = 159,
	OUT = 160,
	OPER = 161,
	CLEARAGAIN = 162,
	CRSEL = 163,
	EXSEL = 164,

	KP_00 = 176,
	KP_000 = 177,
	THOUSANDSSEPARATOR = 178,
	DECIMALSEPARATOR = 179,
	CURRENCYUNIT = 180,
	CURRENCYSUBUNIT = 181,
	KP_LEFTPAREN = 182,
	KP_RIGHTPAREN = 183,
	KP_LEFTBRACE = 184,
	KP_RIGHTBRACE = 185,
	KP_TAB = 186,
	KP_BACKSPACE = 187,
	KP_A = 188,
	KP_B = 189,
	KP_C = 190,
	KP_D = 191,
	KP_E = 192,
	KP_F = 193,
	KP_XOR = 194,
	KP_POWER = 195,
	KP_PERCENT = 196,
	KP_LESS = 197,
	KP_GREATER = 198,
	KP_AMPERSAND = 199,
	KP_DBLAMPERSAND = 200,
	KP_VERTICALBAR = 201,
	KP_DBLVERTICALBAR = 202,
	KP_COLON = 203,
	KP_HASH = 204,
	KP_SPACE = 205,
	KP_AT = 206,
	KP_EXCLAM = 207,
	KP_MEMSTORE = 208,
	KP_MEMRECALL = 209,
	KP_MEMCLEAR = 210,
	KP_MEMADD = 211,
	KP_MEMSUBTRACT = 212,
	KP_MEMMULTIPLY = 213,
	KP_MEMDIVIDE = 214,
	KP_PLUSMINUS = 215,
	KP_CLEAR = 216,
	KP_CLEARENTRY = 217,
	KP_BINARY = 218,
	KP_OCTAL = 219,
	KP_DECIMAL = 220,
	KP_HEXADECIMAL = 221,

	LCTRL = 224,
	LSHIFT = 225,
	LALT = 226, // alt, option
	LGUI = 227, // windows, command (apple), meta
	RCTRL = 228,
	RSHIFT = 229,
	RALT = 230, // alt gr, option
	RGUI = 231, // windows, command (apple), meta

	// I'm not sure if this is really not covered by any of the above, but
	// since there's a special KMOD_MODE for it I'm adding it here
	MODE = 257,

	// Usage page 0x0C
	// These values are mapped from usage page 0x0C (USB consumer page).

	AUDIONEXT = 258,
	AUDIOPREV = 259,
	AUDIOSTOP = 260,
	AUDIOPLAY = 261,
	AUDIOMUTE = 262,
	MEDIASELECT = 263,
	WWW = 264,
	MAIL = 265,
	CALCULATOR = 266,
	COMPUTER = 267,
	AC_SEARCH = 268,
	AC_HOME = 269,
	AC_BACK = 270,
	AC_FORWARD = 271,
	AC_STOP = 272,
	AC_REFRESH = 273,
	AC_BOOKMARKS = 274,

	// Walther keys
	// These are values that Christian Walther added (for mac keyboard?).

	BRIGHTNESSDOWN = 275,
	BRIGHTNESSUP = 276,
	// display mirroring/dual display switch, video mode switch
	DISPLAYSWITCH = 277,
	KBDILLUMTOGGLE = 278,
	KBDILLUMDOWN = 279,
	KBDILLUMUP = 280,
	EJECT = 281,
	SLEEP = 282,

	APP1 = 283,
	APP2 = 284,

	// Usage page 0x0C (additional media keys)
	// These values are mapped from usage page 0x0C (USB consumer page).

	AUDIOREWIND = 285,
	AUDIOFASTFORWARD = 286,

	// Add any other keys here.

	// not a key, just marks the number of scancodes for array bounds
	NUM_SCANCODES = 512,
};

export type SDL_Keycode = enum uint {
	UNKNOWN = 0,

	RETURN = '\r',
	ESCAPE = '\x1B',
	BACKSPACE = '\b',
	TAB = '\t',
	SPACE = ' ',
	EXCLAIM = '!',
	QUOTEDBL = '"',
	HASH = '#',
	PERCENT = '%',
	DOLLAR = '$',
	AMPERSAND = '&',
	QUOTE = '\'',
	LEFTPAREN = '(',
	RIGHTPAREN = ')',
	ASTERISK = '*',
	PLUS = '+',
	COMMA = ',',
	MINUS = '-',
	PERIOD = '.',
	SLASH = '/',
	ZERO = '0',
	ONE = '1',
	TWO = '2',
	THREE = '3',
	FOUR = '4',
	FIVE = '5',
	SIX = '6',
	SEVEN = '7',
	EIGHT = '8',
	NINE = '9',
	COLON = ':',
	SEMICOLON = ';',
	LESS = '<',
	EQUALS = '=',
	GREATER = '>',
	QUESTION = '?',
	AT = '@',

	// Skip uppercase letters

	LEFTBRACKET = '[',
	BACKSLASH = '\\',
	RIGHTBRACKET = ']',
	CARET = '^',
	UNDERSCORE = '_',
	BACKQUOTE = '`',
	a = 'a',
	b = 'b',
	c = 'c',
	d = 'd',
	e = 'e',
	f = 'f',
	g = 'g',
	h = 'h',
	i = 'i',
	j = 'j',
	k = 'k',
	l = 'l',
	m = 'm',
	n = 'n',
	o = 'o',
	p = 'p',
	q = 'q',
	r = 'r',
	s = 's',
	t = 't',
	u = 'u',
	v = 'v',
	w = 'w',
	x = 'x',
	y = 'y',
	z = 'z',

	CAPSLOCK = SDL_Scancode::CAPSLOCK | 1: SDL_Scancode << 30,

	F1 = SDL_Scancode::F1 | 1: SDL_Scancode << 30,
	F2 = SDL_Scancode::F2 | 1: SDL_Scancode << 30,
	F3 = SDL_Scancode::F3 | 1: SDL_Scancode << 30,
	F4 = SDL_Scancode::F4 | 1: SDL_Scancode << 30,
	F5 = SDL_Scancode::F5 | 1: SDL_Scancode << 30,
	F6 = SDL_Scancode::F6 | 1: SDL_Scancode << 30,
	F7 = SDL_Scancode::F7 | 1: SDL_Scancode << 30,
	F8 = SDL_Scancode::F8 | 1: SDL_Scancode << 30,
	F9 = SDL_Scancode::F9 | 1: SDL_Scancode << 30,
	F10 = SDL_Scancode::F10 | 1: SDL_Scancode << 30,
	F11 = SDL_Scancode::F11 | 1: SDL_Scancode << 30,
	F12 = SDL_Scancode::F12 | 1: SDL_Scancode << 30,

	PRINTSCREEN = SDL_Scancode::PRINTSCREEN | 1: SDL_Scancode << 30,
	SCROLLLOCK = SDL_Scancode::SCROLLLOCK | 1: SDL_Scancode << 30,
	PAUSE = SDL_Scancode::PAUSE | 1: SDL_Scancode << 30,
	INSERT = SDL_Scancode::INSERT | 1: SDL_Scancode << 30,
	HOME = SDL_Scancode::HOME | 1: SDL_Scancode << 30,
	PAGEUP = SDL_Scancode::PAGEUP | 1: SDL_Scancode << 30,
	DELETE = '\x7F',
	END = SDL_Scancode::END | 1: SDL_Scancode << 30,
	PAGEDOWN = SDL_Scancode::PAGEDOWN | 1: SDL_Scancode << 30,
	RIGHT = SDL_Scancode::RIGHT | 1: SDL_Scancode << 30,
	LEFT = SDL_Scancode::LEFT | 1: SDL_Scancode << 30,
	DOWN = SDL_Scancode::DOWN | 1: SDL_Scancode << 30,
	UP = SDL_Scancode::UP | 1: SDL_Scancode << 30,

	NUMLOCKCLEAR = SDL_Scancode::NUMLOCKCLEAR | 1: SDL_Scancode << 30,
	KP_DIVIDE = SDL_Scancode::KP_DIVIDE | 1: SDL_Scancode << 30,
	KP_MULTIPLY = SDL_Scancode::KP_MULTIPLY | 1: SDL_Scancode << 30,
	KP_MINUS = SDL_Scancode::KP_MINUS | 1: SDL_Scancode << 30,
	KP_PLUS = SDL_Scancode::KP_PLUS | 1: SDL_Scancode << 30,
	KP_ENTER = SDL_Scancode::KP_ENTER | 1: SDL_Scancode << 30,
	KP_1 = SDL_Scancode::KP_1 | 1: SDL_Scancode << 30,
	KP_2 = SDL_Scancode::KP_2 | 1: SDL_Scancode << 30,
	KP_3 = SDL_Scancode::KP_3 | 1: SDL_Scancode << 30,
	KP_4 = SDL_Scancode::KP_4 | 1: SDL_Scancode << 30,
	KP_5 = SDL_Scancode::KP_5 | 1: SDL_Scancode << 30,
	KP_6 = SDL_Scancode::KP_6 | 1: SDL_Scancode << 30,
	KP_7 = SDL_Scancode::KP_7 | 1: SDL_Scancode << 30,
	KP_8 = SDL_Scancode::KP_8 | 1: SDL_Scancode << 30,
	KP_9 = SDL_Scancode::KP_9 | 1: SDL_Scancode << 30,
	KP_0 = SDL_Scancode::KP_0 | 1: SDL_Scancode << 30,
	KP_PERIOD = SDL_Scancode::KP_PERIOD | 1: SDL_Scancode << 30,

	APPLICATION = SDL_Scancode::APPLICATION | 1: SDL_Scancode << 30,
	POWER = SDL_Scancode::POWER | 1: SDL_Scancode << 30,
	KP_EQUALS = SDL_Scancode::KP_EQUALS | 1: SDL_Scancode << 30,
	F13 = SDL_Scancode::F13 | 1: SDL_Scancode << 30,
	F14 = SDL_Scancode::F14 | 1: SDL_Scancode << 30,
	F15 = SDL_Scancode::F15 | 1: SDL_Scancode << 30,
	F16 = SDL_Scancode::F16 | 1: SDL_Scancode << 30,
	F17 = SDL_Scancode::F17 | 1: SDL_Scancode << 30,
	F18 = SDL_Scancode::F18 | 1: SDL_Scancode << 30,
	F19 = SDL_Scancode::F19 | 1: SDL_Scancode << 30,
	F20 = SDL_Scancode::F20 | 1: SDL_Scancode << 30,
	F21 = SDL_Scancode::F21 | 1: SDL_Scancode << 30,
	F22 = SDL_Scancode::F22 | 1: SDL_Scancode << 30,
	F23 = SDL_Scancode::F23 | 1: SDL_Scancode << 30,
	F24 = SDL_Scancode::F24 | 1: SDL_Scancode << 30,
	EXECUTE = SDL_Scancode::EXECUTE | 1: SDL_Scancode << 30,
	HELP = SDL_Scancode::HELP | 1: SDL_Scancode << 30,
	MENU = SDL_Scancode::MENU | 1: SDL_Scancode << 30,
	SELECT = SDL_Scancode::SELECT | 1: SDL_Scancode << 30,
	STOP = SDL_Scancode::STOP | 1: SDL_Scancode << 30,
	AGAIN = SDL_Scancode::AGAIN | 1: SDL_Scancode << 30,
	UNDO = SDL_Scancode::UNDO | 1: SDL_Scancode << 30,
	CUT = SDL_Scancode::CUT | 1: SDL_Scancode << 30,
	COPY = SDL_Scancode::COPY | 1: SDL_Scancode << 30,
	PASTE = SDL_Scancode::PASTE | 1: SDL_Scancode << 30,
	FIND = SDL_Scancode::FIND | 1: SDL_Scancode << 30,
	MUTE = SDL_Scancode::MUTE | 1: SDL_Scancode << 30,
	VOLUMEUP = SDL_Scancode::VOLUMEUP | 1: SDL_Scancode << 30,
	VOLUMEDOWN = SDL_Scancode::VOLUMEDOWN | 1: SDL_Scancode << 30,
	KP_COMMA = SDL_Scancode::KP_COMMA | 1: SDL_Scancode << 30,
	KP_EQUALSAS400 = SDL_Scancode::KP_EQUALSAS400 | 1: SDL_Scancode << 30,

	ALTERASE = SDL_Scancode::ALTERASE | 1: SDL_Scancode << 30,
	SYSREQ = SDL_Scancode::SYSREQ | 1: SDL_Scancode << 30,
	CANCEL = SDL_Scancode::CANCEL | 1: SDL_Scancode << 30,
	CLEAR = SDL_Scancode::CLEAR | 1: SDL_Scancode << 30,
	PRIOR = SDL_Scancode::PRIOR | 1: SDL_Scancode << 30,
	RETURN2 = SDL_Scancode::RETURN2 | 1: SDL_Scancode << 30,
	SEPARATOR = SDL_Scancode::SEPARATOR | 1: SDL_Scancode << 30,
	OUT = SDL_Scancode::OUT | 1: SDL_Scancode << 30,
	OPER = SDL_Scancode::OPER | 1: SDL_Scancode << 30,
	CLEARAGAIN = SDL_Scancode::CLEARAGAIN | 1: SDL_Scancode << 30,
	CRSEL = SDL_Scancode::CRSEL | 1: SDL_Scancode << 30,
	EXSEL = SDL_Scancode::EXSEL | 1: SDL_Scancode << 30,

	KP_00 = SDL_Scancode::KP_00 | 1: SDL_Scancode << 30,
	KP_000 = SDL_Scancode::KP_000 | 1: SDL_Scancode << 30,
	THOUSANDSSEPARATOR = SDL_Scancode::THOUSANDSSEPARATOR | 1: SDL_Scancode << 30,
	DECIMALSEPARATOR = SDL_Scancode::DECIMALSEPARATOR | 1: SDL_Scancode << 30,
	CURRENCYUNIT = SDL_Scancode::CURRENCYUNIT | 1: SDL_Scancode << 30,
	CURRENCYSUBUNIT = SDL_Scancode::CURRENCYSUBUNIT | 1: SDL_Scancode << 30,
	KP_LEFTPAREN = SDL_Scancode::KP_LEFTPAREN | 1: SDL_Scancode << 30,
	KP_RIGHTPAREN = SDL_Scancode::KP_RIGHTPAREN | 1: SDL_Scancode << 30,
	KP_LEFTBRACE = SDL_Scancode::KP_LEFTBRACE | 1: SDL_Scancode << 30,
	KP_RIGHTBRACE = SDL_Scancode::KP_RIGHTBRACE | 1: SDL_Scancode << 30,
	KP_TAB = SDL_Scancode::KP_TAB | 1: SDL_Scancode << 30,
	KP_BACKSPACE = SDL_Scancode::KP_BACKSPACE | 1: SDL_Scancode << 30,
	KP_A = SDL_Scancode::KP_A | 1: SDL_Scancode << 30,
	KP_B = SDL_Scancode::KP_B | 1: SDL_Scancode << 30,
	KP_C = SDL_Scancode::KP_C | 1: SDL_Scancode << 30,
	KP_D = SDL_Scancode::KP_D | 1: SDL_Scancode << 30,
	KP_E = SDL_Scancode::KP_E | 1: SDL_Scancode << 30,
	KP_F = SDL_Scancode::KP_F | 1: SDL_Scancode << 30,
	KP_XOR = SDL_Scancode::KP_XOR | 1: SDL_Scancode << 30,
	KP_POWER = SDL_Scancode::KP_POWER | 1: SDL_Scancode << 30,
	KP_PERCENT = SDL_Scancode::KP_PERCENT | 1: SDL_Scancode << 30,
	KP_LESS = SDL_Scancode::KP_LESS | 1: SDL_Scancode << 30,
	KP_GREATER = SDL_Scancode::KP_GREATER | 1: SDL_Scancode << 30,
	KP_AMPERSAND = SDL_Scancode::KP_AMPERSAND | 1: SDL_Scancode << 30,
	KP_DBLAMPERSAND = SDL_Scancode::KP_DBLAMPERSAND | 1: SDL_Scancode << 30,
	KP_VERTICALBAR = SDL_Scancode::KP_VERTICALBAR | 1: SDL_Scancode << 30,
	KP_DBLVERTICALBAR = SDL_Scancode::KP_DBLVERTICALBAR | 1: SDL_Scancode << 30,
	KP_COLON = SDL_Scancode::KP_COLON | 1: SDL_Scancode << 30,
	KP_HASH = SDL_Scancode::KP_HASH | 1: SDL_Scancode << 30,
	KP_SPACE = SDL_Scancode::KP_SPACE | 1: SDL_Scancode << 30,
	KP_AT = SDL_Scancode::KP_AT | 1: SDL_Scancode << 30,
	KP_EXCLAM = SDL_Scancode::KP_EXCLAM | 1: SDL_Scancode << 30,
	KP_MEMSTORE = SDL_Scancode::KP_MEMSTORE | 1: SDL_Scancode << 30,
	KP_MEMRECALL = SDL_Scancode::KP_MEMRECALL | 1: SDL_Scancode << 30,
	KP_MEMCLEAR = SDL_Scancode::KP_MEMCLEAR | 1: SDL_Scancode << 30,
	KP_MEMADD = SDL_Scancode::KP_MEMADD | 1: SDL_Scancode << 30,
	KP_MEMSUBTRACT = SDL_Scancode::KP_MEMSUBTRACT | 1: SDL_Scancode << 30,
	KP_MEMMULTIPLY = SDL_Scancode::KP_MEMMULTIPLY | 1: SDL_Scancode << 30,
	KP_MEMDIVIDE = SDL_Scancode::KP_MEMDIVIDE | 1: SDL_Scancode << 30,
	KP_PLUSMINUS = SDL_Scancode::KP_PLUSMINUS | 1: SDL_Scancode << 30,
	KP_CLEAR = SDL_Scancode::KP_CLEAR | 1: SDL_Scancode << 30,
	KP_CLEARENTRY = SDL_Scancode::KP_CLEARENTRY | 1: SDL_Scancode << 30,
	KP_BINARY = SDL_Scancode::KP_BINARY | 1: SDL_Scancode << 30,
	KP_OCTAL = SDL_Scancode::KP_OCTAL | 1: SDL_Scancode << 30,
	KP_DECIMAL = SDL_Scancode::KP_DECIMAL | 1: SDL_Scancode << 30,
	KP_HEXADECIMAL = SDL_Scancode::KP_HEXADECIMAL | 1: SDL_Scancode << 30,

	LCTRL = SDL_Scancode::LCTRL | 1: SDL_Scancode << 30,
	LSHIFT = SDL_Scancode::LSHIFT | 1: SDL_Scancode << 30,
	LALT = SDL_Scancode::LALT | 1: SDL_Scancode << 30,
	LGUI = SDL_Scancode::LGUI | 1: SDL_Scancode << 30,
	RCTRL = SDL_Scancode::RCTRL | 1: SDL_Scancode << 30,
	RSHIFT = SDL_Scancode::RSHIFT | 1: SDL_Scancode << 30,
	RALT = SDL_Scancode::RALT | 1: SDL_Scancode << 30,
	RGUI = SDL_Scancode::RGUI | 1: SDL_Scancode << 30,

	MODE = SDL_Scancode::MODE | 1: SDL_Scancode << 30,

	AUDIONEXT = SDL_Scancode::AUDIONEXT | 1: SDL_Scancode << 30,
	AUDIOPREV = SDL_Scancode::AUDIOPREV | 1: SDL_Scancode << 30,
	AUDIOSTOP = SDL_Scancode::AUDIOSTOP | 1: SDL_Scancode << 30,
	AUDIOPLAY = SDL_Scancode::AUDIOPLAY | 1: SDL_Scancode << 30,
	AUDIOMUTE = SDL_Scancode::AUDIOMUTE | 1: SDL_Scancode << 30,
	MEDIASELECT = SDL_Scancode::MEDIASELECT | 1: SDL_Scancode << 30,
	WWW = SDL_Scancode::WWW | 1: SDL_Scancode << 30,
	MAIL = SDL_Scancode::MAIL | 1: SDL_Scancode << 30,
	CALCULATOR = SDL_Scancode::CALCULATOR | 1: SDL_Scancode << 30,
	COMPUTER = SDL_Scancode::COMPUTER | 1: SDL_Scancode << 30,
	AC_SEARCH = SDL_Scancode::AC_SEARCH | 1: SDL_Scancode << 30,
	AC_HOME = SDL_Scancode::AC_HOME | 1: SDL_Scancode << 30,
	AC_BACK = SDL_Scancode::AC_BACK | 1: SDL_Scancode << 30,
	AC_FORWARD = SDL_Scancode::AC_FORWARD | 1: SDL_Scancode << 30,
	AC_STOP = SDL_Scancode::AC_STOP | 1: SDL_Scancode << 30,
	AC_REFRESH = SDL_Scancode::AC_REFRESH | 1: SDL_Scancode << 30,
	AC_BOOKMARKS = SDL_Scancode::AC_BOOKMARKS | 1: SDL_Scancode << 30,

	BRIGHTNESSDOWN = SDL_Scancode::BRIGHTNESSDOWN | 1: SDL_Scancode << 30,
	BRIGHTNESSUP = SDL_Scancode::BRIGHTNESSUP | 1: SDL_Scancode << 30,
	DISPLAYSWITCH = SDL_Scancode::DISPLAYSWITCH | 1: SDL_Scancode << 30,
	KBDILLUMTOGGLE = SDL_Scancode::KBDILLUMTOGGLE | 1: SDL_Scancode << 30,
	KBDILLUMDOWN = SDL_Scancode::KBDILLUMDOWN | 1: SDL_Scancode << 30,
	KBDILLUMUP = SDL_Scancode::KBDILLUMUP | 1: SDL_Scancode << 30,
	EJECT = SDL_Scancode::EJECT | 1: SDL_Scancode << 30,
	SLEEP = SDL_Scancode::SLEEP | 1: SDL_Scancode << 30,
	APP1 = SDL_Scancode::APP1 | 1: SDL_Scancode << 30,
	APP2 = SDL_Scancode::APP2 | 1: SDL_Scancode << 30,

	AUDIOREWIND = SDL_Scancode::AUDIOREWIND | 1: SDL_Scancode << 30,
	AUDIOFASTFORWARD = SDL_Scancode::AUDIOFASTFORWARD | 1: SDL_Scancode << 30
};

export type SDL_Keymod = enum u16 {
	NONE = 0x0000,
	LSHIFT = 0x0001,
	RSHIFT = 0x0002,
	LCTRL = 0x0040,
	RCTRL = 0x0080,
	LALT = 0x0100,
	RALT = 0x0200,
	LGUI = 0x0400,
	RGUI = 0x0800,
	NUM = 0x1000,
	CAPS = 0x2000,
	MODE = 0x4000,
	SCROLL = 0x8000,

	CTRL = LCTRL | RCTRL,
	SHIFT = LSHIFT | RSHIFT,
	ALT = LALT | RALT,
	GUI = LGUI | RGUI,

	RESERVED = SCROLL,
};

export type SDL_Keysym = struct {
	scancode: SDL_Scancode,
	sym: SDL_Keycode,
	mod: SDL_Keymod,
	unused: u32,
};

@symbol("SDL_GetKeyFromName") fn _SDL_GetKeyFromName(name: *const char) SDL_Keycode;

export fn SDL_GetKeyFromName(name: str) (SDL_Keycode | error) = {
	const name = strings::to_c(name);
	defer free(name);
	const sym = _SDL_GetKeyFromName(name);
	if (sym == SDL_Keycode::UNKNOWN) {
		return strings::fromc(SDL_GetError()): error;
	};
	return sym;
};
