// Convert SDL headers to Hare bindings. This can be a little finnicky, and for
// some headers requires tweaking this file or the header file.
use bufio;
use fmt;
use io;
use memio;
use os;
use regex;
use strings;

// todo: structs
let enums: []str = [];
let fns: []str = [];

const hare_keywords = [
	"size_",
	"type_",
	"str_",
	"len_",
	"offset_",
	"fn_",
	"align_",
];

const hare_type_conv = [
	("FILE", "opaque"),
	("short", "i16"),
	("long", "int"),
	("int", "int"),
	("Uint8", "u8"),
	("Uint16", "u16"),
	("Uint32", "u32"),
	("Uint64", "u64"),
	("Sint8", "i8"),
	("Sint16", "i16"),
	("Sint32", "i32"),
	("Sint64", "i64"),
	("SDL_bool", "bool"),
	("char", "c::char"),
	("float", "f32"),
	("double", "f64"),
	("size_t", "size"),
	("wchar_t", "i32"),
];

const sdl_prefixes = ["SDL_", "pfnSDL", "IMG_", "MIX_", "Mix_", "TTF_"];

// adds a _ after keywords.
fn safe_name(n: str) str = {
	for (let i = 0z; i < len(hare_keywords); i += 1) {
		if (n == strings::rtrim(hare_keywords[i], '_'))
			return hare_keywords[i];
	};
	return n;
};

// "const float *" -> "*f32", etc.
fn hare_type(t: str) str = {
	t = strings::trimprefix(t, "const ");

	let pieces: []str = [];
	defer free(pieces);
	let iter = strings::iter(t);
	for (true) match (strings::next(&iter)) {
	case void =>
		break;
	case let r: rune =>
		if (r == '*') append(pieces, "*");
	};
	t = strings::trim(t, '*', ' ');

	let found = false;
	if (t == "void") {
		found = true;
		if (len(pieces) == 0) {
			append(pieces, "void");
		} else {
			append(pieces, "opaque");
		};
	};
	if (!found) for (let i = 0z; i < len(hare_type_conv); i += 1) {
		if (t == hare_type_conv[i].0) {
			found = true;
			append(pieces, hare_type_conv[i].1);
			break;
		};
	};
	if (!found) for (let i = 0z; i < len(sdl_prefixes); i += 1) {
		if (strings::hasprefix(t, sdl_prefixes[i])) {
			found = true;
			append(pieces, t);
			break;
		};
	};
	assert(found, t);
	return strings::join("", pieces...);
};

fn append_fn(ret: str, name: str, ps: [](str, str)) void = {
	ret = hare_type(ret);
	defer free(ret);
	let mio = memio::dynamic();
	defer io::close(&mio)!;
	fmt::fprintf(&mio, `export @symbol("{}") fn {}(`, name, name)!;
	for (let i = 0z; i < len(ps); i += 1) {
		if (i > 0) fmt::fprint(&mio, ", ")!;
		const ptype = hare_type(ps[i].0);
		defer free(ptype);
		fmt::fprintf(&mio, "{}: {}", safe_name(ps[i].1), ptype)!;
	};
	fmt::fprintf(&mio, ") {};", ret)!;
	append(fns, strings::dup(memio::string(&mio)!));
};

// "const char *n, int i" -> [("const char *", "n"), ("int", "i")]
fn split_ps(ps: str) [](str, str) = {
	let ret: [](str, str) = [];
	if (ps == "void")
		return ret;
	let tok = strings::tokenize(ps, ",");
	for (true) match (strings::next_token(&tok)) {
	case void =>
		break;
	case let s: str =>
		s = strings::trim(s);
		// Get everything after rightmost "*" or " ".
		// Whichever has the shorter name wins.
		let (t, n) = strings::rcut(s, "*");
		let (t2, n2) = strings::rcut(s, " ");
		if (len(n2) < len(n) || len(n) == 0) {
			t = t2;
			n = n2;
		};
		append(ret, (strings::trim(t), strings::trim(n)));
	};
	return ret;
};

fn handle_fn(line: str) void = {
	// Capture groups are return type, fn name, and all parameters.
	const re_fn = regex::compile(`^extern +DECLSPEC +([a-zA-Z0-9_\* ]+)SDLCALL +([a-zA-Z0-9_]+) *\(([a-zA-Z0-9 \*_, ]*)\);`)!;
	defer regex::finish(&re_fn);

	const result_fn = regex::find(&re_fn, line);
	defer regex::result_free(result_fn);

	assert(len(result_fn) == 4); // Otherwise we are missing something.

	let ps = split_ps(result_fn[3].content);
	defer free(ps);

	append_fn(strings::trim(result_fn[1].content),
		strings::trim(result_fn[2].content), ps);
};

fn handle_enum(e: str) void = {
	// NAME = VALUE,
	const re_e1 = regex::compile(`^ +([a-zA-Z0-9_]+) ?= ?([a-zA-Z0-9]+),?`)!;
	defer regex::finish(&re_e1);
	// NAME,
	const re_e2 = regex::compile(`^ +([a-zA-Z0-9_]+),?`)!;
	defer regex::finish(&re_e2);
	// } SDL_EnumName;
	const re_e3 = regex::compile(`^} ([a-zA-Z0-9_]+);`)!;
	defer regex::finish(&re_e3);

	let name = "";
	defer free(name);
	let lines: []str = [];
	defer strings::freeall(lines);

	let incomment = false;
	let tok = strings::tokenize(e, "\n");
	for (true) match (strings::next_token(&tok)) {
	case void =>
		break;
	case let line: str =>
		const result_e1 = regex::find(&re_e1, line);
		defer regex::result_free(result_e1);
		const result_e2 = regex::find(&re_e2, line);
		defer regex::result_free(result_e2);
		const result_e3 = regex::find(&re_e3, line);
		defer regex::result_free(result_e3);

		if (!incomment) {
			if (len(result_e1) > 0) {
				append(lines, fmt::asprintf("\t{} = {},",
					result_e1[1].content,
					result_e1[2].content));
			} else if (len(result_e2) > 0) {
				append(lines, fmt::asprintf("\t{},",
					result_e2[1].content));
			} else if (len(result_e3) > 0) {
				name = strings::dup(result_e3[1].content);
			};
		};

		if (strings::contains(line, "/*"))
			incomment = true;
		if (strings::contains(line, "*/"))
			incomment = false;
	};

	assert(name != "");
	assert(len(lines) != 0);

	let mio = memio::dynamic();
	defer io::close(&mio)!;
	fmt::fprintfln(&mio, "export type {} = enum {{", name)!;
	for (let i = 0z; i < len(lines); i += 1)
		fmt::fprintln(&mio, lines[i])!;
	fmt::fprintln(&mio, "};")!;

	append(enums, strings::dup(memio::string(&mio)!));
};

fn struct_member(s: str) str = {
	let (t, n) = strings::rcut(s, "*");
	let (t2, n2) = strings::rcut(s, " ");
	if (len(n2) < len(n) || len(n) == 0) {
		t = t2;
		n = n2;
	};
	fmt::println(t, n)!;
	return strings::dup(t);
};

export fn main() void = {
	assert(len(os::args) == 2, "provide path to SDL_<name>.h file");
	const f = os::open(os::args[1])!;
	defer io::close(f)!;

	for (true) match (bufio::read_line(f)!) {
	case io::EOF =>
		break;
	case let l: []u8 =>
		let line = strings::dup(strings::fromutf8(l)!);
		defer free(line);
		if (strings::hasprefix(line, "extern DECLSPEC")) {
			for (!strings::contains(line, ';')) {
				let nl = bufio::read_line(f)! as []u8;
				let ns = strings::concat(line, " ",
					strings::fromutf8(nl)!);
				free(line);
				line = ns;
			};
			handle_fn(line);
		} else if (strings::hasprefix(line, "typedef enum")) {
			for (!strings::contains(line, ';')) {
				let nl = bufio::read_line(f)! as []u8;
				let ns = strings::concat(line, "\n",
					strings::fromutf8(nl)!);
				free(line);
				line = ns;
			};
			handle_enum(line);
		} else if (strings::hasprefix(line, "typedef struct")) {
			void; // TODO
		};
	};

	fmt::println("// TODO: Add #defines.")!;
	fmt::println("// TODO: Add structs.")!;
	fmt::println()!;

	for (let i = 0z; i < len(enums); i += 1) {
		fmt::println("// TODO: Check type.")!;
		fmt::println(enums[i])!;
	};

	fmt::println("// TODO: Look for nullable pointers.")!;
	for (let i = 0z; i < len(fns); i += 1) {
		fmt::println(fns[i])!;
	};
	strings::freeall(fns);
	strings::freeall(enums);
};
