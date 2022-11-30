#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_coreModel;

varying vec4 v_worldpos;
varying vec2 v_texcoord;

void main()
{
	v_texcoord = a_texcoord;
	v_worldpos = u_coreModel * a_vertex;
	gl_Position = u_coreModelViewProj * a_vertex;
}