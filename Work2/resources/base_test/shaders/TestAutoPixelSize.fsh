#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

varying vec4 v_texcoordRaw;
varying vec2 v_texcoord1;

varying vec4 v_shifts14;
varying vec4 v_shifts23;

void main()
{
	// only for testing purposes! It's better to place such texcoord logic into a vertex shader.
	vec4 tex1 = texture2D(sampler, v_texcoordRaw.xy + v_shifts14.xy);
	vec4 tex2 = texture2D(sampler, v_texcoordRaw.xy + vec2(v_shifts14.z, -v_shifts14.w));
	vec4 tex3 = texture2D(sampler1, v_texcoord1 + vec2(-v_shifts23.z, v_shifts23.w));
	vec4 tex4 = texture2D(sampler1, v_texcoord1 + vec2(-v_shifts23.x, -v_shifts23.y));
	
	float quat1 = min(1.0, 100.0 * max(0.0, v_texcoordRaw.z - 0.5)) * min(1.0, 100.0 * max(0.0, v_texcoordRaw.w - 0.5));
	float quat2 = min(1.0, 100.0 * max(0.0, v_texcoordRaw.z - 0.5)) * min(1.0, 100.0 * max(0.0, 0.5 - v_texcoordRaw.w));
	float quat3 = min(1.0, 100.0 * max(0.0, 0.5 - v_texcoordRaw.z)) * min(1.0, 100.0 * max(0.0, 0.5 - v_texcoordRaw.w));
	float quat4 = min(1.0, 100.0 * max(0.0, 0.5 - v_texcoordRaw.z)) * min(1.0, 100.0 * max(0.0, v_texcoordRaw.w - 0.5));
	
	gl_FragColor = tex1 * quat1 + tex2 * quat2 + tex3 * quat3 + tex4 * quat4;
}
