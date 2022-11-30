#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
varying vec4 v_color;
varying vec3 v_texcoord;
varying vec2 v_texcoord1;

uniform float u_alphaHighlight;
uniform float u_glowHighlight;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord.xy);
	vec4 addition = texture2D(sampler1, v_texcoord1.xy);
	
	float intecity = v_color.a * (1.0 + u_alphaHighlight * addition.r) * tex.g;
	intecity += v_texcoord.z * (1.0 + u_glowHighlight * addition.r) * tex.r;
	gl_FragColor.rgb = v_color.rgb * intecity;
	gl_FragColor.a = 1.0;
}