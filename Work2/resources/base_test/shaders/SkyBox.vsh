#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_coreModel;

varying vec3 v_texcoord;

void main()
{
	v_texcoord = (u_coreModel * a_vertex).xyz - u_coreModel[3].xyz;
	gl_Position = u_coreModelViewProj * a_vertex;
}