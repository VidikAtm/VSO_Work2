#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler; // shadow map

#include "ShadowHelper.glsl"

varying highp vec2 v_texcoord;

void main()
{
	#ifdef DEPTH_TO_16B
		highp vec2 depth = DecodeVec2FromVec4(texture2D(sampler, v_texcoord));
		gl_FragColor = EncodeVec2ToVec4(vec2(depth.x, depth.y * depth.y));
	#else
		highp float depth = UnpackDepth32(texture2D(sampler, v_texcoord));
		gl_FragColor = PackDepth32(depth * depth);
	#endif
}
