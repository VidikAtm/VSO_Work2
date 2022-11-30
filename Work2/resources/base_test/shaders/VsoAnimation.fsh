#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1; // Anim1
uniform sampler2D sampler2; // Anim2

uniform float u_span;

uniform float u_progress_1r;
uniform float u_progress_1g;
uniform float u_progress_1b;
uniform float u_progress_2r;
uniform float u_progress_2g;

varying vec4 v_color;
varying vec2 v_texcoord;

float xform(float x, float p, float span, float rcpDblSpan)
{
	return x > 0.0 ? (p - x + span) * rcpDblSpan : 0.0;
}

void main()
{
	vec4 color = texture2D(sampler, v_texcoord);
	vec3 anim1 = texture2D(sampler1, v_texcoord).rgb;
	vec3 anim2 = texture2D(sampler2, v_texcoord).rgb;
	
	float rcpDblSpan = 0.5 / u_span;
	
	float v1 = xform(anim1.r, u_progress_1r, u_span, rcpDblSpan);
	float v2 = xform(anim1.g, u_progress_1g, u_span, rcpDblSpan);
	float v3 = xform(anim1.b, u_progress_1b, u_span, rcpDblSpan);
	float v4 = xform(anim2.r, u_progress_2r, u_span, rcpDblSpan);
	float v5 = xform(anim2.g, u_progress_2g, u_span, rcpDblSpan);
	
	float v6 = max(v1, v2);
	float v7 = max(v3, v4);
	float v8 = max(v6, v7);
	float v = clamp(max(v8, v5), 0.0, 1.0);
	
	color *= v_color;
	color.rgb *= v;
	
	gl_FragColor = color;
}