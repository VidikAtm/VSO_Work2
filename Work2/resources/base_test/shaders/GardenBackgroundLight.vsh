#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_screencoord;

void main()
{
	v_color = a_color;
	v_texcoord = a_texcoord;
	
	vec4 pos = u_coreModelViewProj * a_vertex;
	v_screencoord = pos.xy * 0.5 + 0.5;
	gl_Position = pos;
}