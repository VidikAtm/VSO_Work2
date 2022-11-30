#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_color;

varying vec2 v_texcoord;
varying vec4 v_color;

void main()
{
	gl_FragColor = texture2D(sampler, v_texcoord) * u_color * v_color;
}