attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec2 a_texcoord1;

uniform mat4 u_coreModelViewProj;

varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

void main()
{
	v_texcoord1 = a_texcoord;
	v_texcoord2 = a_texcoord1;
	gl_Position = u_coreModelViewProj * a_vertex;
}