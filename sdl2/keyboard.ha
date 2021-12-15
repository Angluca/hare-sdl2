use strings;

export type scancode = enum uint {
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

export type keycode = enum uint {
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

	CAPSLOCK = scancode::CAPSLOCK | 1: scancode << 30,

	F1 = scancode::F1 | 1: scancode << 30,
	F2 = scancode::F2 | 1: scancode << 30,
	F3 = scancode::F3 | 1: scancode << 30,
	F4 = scancode::F4 | 1: scancode << 30,
	F5 = scancode::F5 | 1: scancode << 30,
	F6 = scancode::F6 | 1: scancode << 30,
	F7 = scancode::F7 | 1: scancode << 30,
	F8 = scancode::F8 | 1: scancode << 30,
	F9 = scancode::F9 | 1: scancode << 30,
	F10 = scancode::F10 | 1: scancode << 30,
	F11 = scancode::F11 | 1: scancode << 30,
	F12 = scancode::F12 | 1: scancode << 30,

	PRINTSCREEN = scancode::PRINTSCREEN | 1: scancode << 30,
	SCROLLLOCK = scancode::SCROLLLOCK | 1: scancode << 30,
	PAUSE = scancode::PAUSE | 1: scancode << 30,
	INSERT = scancode::INSERT | 1: scancode << 30,
	HOME = scancode::HOME | 1: scancode << 30,
	PAGEUP = scancode::PAGEUP | 1: scancode << 30,
	DELETE = '\x7F',
	END = scancode::END | 1: scancode << 30,
	PAGEDOWN = scancode::PAGEDOWN | 1: scancode << 30,
	RIGHT = scancode::RIGHT | 1: scancode << 30,
	LEFT = scancode::LEFT | 1: scancode << 30,
	DOWN = scancode::DOWN | 1: scancode << 30,
	UP = scancode::UP | 1: scancode << 30,

	NUMLOCKCLEAR = scancode::NUMLOCKCLEAR | 1: scancode << 30,
	KP_DIVIDE = scancode::KP_DIVIDE | 1: scancode << 30,
	KP_MULTIPLY = scancode::KP_MULTIPLY | 1: scancode << 30,
	KP_MINUS = scancode::KP_MINUS | 1: scancode << 30,
	KP_PLUS = scancode::KP_PLUS | 1: scancode << 30,
	KP_ENTER = scancode::KP_ENTER | 1: scancode << 30,
	KP_1 = scancode::KP_1 | 1: scancode << 30,
	KP_2 = scancode::KP_2 | 1: scancode << 30,
	KP_3 = scancode::KP_3 | 1: scancode << 30,
	KP_4 = scancode::KP_4 | 1: scancode << 30,
	KP_5 = scancode::KP_5 | 1: scancode << 30,
	KP_6 = scancode::KP_6 | 1: scancode << 30,
	KP_7 = scancode::KP_7 | 1: scancode << 30,
	KP_8 = scancode::KP_8 | 1: scancode << 30,
	KP_9 = scancode::KP_9 | 1: scancode << 30,
	KP_0 = scancode::KP_0 | 1: scancode << 30,
	KP_PERIOD = scancode::KP_PERIOD | 1: scancode << 30,

	APPLICATION = scancode::APPLICATION | 1: scancode << 30,
	POWER = scancode::POWER | 1: scancode << 30,
	KP_EQUALS = scancode::KP_EQUALS | 1: scancode << 30,
	F13 = scancode::F13 | 1: scancode << 30,
	F14 = scancode::F14 | 1: scancode << 30,
	F15 = scancode::F15 | 1: scancode << 30,
	F16 = scancode::F16 | 1: scancode << 30,
	F17 = scancode::F17 | 1: scancode << 30,
	F18 = scancode::F18 | 1: scancode << 30,
	F19 = scancode::F19 | 1: scancode << 30,
	F20 = scancode::F20 | 1: scancode << 30,
	F21 = scancode::F21 | 1: scancode << 30,
	F22 = scancode::F22 | 1: scancode << 30,
	F23 = scancode::F23 | 1: scancode << 30,
	F24 = scancode::F24 | 1: scancode << 30,
	EXECUTE = scancode::EXECUTE | 1: scancode << 30,
	HELP = scancode::HELP | 1: scancode << 30,
	MENU = scancode::MENU | 1: scancode << 30,
	SELECT = scancode::SELECT | 1: scancode << 30,
	STOP = scancode::STOP | 1: scancode << 30,
	AGAIN = scancode::AGAIN | 1: scancode << 30,
	UNDO = scancode::UNDO | 1: scancode << 30,
	CUT = scancode::CUT | 1: scancode << 30,
	COPY = scancode::COPY | 1: scancode << 30,
	PASTE = scancode::PASTE | 1: scancode << 30,
	FIND = scancode::FIND | 1: scancode << 30,
	MUTE = scancode::MUTE | 1: scancode << 30,
	VOLUMEUP = scancode::VOLUMEUP | 1: scancode << 30,
	VOLUMEDOWN = scancode::VOLUMEDOWN | 1: scancode << 30,
	KP_COMMA = scancode::KP_COMMA | 1: scancode << 30,
	KP_EQUALSAS400 = scancode::KP_EQUALSAS400 | 1: scancode << 30,

	ALTERASE = scancode::ALTERASE | 1: scancode << 30,
	SYSREQ = scancode::SYSREQ | 1: scancode << 30,
	CANCEL = scancode::CANCEL | 1: scancode << 30,
	CLEAR = scancode::CLEAR | 1: scancode << 30,
	PRIOR = scancode::PRIOR | 1: scancode << 30,
	RETURN2 = scancode::RETURN2 | 1: scancode << 30,
	SEPARATOR = scancode::SEPARATOR | 1: scancode << 30,
	OUT = scancode::OUT | 1: scancode << 30,
	OPER = scancode::OPER | 1: scancode << 30,
	CLEARAGAIN = scancode::CLEARAGAIN | 1: scancode << 30,
	CRSEL = scancode::CRSEL | 1: scancode << 30,
	EXSEL = scancode::EXSEL | 1: scancode << 30,

	KP_00 = scancode::KP_00 | 1: scancode << 30,
	KP_000 = scancode::KP_000 | 1: scancode << 30,
	THOUSANDSSEPARATOR = scancode::THOUSANDSSEPARATOR | 1: scancode << 30,
	DECIMALSEPARATOR = scancode::DECIMALSEPARATOR | 1: scancode << 30,
	CURRENCYUNIT = scancode::CURRENCYUNIT | 1: scancode << 30,
	CURRENCYSUBUNIT = scancode::CURRENCYSUBUNIT | 1: scancode << 30,
	KP_LEFTPAREN = scancode::KP_LEFTPAREN | 1: scancode << 30,
	KP_RIGHTPAREN = scancode::KP_RIGHTPAREN | 1: scancode << 30,
	KP_LEFTBRACE = scancode::KP_LEFTBRACE | 1: scancode << 30,
	KP_RIGHTBRACE = scancode::KP_RIGHTBRACE | 1: scancode << 30,
	KP_TAB = scancode::KP_TAB | 1: scancode << 30,
	KP_BACKSPACE = scancode::KP_BACKSPACE | 1: scancode << 30,
	KP_A = scancode::KP_A | 1: scancode << 30,
	KP_B = scancode::KP_B | 1: scancode << 30,
	KP_C = scancode::KP_C | 1: scancode << 30,
	KP_D = scancode::KP_D | 1: scancode << 30,
	KP_E = scancode::KP_E | 1: scancode << 30,
	KP_F = scancode::KP_F | 1: scancode << 30,
	KP_XOR = scancode::KP_XOR | 1: scancode << 30,
	KP_POWER = scancode::KP_POWER | 1: scancode << 30,
	KP_PERCENT = scancode::KP_PERCENT | 1: scancode << 30,
	KP_LESS = scancode::KP_LESS | 1: scancode << 30,
	KP_GREATER = scancode::KP_GREATER | 1: scancode << 30,
	KP_AMPERSAND = scancode::KP_AMPERSAND | 1: scancode << 30,
	KP_DBLAMPERSAND = scancode::KP_DBLAMPERSAND | 1: scancode << 30,
	KP_VERTICALBAR = scancode::KP_VERTICALBAR | 1: scancode << 30,
	KP_DBLVERTICALBAR = scancode::KP_DBLVERTICALBAR | 1: scancode << 30,
	KP_COLON = scancode::KP_COLON | 1: scancode << 30,
	KP_HASH = scancode::KP_HASH | 1: scancode << 30,
	KP_SPACE = scancode::KP_SPACE | 1: scancode << 30,
	KP_AT = scancode::KP_AT | 1: scancode << 30,
	KP_EXCLAM = scancode::KP_EXCLAM | 1: scancode << 30,
	KP_MEMSTORE = scancode::KP_MEMSTORE | 1: scancode << 30,
	KP_MEMRECALL = scancode::KP_MEMRECALL | 1: scancode << 30,
	KP_MEMCLEAR = scancode::KP_MEMCLEAR | 1: scancode << 30,
	KP_MEMADD = scancode::KP_MEMADD | 1: scancode << 30,
	KP_MEMSUBTRACT = scancode::KP_MEMSUBTRACT | 1: scancode << 30,
	KP_MEMMULTIPLY = scancode::KP_MEMMULTIPLY | 1: scancode << 30,
	KP_MEMDIVIDE = scancode::KP_MEMDIVIDE | 1: scancode << 30,
	KP_PLUSMINUS = scancode::KP_PLUSMINUS | 1: scancode << 30,
	KP_CLEAR = scancode::KP_CLEAR | 1: scancode << 30,
	KP_CLEARENTRY = scancode::KP_CLEARENTRY | 1: scancode << 30,
	KP_BINARY = scancode::KP_BINARY | 1: scancode << 30,
	KP_OCTAL = scancode::KP_OCTAL | 1: scancode << 30,
	KP_DECIMAL = scancode::KP_DECIMAL | 1: scancode << 30,
	KP_HEXADECIMAL = scancode::KP_HEXADECIMAL | 1: scancode << 30,

	LCTRL = scancode::LCTRL | 1: scancode << 30,
	LSHIFT = scancode::LSHIFT | 1: scancode << 30,
	LALT = scancode::LALT | 1: scancode << 30,
	LGUI = scancode::LGUI | 1: scancode << 30,
	RCTRL = scancode::RCTRL | 1: scancode << 30,
	RSHIFT = scancode::RSHIFT | 1: scancode << 30,
	RALT = scancode::RALT | 1: scancode << 30,
	RGUI = scancode::RGUI | 1: scancode << 30,

	MODE = scancode::MODE | 1: scancode << 30,

	AUDIONEXT = scancode::AUDIONEXT | 1: scancode << 30,
	AUDIOPREV = scancode::AUDIOPREV | 1: scancode << 30,
	AUDIOSTOP = scancode::AUDIOSTOP | 1: scancode << 30,
	AUDIOPLAY = scancode::AUDIOPLAY | 1: scancode << 30,
	AUDIOMUTE = scancode::AUDIOMUTE | 1: scancode << 30,
	MEDIASELECT = scancode::MEDIASELECT | 1: scancode << 30,
	WWW = scancode::WWW | 1: scancode << 30,
	MAIL = scancode::MAIL | 1: scancode << 30,
	CALCULATOR = scancode::CALCULATOR | 1: scancode << 30,
	COMPUTER = scancode::COMPUTER | 1: scancode << 30,
	AC_SEARCH = scancode::AC_SEARCH | 1: scancode << 30,
	AC_HOME = scancode::AC_HOME | 1: scancode << 30,
	AC_BACK = scancode::AC_BACK | 1: scancode << 30,
	AC_FORWARD = scancode::AC_FORWARD | 1: scancode << 30,
	AC_STOP = scancode::AC_STOP | 1: scancode << 30,
	AC_REFRESH = scancode::AC_REFRESH | 1: scancode << 30,
	AC_BOOKMARKS = scancode::AC_BOOKMARKS | 1: scancode << 30,

	BRIGHTNESSDOWN = scancode::BRIGHTNESSDOWN | 1: scancode << 30,
	BRIGHTNESSUP = scancode::BRIGHTNESSUP | 1: scancode << 30,
	DISPLAYSWITCH = scancode::DISPLAYSWITCH | 1: scancode << 30,
	KBDILLUMTOGGLE = scancode::KBDILLUMTOGGLE | 1: scancode << 30,
	KBDILLUMDOWN = scancode::KBDILLUMDOWN | 1: scancode << 30,
	KBDILLUMUP = scancode::KBDILLUMUP | 1: scancode << 30,
	EJECT = scancode::EJECT | 1: scancode << 30,
	SLEEP = scancode::SLEEP | 1: scancode << 30,
	APP1 = scancode::APP1 | 1: scancode << 30,
	APP2 = scancode::APP2 | 1: scancode << 30,

	AUDIOREWIND = scancode::AUDIOREWIND | 1: scancode << 30,
	AUDIOFASTFORWARD = scancode::AUDIOFASTFORWARD | 1: scancode << 30
};

export type keymod = enum u16 {
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

export type keysym = struct {
	scancode: scancode,
	sym: keycode,
	mod: keymod,
	unused: u32,
};

@symbol("SDL_GetKeyFromName") fn _get_key_from_name(name: *const char) keycode;

export fn get_key_from_name(name: str) (keycode | error) = {
	const name = strings::to_c(name);
	defer free(name);
	const sym = _get_key_from_name(name);
	if (sym == keycode::UNKNOWN) {
		return strings::fromc(geterror()): error;
	};
	return sym;
};
