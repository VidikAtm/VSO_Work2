#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

uniform vec3 u_axisX;
uniform vec3 u_axisY;
uniform vec4 u_mulColor;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	vec4 pos = u_coreModelViewProj * a_vertex;
	v_color = a_color * u_mulColor;
	v_texcoord = a_texcoord;
	v_texcoord1.x = dot(u_axisX.xy, pos.xy) + u_axisX.z;
	v_texcoord1.y = dot(u_axisY.xy, pos.xy) + u_axisY.z;
	gl_Position = pos;
}