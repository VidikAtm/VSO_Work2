#include "SamplesCount.cginc"

#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform vec2 u_center;
uniform float u_scaleMin;
uniform float u_scaleMinRange;
uniform float u_scaleCoeff;
uniform vec4 u_samples[SAMPLES_COUNT];


varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	vec2 dir = v_texcoord - u_center;
	float len = length(dir);
	dir /= len;
	
	float scale = clamp((len - u_scaleMinRange) * u_scaleCoeff + u_scaleMin, u_scaleMin, 1.0);
	dir *= scale;
	
	highp vec4 color = texture2D(sampler, v_texcoord + u_samples[0].y * dir) * u_samples[0].x;
	for (int i = 1; i < SAMPLES_COUNT; i++)
	{
		color += texture2D(sampler, v_texcoord + u_samples[i].y * dir) * u_samples[i].x;
	}
	gl_FragColor = v_color * color;
}