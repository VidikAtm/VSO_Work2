precision highp float;

#include "ShadowHelper.glsl"

uniform sampler2D sampler;
uniform sampler2D sampler1; // flow map
uniform sampler2D sampler2; // shadow map
#ifndef DEPTH_TO_16B
	uniform sampler2D sampler3; // shadow map Sqw
#endif
/// @color @default(0.5, 0.5, 0.5, 1.0)
uniform mediump vec4 u_hairColor;
/// @default(0.5)
uniform float u_glossIntencity;
/// @default(4.0)
uniform float u_specularPower;
/// @excludeFromShaderConstants
uniform float u_maxLightDistance;
/// @excludeFromShaderConstants
uniform float u_tanHalfFOV;
uniform float u_maxAttenuation;
varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord1;
varying vec3 v_normal;
varying vec3 v_tangent;
varying vec3 v_binormal;
varying vec3 v_viewDir;
varying vec3 v_lightDir;
varying vec3 v_localLightDir;
varying vec3 v_lightColor;

void main()
{
	gl_FragColor = texture2D(sampler, v_texcoord) * u_hairColor;
	
	
	vec4 flowColor = texture2D(sampler1, v_texcoord1);
	
	vec3 fm = flowColor.xyz * 2.0 - vec3(1.0, 1.0, 1.0);
	
	float lightDist = length(v_lightDir);
	vec3 lightDir = v_lightDir / lightDist;
	vec3 viewDir = normalize(v_viewDir);
	vec3 normal = normalize(v_normal);
	vec3 tangent = normalize(v_tangent);
	vec3 binormal = normalize(v_binormal);
	vec3 flow = normalize(tangent * fm.x + binormal * fm.y + normal * fm.z);
	//flow = normalize(cross(flow, normal));
	
	vec3 h = normalize(viewDir + lightDir);
	float s = max(0.0, dot(h, flow));
	s = sqrt(1.0 - s * s);
	
	float ndotl = max(0.0, dot(lightDir, normal));
	
	vec3 specular = v_lightColor * ndotl * pow(s, u_specularPower) * u_glossIntencity;
	
	vec3 localLightDir = v_localLightDir;
	localLightDir.z = max(localLightDir.z, 0.0);
	vec2 uv = -localLightDir.xy / (localLightDir.z * u_tanHalfFOV) * 0.5 + vec2(0.5, 0.5);
	
	highp float zLinear = (lightDist - SM_ZBIAS) / u_maxLightDistance;
	#ifdef VSM_ENABLED
		#ifdef DEPTH_TO_16B
			highp vec2 sDepth = DecodeVec2FromVec4(texture2D(sampler2, uv));
		#else
			highp vec2 sDepth = vec2(UnpackDepth32(texture2D(sampler2, uv)), UnpackDepth32(texture2D(sampler3, uv)));
		#endif
		float s0 = ChebishevFilter(sDepth, zLinear);
	#else
		float s0 = FilterPCF(sampler2, uv, zLinear);
	#endif
	
	float attenuation = min(s0, ndotl);
	
	vec3 colorLit = gl_FragColor.xyz * v_lightColor;
	vec3 colorUnlit = gl_FragColor.xyz * u_maxAttenuation;
	
	gl_FragColor.xyz = mix(colorUnlit, colorLit, attenuation);

	
	//gl_FragColor.xyz += specular;
}
