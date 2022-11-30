#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform float u_alphaThreshold;
uniform float u_glowThreshold;
uniform float u_glow;

varying vec4 v_color;
varying vec3 v_texcoord;

void main()
{
	v_color.rgb = a_color.rgb;
	v_texcoord.xy = a_texcoord;

	v_color.a = clamp(a_color.a / u_alphaThreshold, 0.0, 1.0);
	v_texcoord.z = u_glow * clamp((a_color.a - u_glowThreshold) / (1.0 - u_glowThreshold), 0.0, 1.0);
	
	gl_Position = u_coreModelViewProj * a_vertex;
}