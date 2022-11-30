#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;
uniform sampler2D sampler3;

uniform vec4 u_amps;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;
varying vec2 v_texcoord3;

void main()
{
	// only for testing purposes! It's better to place such texcoord logic into a vertex shader.
	vec4 tex0 = texture2D(sampler, v_texcoord0);
	vec4 tex1 = texture2D(sampler1, v_texcoord1);
	vec4 tex2 = texture2D(sampler2, v_texcoord2);
	vec4 tex3 = texture2D(sampler3, v_texcoord3);
	
	gl_FragColor = tex0 * u_amps.x + tex1 * u_amps.y + tex2 * u_amps.z + tex3 * u_amps.w;
}
