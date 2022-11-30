#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;

uniform mediump vec4 u_uvscale_t0;
uniform highp vec4 su_autoUVPixelSize0;

varying highp vec4 v_position; 
varying highp vec2 v_texcoord;

//Only FXAA
#define FXAA_SPAN_MAX 8.0
#define FXAA_REDUCE_MUL   (1.0 / FXAA_SPAN_MAX)
#define FXAA_REDUCE_MIN   (1.0 / 128.0)
#define FXAA_SUBPIX_SHIFT (1.0 / 4.0)

void main()
{
    mediump vec2 pixelSize = su_autoUVPixelSize0.xy;
    vec4 uv = vec4( v_texcoord, v_texcoord - (pixelSize.xy * (0.5 + FXAA_SUBPIX_SHIFT)));

    mediump vec2 offsetW = vec2(pixelSize.x, 0.0);
    mediump vec2 offsetH = vec2(0.0, pixelSize.y);

    vec3 rgbNW = texture2D(sampler, uv.zw).xyz;
    vec3 rgbNE = texture2D(sampler, uv.zw + vec2(pixelSize.x, 0.0)).xyz;
    vec3 rgbSW = texture2D(sampler, uv.zw + vec2(0.0 ,pixelSize.y)).xyz;
    vec3 rgbSE = texture2D(sampler, uv.zw + pixelSize.xy).xyz;
    vec3 rgbM  = texture2D(sampler, uv.xy).xyz;

    vec3 luma = vec3(0.299, 0.587, 0.114);
    float lumaNW = dot(rgbNW, luma);
    float lumaNE = dot(rgbNE, luma);
    float lumaSW = dot(rgbSW, luma);
    float lumaSE = dot(rgbSE, luma);
    float lumaM  = dot(rgbM,  luma);

    float lumaMin = min(lumaM, min(min(lumaNW, lumaNE), min(lumaSW, lumaSE)));
    float lumaMax = max(lumaM, max(max(lumaNW, lumaNE), max(lumaSW, lumaSE)));

    vec2 dir;
    dir.x = -((lumaNW + lumaNE) - (lumaSW + lumaSE));
    dir.y =  ((lumaNW + lumaSW) - (lumaNE + lumaSE));

    float dirReduce = max(
        (lumaNW + lumaNE + lumaSW + lumaSE) * (0.25 * FXAA_REDUCE_MUL),
        FXAA_REDUCE_MIN);
    float rcpDirMin = 1.0/(min(abs(dir.x), abs(dir.y)) + dirReduce);
    
    dir = min(vec2( FXAA_SPAN_MAX,  FXAA_SPAN_MAX),
        max(vec2(-FXAA_SPAN_MAX, -FXAA_SPAN_MAX),
        dir * rcpDirMin)) * pixelSize.xy;

    vec3 rgbA = (1.0/2.0) * (
        texture2D(sampler, uv.xy + dir * (1.0/3.0 - 0.5)).xyz +
        texture2D(sampler, uv.xy + dir * (2.0/3.0 - 0.5)).xyz);
    vec3 rgbB = rgbA * (1.0/2.0) + (1.0/4.0) * (
        texture2D(sampler, uv.xy + dir * (0.0/3.0 - 0.5)).xyz +
        texture2D(sampler, uv.xy + dir * (3.0/3.0 - 0.5)).xyz);
    
    float lumaB = dot(rgbB, luma);

    if((lumaB < lumaMin) || (lumaB > lumaMax)) {
        gl_FragColor = vec4(rgbA, 1.0);
    }
    else {
        gl_FragColor = vec4(rgbB, 1.0);
    }
}
