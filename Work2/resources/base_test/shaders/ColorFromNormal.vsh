#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec3 a_normal;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec4 v_color;

void main()
{
	v_color.rgb = a_normal;
	v_color.a = 1.0;
	gl_Position = u_coreModelViewProj * a_vertex;
}