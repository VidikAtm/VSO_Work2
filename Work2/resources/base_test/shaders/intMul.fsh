#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform int mulCoeff;
varying vec4 v_color;
varying vec2 v_texcoord;


void main()
{
	gl_FragColor = v_color * float(mulCoeff) * texture2D(sampler, v_texcoord);
}