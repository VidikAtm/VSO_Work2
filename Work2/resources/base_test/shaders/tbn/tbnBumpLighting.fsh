#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform samplerCube sampler2;

/// @default(0.01)
uniform float u_bumpiness;
/// @default(0.1)
uniform float u_ambientStrength;
/// @default(0.1)
uniform float u_diffuseStrength;
/// @default(0.1)
uniform float u_specularStrength;
/// @default(0.1)
uniform float u_specularPower;
/// @default(0.333)
uniform float u_reflectionStrength;

uniform vec3 u_lightPos;
/// @color
uniform vec4 u_ambCol;
/// @color
uniform vec4 u_lightCol;

varying vec2 v_texcoord;
varying vec3 v_worldpos;
varying vec3 v_tangent;
varying vec3 v_normal;
varying vec3 v_viewDir;

void main()
{
	vec4 albedo = texture2D(sampler, v_texcoord);
	vec4 localNormal = texture2D(sampler1, v_texcoord);
	
	localNormal.xyz = localNormal.xyz * 2.0 - 1.0;
	localNormal.xy *= u_bumpiness;
	localNormal.xyz = normalize(localNormal.xyz);
	
	mat3 surfBTN;
	surfBTN[2] = normalize(v_normal);
	surfBTN[1] = normalize(v_tangent);
	surfBTN[0] = cross(surfBTN[1], surfBTN[2]);
	
	vec3 worldNormal = surfBTN * localNormal.xyz;
	
	vec3 lightDir = normalize(u_lightPos - v_worldpos);
	float diff = max(dot(worldNormal, lightDir), 0.0);
	
	vec3 refl = reflect(normalize(v_viewDir), worldNormal);
	float spec = pow(max(dot(refl, lightDir), 0.0), u_specularPower);
	
	vec4 cube = textureCube(sampler2, refl);
	albedo = mix(albedo, cube, u_reflectionStrength);
	
	gl_FragColor = albedo * (u_ambientStrength * u_ambCol + (diff * u_diffuseStrength + spec * u_specularStrength) * u_lightCol);
	gl_FragColor.a = 1.0;
}
