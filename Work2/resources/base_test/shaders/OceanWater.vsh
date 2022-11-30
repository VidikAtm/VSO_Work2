#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_autoWorldMatrix;
//uniform mat4 u_autoViewProjMatrix;

varying vec4 v_color;
varying vec4 v_screenPos;
varying vec3 v_worldPos;

void main()
{
	v_color = a_color;
	
	v_screenPos = u_coreModelViewProj * a_vertex;
	v_worldPos = (u_autoWorldMatrix * a_vertex).xyz;
	
	gl_Position = v_screenPos;
}