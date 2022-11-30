#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform samplerCube sampler1;

uniform mat4 u_coreModel;
uniform vec3 u_autoWorldCameraPos;

uniform float u_normalScale;

varying vec4 v_worldpos;
varying vec2 v_texcoord;

void main()
{
	// Fetch and decode normal
	mediump vec3 normal = texture2D(sampler, v_texcoord).xyz;
	normal = normal * 2.0 - 1.0;
	normal.xy *= u_normalScale;
	
	// Transform to world space
	normal = mat3(u_coreModel[0].xyz, u_coreModel[1].xyz, u_coreModel[2].xyz) * normal.xzy;
	normal = normalize(normal);
	
	// Reflect vector by normal
	vec3 refl = reflect(v_worldpos.xyz - u_autoWorldCameraPos, normal);
	
	gl_FragColor = textureCube(sampler1, refl);
}
