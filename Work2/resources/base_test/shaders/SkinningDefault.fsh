#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_color;
varying vec2 v_texcoord;

void main()
{
	gl_FragColor = texture2D(sampler, v_texcoord) * u_color * vec4(1,3,1,1);
}