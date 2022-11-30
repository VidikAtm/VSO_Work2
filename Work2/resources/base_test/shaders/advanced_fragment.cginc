// ---------
// SAMPLER 0
// ---------

#ifdef SAMPLER0_CUBE

#define TEX_COORDS0 vec3

#define DECLARE_SAMPLER0                      \
uniform samplerCube sampler0;                 \
                                              \
vec4 fetchSampler0(vec3 texCoord)             \
{                                             \
    return textureCUBE(sampler0, texCoord);   \
}

#elif defined SAMPLER0_COMBINED

#define TEX_COORDS0 vec2

#define UNIFORM_SAMPLER0                                 \
uniform sampler2D sampler0_color;                        \ 
uniform sampler2D sampler0_alpha;                        \
                                                         \
vec4 fetchSampler0(vec2 texCoord)                   \
{                                                        \
    return vec4(texture2D(sampler0_color, texCoord).rgb, \
                texture2D(sampler0_alpha, texCoord).a;   \
}

#else

#define TEX_COORDS0 vec2

#define UNIFORM_SAMPLER0                  \
uniform sampler2D sampler0;               \
                                          \
vec4 fetchSampler0(vec2 texCoord)    \
{                                         \
    return texture2D(sampler0, texCoord); \
}

#endif

// ---------
// SAMPLER 1
// ---------

#ifdef SAMPLER1_CUBE

#define TEX_COORDS1 vec3

#define DECLARE_SAMPLER1                      \
uniform samplerCube sampler1;                 \
                                              \ 
vec4 fetchSampler1(vec3 texCoord)        \
{                                             \
    return textureCUBE(sampler1, texCoord);   \
}

#elif defined SAMPLER1_COMBINED

#define TEX_COORDS1 vec2

#define UNIFORM_SAMPLER1                                 \
uniform sampler2D sampler1_color;                        \
uniform sampler2D sampler1_alpha;                        \
                                                         \
vec4 fetchSampler1(vec2 texCoord)                   \
{                                                        \
    return vec4(texture2D(sampler1_color, texCoord).rgb, \
                texture2D(sampler1_alpha, texCoord).a;   \
}

#else

#define TEX_COORDS1 vec2

#define UNIFORM_SAMPLER1                  \
uniform sampler2D sampler1;               \
                                          \
vec4 fetchSampler1(vec2 texCoord)    \
{                                         \
    return texture2D(sampler1, texCoord); \
}

#endif

// ---------
// SAMPLER 2
// ---------

#ifdef SAMPLER2_CUBE

#define TEX_COORDS2 vec3

#define DECLARE_SAMPLER2                      \
uniform samplerCube sampler2;                 \
                                              \ 
vec4 fetchSampler2(vec3 texCoord)        \
{                                             \
    return textureCUBE(sampler2, texCoord);   \
}

#elif defined SAMPLER2_COMBINED

#define TEX_COORDS2 vec2

#define UNIFORM_SAMPLER2                                 \
uniform sampler2D sampler2_color;                        \ 
uniform sampler2D sampler2_alpha;                        \
                                                         \
vec4 fetchSampler2(vec2 texCoord)                   \
{                                                        \
    return vec4(texture2D(sampler2_color, texCoord).rgb, \
                texture2D(sampler2_alpha, texCoord).a;   \
}

#else

#define TEX_COORDS2 vec2

#define UNIFORM_SAMPLER2                  \
uniform sampler2D sampler2;               \
                                          \
vec4 fetchSampler2(vec2 texCoord)    \
{                                         \
    return texture2D(sampler2, texCoord); \
}

#endif

// ---------
// SAMPLER 3
// ---------

#ifdef SAMPLER3_CUBE

#define TEX_COORDS3 vec3

#define DECLARE_SAMPLER3                      \
uniform samplerCube sampler3;                 \
                                              \ 
vec4 fetchSampler3(vec3 texCoord)        \
{                                             \
    return textureCUBE(sampler3, texCoord);   \
}

#elif defined SAMPLER3_COMBINED

#define TEX_COORDS3 vec2

#define UNIFORM_SAMPLER3                                 \
uniform sampler2D sampler3_color;                        \ 
uniform sampler2D sampler3_alpha;                        \
                                                         \
vec4 fetchSampler3(vec2 texCoord)                   \
{                                                        \
    return vec4(texture2D(sampler3_color, texCoord).rgb, \
                texture2D(sampler3_alpha, texCoord).a;   \
}

#else

#define TEX_COORDS3 vec2

#define UNIFORM_SAMPLER3                  \
uniform sampler2D sampler3;               \
                                          \
vec4 fetchSampler3(vec2 texCoord)    \
{                                         \
    return texture2D(sampler3, texCoord); \
}

#endif