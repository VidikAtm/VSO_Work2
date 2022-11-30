// ---------
// SAMPLER 0
// ---------

#ifdef SAMPLER0_CUBE

#define TEX_COORDS0 vec3

#elif defined SAMPLER0_COMBINED

#define TEX_COORDS0 vec2

#else

#define TEX_COORDS0 vec2

#endif

// ---------
// SAMPLER 1
// ---------

#ifdef SAMPLER1_CUBE

#define TEX_COORDS1 vec3

#elif defined SAMPLER1_COMBINED

#define TEX_COORDS1 vec2

#else

#define TEX_COORDS1 vec2

#endif

// ---------
// SAMPLER 2
// ---------

#ifdef SAMPLER2_CUBE

#define TEX_COORDS2 vec3

#elif defined SAMPLER2_COMBINED

#define TEX_COORDS2 vec2

#else

#define TEX_COORDS2 vec2

#endif

// ---------
// SAMPLER 3
// ---------

#ifdef SAMPLER3_CUBE

#define TEX_COORDS3 vec3

#elif defined SAMPLER3_COMBINED

#define TEX_COORDS3 vec2

#else

#define TEX_COORDS3 vec2

#endif