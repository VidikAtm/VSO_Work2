attribute vec4 a_vertex;
attribute mediump vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_modelview;

varying mediump vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	v_color = a_color;
	v_texcoord = a_texcoord;
	gl_Position = u_modelview * a_vertex;
}
