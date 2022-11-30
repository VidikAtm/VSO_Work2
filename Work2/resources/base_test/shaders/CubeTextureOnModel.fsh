#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform samplerCube sampler1;

uniform float u_mix;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec3 v_normal;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord);	
	vec4 refl = textureCube(sampler1, v_normal);
	
	gl_FragColor.rgb = mix(tex.rgb, refl.rgb, u_mix);
	gl_FragColor.a = 1.0;
}