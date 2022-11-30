#ifdef GL_ES
precision highp float;
#endif

#include "ShadowHelper.glsl"

uniform sampler2D sampler;
uniform sampler2D sampler1; // shadow map
#ifndef DEPTH_TO_16B
	uniform sampler2D sampler2; // shadow map Sqw
#endif

#define SHADOWS_ENABLED 1

/// @excludeFromShaderConstants
uniform float u_maxLightDistance;
/// @excludeFromShaderConstants
uniform float u_tanHalfFOV;
/// @excludeFromShaderConstants
uniform float u_maxAttenuation;

varying highp vec2 v_texcoord;
varying vec3 v_normal;
varying vec3 v_lightDir;
varying vec3 v_localLightDir;
varying vec3 v_lightColor;

void main()
{
	gl_FragColor = texture2D(sampler, v_texcoord);
	
	float lightDist = length(v_lightDir);
	vec3 lightDir = v_lightDir / lightDist;
	
	vec3 normal = normalize(v_normal);
	float ndotl = dot(lightDir, normal);

	#ifdef SHADOWS_ENABLED
		vec3 localLightDir = v_localLightDir;
		localLightDir.z = max(localLightDir.z, 0.0);
		vec2 uv = -localLightDir.xy / (localLightDir.z * u_tanHalfFOV) * 0.5 + vec2(0.5, 0.5);
		
		highp float zLinear = (lightDist - SM_ZBIAS) / u_maxLightDistance;
		#ifdef ESM_ENABLED
			highp float sDepth = UnpackDepth32(texture2D(sampler1, uv));
			float s0 = ExponentFilter(sDepth, zLinear);
		#else
			#ifdef VSM_ENABLED
				#ifdef DEPTH_TO_16B
					highp vec2 sDepth = DecodeVec2FromVec4(texture2D(sampler1, uv));
				#else
					highp vec2 sDepth = vec2(UnpackDepth32(texture2D(sampler1, uv)), UnpackDepth32(texture2D(sampler2, uv)));
				#endif
				float s0 = ChebishevFilter(sDepth, zLinear);
			#else
				float s0 = FilterPCF(sampler1, uv, zLinear);
			#endif
		#endif
	
		if (uv.x < 0.0 || uv.x > 1.0 || uv.y < 0.0 || uv.y > 1.0) {
			s0 = 1.0;
		}
	#else
		const float s0 = 1.0;
	#endif

	float attenuation = max(s0 * ndotl, 0.0) + u_maxAttenuation;
	
	vec3 colorLit = gl_FragColor.xyz * v_lightColor;
	vec3 colorUnlit = gl_FragColor.xyz * u_maxAttenuation;
	
	gl_FragColor.xyz = mix(colorUnlit, colorLit, attenuation);
	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(s0);
	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(sDepth.x);
	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(zLinear);
	//gl_FragColor = vec4(1.0);
}
