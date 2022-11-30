#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;

/// @default(0.5)
uniform float u_alphaThreshold;

varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	mediump vec4 c = v_color * texture2D(sampler, v_texcoord);
	if (c.a < u_alphaThreshold)
		discard;
	gl_FragColor = c;
}