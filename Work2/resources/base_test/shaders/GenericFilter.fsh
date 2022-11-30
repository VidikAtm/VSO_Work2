#include "SamplesCount.cginc"

#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_samples[SAMPLES_COUNT];


varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	highp vec4 color = texture2D(sampler, v_texcoord + u_samples[0].yz) * u_samples[0].x;
	for (int i = 1; i < SAMPLES_COUNT; i++)
	{
		color += texture2D(sampler, v_texcoord + u_samples[i].yz) * u_samples[i].x;
	}
	gl_FragColor = v_color * color;
}