#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

varying vec4 v_color;

/// @color
uniform vec4 u_bgColor;
/// @color
uniform vec4 u_borderColor;

uniform float u_borderOffs;
uniform float u_borderScale;

varying vec2 v_texcoord;

void main()
{
	vec4 t = texture2D(sampler, v_texcoord);
	gl_FragColor = v_color * mix(u_bgColor, texture2D(sampler1, v_texcoord), t.r).ggga + u_borderColor * u_borderScale * max(0.0, 0.5 - abs(0.5 - t.r) - u_borderOffs);
}