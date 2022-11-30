#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

/// @excludeFromShaderConstants
uniform mediump float u_time;
/// @range(0,0.05)
uniform mediump float u_amp;
/// @range(0,50)
uniform mediump float u_len;

varying highp vec2 v_texcoord;

void main()
{
	vec2 dir = v_texcoord - vec2(0.5, 0.5);
	float dist = length(dir);
	vec2 offset = dir * (u_amp * sin(dist * u_len + u_time) / dist);
	
	gl_FragColor = texture2D(sampler, v_texcoord + offset);
}