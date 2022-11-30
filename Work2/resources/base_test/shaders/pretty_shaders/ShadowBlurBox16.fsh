#ifdef GL_ES
	precision highp float;
#endif

#define DIRECTIONAL_MODE 1

#include "ShadowHelper.glsl"

uniform sampler2D sampler;

varying mediump vec2 v_texcoord;
varying mediump float offsetW;
varying mediump float offsetH;

#define MULTIPLE 0.08125//0.11111 0.076923
#define MULTIPLE2 0.04375//0.05555 0.076923

void main()
{
	#ifdef DEPTH_TO_16B
		#ifdef VSM_HALF_BLUR
			mediump vec4 depth0 = texture2D(sampler, v_texcoord);

			#ifdef DIRECTIONAL_MODE
				vec2 tx = v_texcoord;
				vec2 dx  = vec2(offsetW,offsetH);
				vec2 sdx = dx;
				highp float sum = DecodeFloatFromVec2(depth0.zw) * 0.134598;

				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.127325; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.107778; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.081638; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.055335; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.033562; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.018216; 
				sdx += dx;
				sum += (DecodeFloatFromVec2(texture2D( sampler, tx + sdx ).zw) + DecodeFloatFromVec2(texture2D( sampler, tx - sdx ).zw) )* 0.008847; 
			#else
				float sum = 0.0;

				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW, 0.0)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW, 0.0)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(0.0, offsetH)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(0.0, offsetH)).zw) * MULTIPLE;

				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH)).zw) * MULTIPLE;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH)).zw) * MULTIPLE;

				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW * 2.0, 0.0)).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW * 2.0, 0.0)).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(0.0, offsetH * 2.0)).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(0.0, offsetH * 2.0)).zw) * MULTIPLE2;

				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH) * 2.0).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH) * 2.0).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH) * 2.0).zw) * MULTIPLE2;
				sum += DecodeFloatFromVec2(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH) * 2.0).zw) * MULTIPLE2;
			#endif
			gl_FragColor = vec4(depth0.xy, EncodeFloatToVec2(sum));

		#else
			#ifdef DIRECTIONAL_MODE
				highp vec2 sum = DecodeVec2FromVec4(texture2D(sampler, v_texcoord)) * 0.134598;

				vec2 tx = v_texcoord;
				vec2 dx  = vec2(offsetW,offsetH);
				vec2 sdx = dx;

				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.127325; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.107778; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.081638; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.055335; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.033562; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.018216; 
				sdx += dx;
				sum += (DecodeVec2FromVec4(texture2D( sampler, tx + sdx )) + DecodeVec2FromVec4(texture2D( sampler, tx - sdx )) )* 0.008847; 
			#else
				highp vec2 sum = vec2(0.0);
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW, 0.0))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW, 0.0))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(0.0, offsetH))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(0.0, offsetH))) * MULTIPLE;

				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH))) * MULTIPLE;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH))) * MULTIPLE;

				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW * 2.0, 0.0))) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW * 2.0, 0.0))) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(0.0, offsetH * 2.0))) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(0.0, offsetH * 2.0))) * MULTIPLE2;

				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH) * 2.0)) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH) * 2.0)) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH) * 2.0)) * MULTIPLE2;
				sum += DecodeVec2FromVec4(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH) * 2.0)) * MULTIPLE2;
			#endif
			gl_FragColor = vec4(EncodeVec2ToVec4(sum));
		#endif
	#else
		#ifdef DIRECTIONAL_MODE
			vec2 tx = v_texcoord;
			vec2 dx  = vec2(offsetW,offsetH);
			vec2 sdx = dx;
			highp float sum = UnpackDepth32(texture2D( sampler, tx )) * 0.134598;

			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.127325; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.107778; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.081638; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.055335; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.033562; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.018216; 
			sdx += dx;
			sum += (UnpackDepth32(texture2D( sampler, tx + sdx )) + UnpackDepth32(texture2D( sampler, tx - sdx )) )* 0.008847; 
		#else
			highp float sum = 0.0;

			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW, 0.0))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW, 0.0))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(0.0, offsetH))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(0.0, offsetH))) * MULTIPLE;

			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH))) * MULTIPLE;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH))) * MULTIPLE;

			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW * 2.0, 0.0))) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW * 2.0, 0.0))) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(0.0, offsetH * 2.0))) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(0.0, offsetH * 2.0))) * MULTIPLE2;

			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW, offsetH) * 2.0)) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW, offsetH) * 2.0)) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord + vec2(offsetW, -offsetH) * 2.0)) * MULTIPLE2;
			sum += UnpackDepth32(texture2D(sampler, v_texcoord - vec2(offsetW, -offsetH) * 2.0)) * MULTIPLE2;
		#endif

		gl_FragColor = vec4(PackDepth32(sum));
	#endif
}
