#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

uniform mediump float u_amp;

varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord1;

void main()
{
	vec4 dist = texture2D(sampler1, v_texcoord1);
	vec4 tex = texture2D(sampler, v_texcoord + u_amp * (dist.rg * vec2(2, 2) - vec2(1, 1)));
	
	gl_FragColor = tex;
}