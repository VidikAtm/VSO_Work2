#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_autoWorldMatrix;

varying vec4 v_color;
varying vec2 v_texcoord;

uniform vec3 u_size;

void main()
{
	vec4 v = u_autoWorldMatrix * a_vertex;

	v_color.rgb = (v.xyz + u_size * vec3(0.5, 0.5, 0.5)) / u_size;
	v_color.a = 1.0;
	
	v_texcoord = a_texcoord;

	gl_Position = u_coreModelViewProj * a_vertex;
}