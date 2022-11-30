#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform samplerCube sampler1;

/// @default(1.0)
uniform float u_mixVal;

varying vec2 v_texcoord;
varying vec3 v_normal;

void main()
{
	vec3 surfN = normalize(v_normal);
	vec3 tex  = texture2D(sampler, v_texcoord).rgb;
	vec3 cube = textureCube(sampler1, surfN).rgb;
	
	gl_FragColor.rgb = mix(tex, cube, u_mixVal);
	gl_FragColor.a = 1.0;
}
