#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

uniform vec4 u_scaleOffset;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	v_color = a_color;
	v_texcoord = a_texcoord;
	
	vec4 pos = u_coreModelViewProj * a_vertex;
	v_texcoord1 = u_scaleOffset.xy * pos.xy + u_scaleOffset.zw;
	gl_Position = pos;
}