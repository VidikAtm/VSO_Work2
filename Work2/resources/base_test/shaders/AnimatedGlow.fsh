#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

/// @color @default(1,1,1,1)
uniform vec4 u_mainColor;
/// @color @default(1,1,1,1)
uniform vec4 u_glowColor;
/// @color @default(1,1,1,1)
uniform vec4 u_crackColor;
/// @default(0.05)
uniform mediump float u_distortion;
/// @default(0.0)
uniform mediump float u_alphaPos;
/// @default(10.0)
uniform mediump float u_alphaTan;
/// @default(10.0)
uniform mediump float u_alphaTanGlow;
/// @default(0,0)
uniform mediump vec2 u_offset;
/// @default(0,0)
uniform mediump vec2 u_offset1;

varying vec4 v_color;
varying highp vec2 v_texcoord;

void main()
{
	vec2 offs = 2.0 * texture2D(sampler1, v_texcoord + u_offset).rg - 1.0;
	vec2 offs1 = 2.0 * texture2D(sampler1, v_texcoord + u_offset1).rg - 1.0;
	vec4 tex = texture2D(sampler, v_texcoord);
	vec4 tex1 = texture2D(sampler, v_texcoord + u_distortion * (offs + offs1));
	float scale = clamp((tex.b - u_alphaPos) * u_alphaTan + 0.5, 0.0, 1.0);
	float crack = max(0.0, 1.0 - abs((tex.b - u_alphaPos) * u_alphaTanGlow));
	gl_FragColor = v_color * (u_mainColor * tex.g + u_glowColor * tex1.r) * scale + u_crackColor * crack;
}