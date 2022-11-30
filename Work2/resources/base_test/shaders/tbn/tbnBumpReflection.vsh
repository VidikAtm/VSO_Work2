#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec3 a_tangent;
attribute vec3 a_normal;

uniform mat4 u_coreModel;
uniform mat4 u_coreModelViewProj;
uniform vec3 u_autoWorldCameraPos;

varying vec2 v_texcoord;
varying vec3 v_tangent;
varying vec3 v_normal;
varying vec3 v_viewDir;

void main()
{
	vec3 worldpos = (u_coreModel * a_vertex).xyz;

	v_texcoord = a_texcoord;
	
	v_tangent = (u_coreModel * vec4(a_tangent, 0.0)).xyz;
	v_normal = (u_coreModel * vec4(a_normal, 0.0)).xyz;
	
	v_viewDir = worldpos - u_autoWorldCameraPos;
	
	gl_Position = u_coreModelViewProj * a_vertex;
}
