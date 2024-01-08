use sdl::v2c::*;

// Get the number of logical CPU cores available.
export fn get_cpucount() int = SDL_GetCPUCount();

// Determine the L1 cache line size of the CPU in bytes.
//
// This is useful for determining multi-threaded structure padding or SIMD
// prefetch sizes.
export fn get_cpucache_line_size() int = SDL_GetCPUCacheLineSize();

// Determine whether the CPU has the RDTSC instruction.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_rdtsc() bool = SDL_HasRDTSC();

// Determine whether the CPU has AltiVec features.
//
// This always returns false on CPUs that aren't using PowerPC instruction
// sets.
export fn has_alti_vec() bool = SDL_HasAltiVec();

// Determine whether the CPU has MMX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_mmx() bool = SDL_HasMMX();

// Determine whether the CPU has 3DNow! features.
//
// This always returns false on CPUs that aren't using AMD instruction sets.
export fn has3_dnow() bool = SDL_Has3DNow();

// Determine whether the CPU has SSE features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_sse() bool = SDL_HasSSE();

// Determine whether the CPU has SSE2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_sse2() bool = SDL_HasSSE2();

// Determine whether the CPU has SSE3 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_sse3() bool = SDL_HasSSE3();

// Determine whether the CPU has SSE4.1 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_sse41() bool = SDL_HasSSE41();

// Determine whether the CPU has SSE4.2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_sse42() bool = SDL_HasSSE42();

// Determine whether the CPU has AVX features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_avx() bool = SDL_HasAVX();

// Determine whether the CPU has AVX2 features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_avx2() bool = SDL_HasAVX2();

// Determine whether the CPU has AVX-512F (foundation) features.
//
// This always returns false on CPUs that aren't using Intel instruction sets.
export fn has_avx512_f() bool = SDL_HasAVX512F();

// Determine whether the CPU has ARM SIMD (ARMv6) features.
//
// This is different from ARM NEON, which is a different instruction set.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
export fn has_armsimd() bool = SDL_HasARMSIMD();

// Determine whether the CPU has NEON (ARM SIMD) features.
//
// This always returns false on CPUs that aren't using ARM instruction sets.
export fn has_neon() bool = SDL_HasNEON();

// Determine whether the CPU has LSX (LOONGARCH SIMD) features.
//
// This always returns false on CPUs that aren't using LOONGARCH instruction
// sets.
export fn has_lsx() bool = SDL_HasLSX();

// Determine whether the CPU has LASX (LOONGARCH SIMD) features.
//
// This always returns false on CPUs that aren't using LOONGARCH instruction
// sets.
export fn has_lasx() bool = SDL_HasLASX();

// Get the amount of RAM configured in the system in MiB.
export fn get_system_ram() int = SDL_GetSystemRAM();

// Report the alignment this system needs for SIMD allocations.
//
// This will return the minimum number of bytes to which a pointer must be
// aligned to be compatible with SIMD instructions on the current machine. For
// example, if the machine supports SSE only, it will return 16, but if it
// supports AVX-512F, it'll return 64 (etc). This only reports values for
// instruction sets SDL knows about, so if your SDL build doesn't have
// [[has_avx512_f]], then it might return 16 for the SSE support it sees and
// not 64 for the AVX-512 instructions that exist but SDL doesn't know about.
// Plan accordingly.
export fn simd_get_alignment() size = SDL_SIMDGetAlignment();

// Allocate memory in a SIMD-friendly way.
//
// This will allocate a block of memory that is suitable for use with SIMD
// instructions. Specifically, it will be properly aligned and padded for the
// system's supported vector instructions.
//
// The memory returned will be padded such that it is safe to read or write an
// incomplete vector at the end of the memory block. This can be useful so you
// don't have to drop back to a scalar fallback at the end of your SIMD
// processing loop to deal with the final elements without overflowing the
// allocated buffer.
//
// You must free this memory with [[simd_free]], not free().
//
// Note that SDL will only deal with SIMD instruction sets it is aware of; for
// example, SDL 2.0.8 knows that SSE wants 16-byte vectors ([[has_sse]]), and
// AVX2 wants 32 bytes ([[has_avx2]]), but doesn't know that AVX-512 wants
// 64. To be clear: if you can't decide to use an instruction set with an
// has_*() function, don't use that instruction set with memory allocated
// through here.
//
// alloc_simd(0) will return a non-null pointer, assuming the system isn't
// out of memory, but you are not allowed to dereference it (because you only
// own zero bytes of that buffer).
export fn simd_alloc(len_: size) (*opaque | error) =
	wrapptr(SDL_SIMDAlloc(len_));

// Reallocate memory obtained from [[simd_alloc]].
// 
// It is not valid to use this function on a pointer from anything but
// [[simd_alloc]]. It can't be used on pointers from malloc, realloc, etc.
export fn simd_realloc(mem: nullable *opaque, len_: size) (*opaque | error) =
	wrapptr(SDL_SIMDRealloc(mem, len_));

// Deallocate memory obtained from [[simd_alloc]].
// 
// It is not valid to use this function on a pointer from anything but
// [[simd_alloc]] or [[simd_realloc]]. It can't be used on pointers from alloc,
// realloc, etc.
export fn simd_free(ptr: nullable *opaque) void = SDL_SIMDFree(ptr);
