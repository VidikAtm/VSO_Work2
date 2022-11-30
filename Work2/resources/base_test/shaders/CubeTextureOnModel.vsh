#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec3 a_normal;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec3 v_normal;

void main()
{
	v_texcoord = a_texcoord;
	v_normal = normalize(a_vertex.xyz);

	gl_Position = u_coreModelViewProj * a_vertex;
}