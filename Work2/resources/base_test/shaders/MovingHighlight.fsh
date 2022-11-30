#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	vec4 mainTex = texture2D(sampler, v_texcoord);
	vec4 highlight = texture2D(sampler1, v_texcoord1);
	highlight *= mainTex.a;
	gl_FragColor = v_color * highlight;
}