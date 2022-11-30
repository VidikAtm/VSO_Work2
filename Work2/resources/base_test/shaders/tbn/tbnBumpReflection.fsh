#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform samplerCube sampler1;

/// @default(0.01)
uniform float u_bumpiness;

varying vec2 v_texcoord;
varying vec3 v_tangent;
varying vec3 v_normal;
varying vec3 v_viewDir;

void main()
{
	vec4 localNormal = texture2D(sampler, v_texcoord);
	localNormal.xyz = localNormal.xyz * 2.0 - 1.0;
	localNormal.xy *= u_bumpiness;
	localNormal.xyz = normalize(localNormal.xyz);
	
	mat3 surfBTN;
	surfBTN[2] = normalize(v_normal);
	surfBTN[1] = normalize(v_tangent);
	surfBTN[0] = cross(surfBTN[1], surfBTN[2]);
	
	vec3 worldNormal = surfBTN * localNormal.xyz;
	vec3 refl = reflect(normalize(v_viewDir), worldNormal);
	vec4 cube = textureCube(sampler1, refl);
	
	gl_FragColor = cube;
	gl_FragColor.a = 1.0;
}
