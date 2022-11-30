#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

// Спиральное закручивание текстуры. Стандартное значение 2.400
uniform mediump float u_angle;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec4 v_rotation;

void main()
{
	v_color = a_color;
	v_texcoord = a_texcoord;

	float cos76 = cos(u_angle);
	float sin76 = sin(u_angle);
	v_rotation = vec4(cos76, -sin76, sin76, cos76);

	gl_Position = u_coreModelViewProj * a_vertex;
}
