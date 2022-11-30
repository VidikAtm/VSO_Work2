#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec3 a_normal;

uniform mat4 u_coreModel;
uniform mat4 u_coreModelViewProj;

varying vec2 v_texcoord;
varying vec3 v_normal;

void main()
{
	v_texcoord = a_texcoord;
	v_normal = (u_coreModel * vec4(a_normal, 0.0)).xyz;
	
	gl_Position = u_coreModelViewProj * a_vertex;
}
