#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec3 a_normal;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform float u_add;

varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	v_color = 2.0 * (u_coreModelViewProj * vec4(a_normal, 0.0)) + 1.0;
	v_color.b = a_texcoord.x + u_add;
	v_color.w = 1.0;

	v_texcoord = a_texcoord;

	gl_Position = u_coreModelViewProj * a_vertex;
}