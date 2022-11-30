#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

/// @color @default(1,1,1,1)
uniform vec4 u_lum;

varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	vec4 mainTex = texture2D(sampler, v_texcoord);
	vec4 addTex = texture2D(sampler1, v_texcoord1);
	mainTex.rgb += u_lum.rgb * addTex.rgb * addTex.a;
	gl_FragColor = v_color * mainTex;
}