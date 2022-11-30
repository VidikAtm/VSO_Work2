
//#define VSM_ENABLED 1
//#define DEPTH_TO_16B 1
//#define VSM_HALF_BLUR 1
#define VSM_BIAS 0.01

#define ESM_ENABLED 1
#define ESM_FACTOR 10.0 // 0.5
#define ESM_BIAS 0.0001
#define ESM_EXP_MAX 22026.3176 //Exp(0.5) = 1,64872 , Exp(10.0) = 22026.3176
#define ESM_PACK_F (1.0 / ESM_EXP_MAX) // for ESM_FACTOR = 10
#define ESM_UNPACK_F (ESM_EXP_MAX)

#define SM_ZBIAS 0.0
#define PCF_OFFSET 0.002

#define BITE_DIV_INV (1.0 / 256.0) //0.00392


vec4 PackDepth32(in float depth)
{
	depth *= (256.0*256.0*256.0 - 1.0) / (256.0*256.0*256.0);
	vec4 encode = fract(depth * vec4(1.0, 256.0, 256.0*256.0, 256.0*256.0*256.0));
	return vec4(encode.xyz - encode.yzw / 256.0, encode.w) + 1.0 / 512.0;
	//return vec4(depth, 0.0, 0.0, 1.0);
}

float UnpackDepth32(in vec4 pack)
{
	float depth = dot(pack, 1.0 / vec4(1.0, 256.0, 256.0*256.0, 256.0*256.0*256.0));
	return depth * (256.0*256.0*256.0) / (256.0*256.0*256.0 - 1.0);
}

vec2 EncodeFloatToVec2(in float depth) 
{
    depth *= (256.0 - 1.0) * BITE_DIV_INV;
	vec2 encode = fract(depth * vec2(1.0, 256.0));
	return vec2(encode.x - encode.y * BITE_DIV_INV, encode.y) + 1.0 / 512.0;
}

highp float DecodeFloatFromVec2( in vec2 pack ) 
{
    float depth = dot(pack, vec2(1.0, BITE_DIV_INV));
	return depth * ((256.0) / (256.0 - 1.0));
}

vec4 EncodeVec2ToVec4(in vec2 v) 
{
    return vec4( EncodeFloatToVec2(v.x), EncodeFloatToVec2(v.y));
}

vec2 DecodeVec2FromVec4( in vec4 v ) 
{
    return vec2( DecodeFloatFromVec2(v.xy), DecodeFloatFromVec2(v.zw));
}

float linstep(in float min, in float max, in float v) 
{
    return clamp((v - min) / (max - min), 0.0, 1.0);
}

float ReduceLightBleeding(in float p_max, in float amount) 
{
    return linstep(amount, 1.0, p_max); 
}


float ChebishevFilter(in vec2 sDepth, in float zLinear)
{
    float d = sDepth.x;
    float dispercion = sDepth.y - sDepth.x * sDepth.x;
    float diff = (zLinear) - sDepth.x;
    float intencity = clamp(dispercion / ( dispercion + diff * diff ) + VSM_BIAS, 0.0, 1.0);
    //float intencity = 1.0 - (1.0 - step(zLinear, sDepth.x)) * (1.0 - clamp(dispercion / ( dispercion + diff * diff ), 0.0, 1.0));

    //float AO = 0.5 * mix(pow(clamp((zLinear - sDepth.x) * 5., 0.3, 1.0), 1.0), 1.0, intencity);
    intencity = ReduceLightBleeding(intencity, 0.34);
    return max(intencity, step(zLinear, sDepth.x));// + AO;
}

float ExponentFilter(in float sDepth, in float zLinear)
{
		float zExp = exp(ESM_BIAS - ESM_FACTOR * zLinear);
        float intencity = clamp((sDepth * ESM_UNPACK_F + 1.0) * zExp, 0.0, 1.0);
        intencity = ReduceLightBleeding(intencity, 0.7);
        return intencity;
}

float FilterPCF(in sampler2D shadowSampler, in vec2 uv, in float zLinear)
{
    float shadowDist0 = UnpackDepth32(texture2D(shadowSampler, uv + vec2(PCF_OFFSET, 0.0)));
    float shadowDist1 = UnpackDepth32(texture2D(shadowSampler, uv + vec2(0.0, PCF_OFFSET)));
    float shadowDist2 = UnpackDepth32(texture2D(shadowSampler, uv + vec2(-PCF_OFFSET, 0.0)));
    float shadowDist3 = UnpackDepth32(texture2D(shadowSampler, uv + vec2(0.0, -PCF_OFFSET)));
    
    float s0 = step(zLinear, shadowDist0);
    float s1 = step(zLinear, shadowDist1);
    float s2 = step(zLinear, shadowDist2);
    float s3 = step(zLinear, shadowDist3);

    return (s0 + s1 + s2 + s3) * 0.25;
}