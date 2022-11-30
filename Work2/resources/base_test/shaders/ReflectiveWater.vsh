#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_coreModel;

uniform vec2 u_texScale;

varying vec2 v_texcoord;
varying vec4 v_worldPos;
varying vec4 v_screenPos;

void main()
{
	vec4 pos = u_coreModelViewProj * a_vertex;
	
	v_texcoord = a_texcoord * u_texScale;
	
	v_worldPos = u_coreModel * a_vertex;
	v_screenPos = pos;
	
	gl_Position = pos;
}