#ifdef GL_ES
precision highp float;
#endif

attribute highp vec4 a_vertex;
attribute highp vec2 a_texcoord;
//attribute mediump vec4 a_color;

uniform highp mat4 u_modelview;
varying highp vec4 v_position;
varying highp vec2 v_texcoord;

void main()
{	
	v_texcoord = a_texcoord;
	v_position = u_modelview * a_vertex;	
	gl_Position = v_position;
	//v_color = a_color;
}
