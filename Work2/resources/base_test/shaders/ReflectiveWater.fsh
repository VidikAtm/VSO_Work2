#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;  // Normal map
uniform sampler2D sampler1; // Reflection
uniform samplerCube sampler2; // Reflection

uniform mat4 u_coreModel;
uniform mat4 u_coreViewProj;
uniform vec4 u_coreCameraPos;
uniform float u_normalScale;
uniform float u_distortion;

/// @color
uniform vec4 u_waterColor;
uniform float u_fresnelPower;

varying vec2 v_texcoord;
varying vec4 v_worldPos;
varying vec4 v_screenPos;

void main()
{
	// Fetch, decode and correct normal
	mediump vec3 normal = texture2D(sampler, v_texcoord).xyz;
	normal = normal * 2.0 - 1.0;
	normal.xy *= u_normalScale;
	
	// Transform to world space (swizzling is because of coordinate system)
	normal = mat3(u_coreModel[0].xyz, u_coreModel[1].xyz, u_coreModel[2].xyz) * normal.xzy;
	normal = normalize(normal);
	
	// Reflect vector by normal
	vec3 dir = normalize(v_worldPos.xyz - u_coreCameraPos.xyz);
	vec3 refl = reflect(dir, normal);
	float k = dot(refl, normal);
	
	// Sample sky
	vec4 sky = textureCube(sampler2, refl);
	
	refl.y = -refl.y;
	vec4 posShifted = v_worldPos;
	posShifted.xyz -= u_distortion * refl / refl.y;
	
	// Project back
	vec4 posProj = u_coreViewProj * posShifted;
	vec2 texCoords = 0.5 * posProj.xy / posProj.w + 0.5;
	
	// Fresnel
	float reflectiveness = clamp(pow(1.0 + k, -u_fresnelPower), 0.0, 1.0);
	
	//
	vec4 reflTex = texture2D(sampler1, texCoords);
	
	// Sample from reflection texture
	gl_FragColor.rgb = mix(u_waterColor.rgb, mix(sky.rgb, reflTex.rgb, reflTex.a), reflectiveness);
	gl_FragColor.a = 1.0;
}