#ifdef GL_ES
precision highp float;
#endif

#include "ShadowHelper.glsl"

/// @excludeFromShaderConstants
uniform float u_maxLightDistance;
varying vec3 v_lightDir;

void main()
{
	highp float depth = clamp(length(v_lightDir) / u_maxLightDistance, 0.0, 1.0);
	#ifdef ESM_ENABLED
		gl_FragColor = PackDepth32(exp(ESM_FACTOR * depth) * ESM_PACK_F - 1.0);
	#else
		#ifdef VSM_ENABLED
			#ifdef DEPTH_TO_16B
				gl_FragColor = EncodeVec2ToVec4(vec2(depth, depth * depth));
			#else
				gl_FragColor = PackDepth32(depth);
			#endif
		#else
			gl_FragColor = PackDepth32(depth);
		#endif
	#endif
}
