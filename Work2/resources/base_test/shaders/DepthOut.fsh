#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	gl_FragColor = texture2D(sampler1, v_texcoord);
}