#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

uniform vec2 u_tex2Offset;

uniform vec3 u_axisX;
uniform vec3 u_axisY;

uniform vec3 u_axisX2;
uniform vec3 u_axisY2;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

void main()
{
	vec4 pos = u_coreModelViewProj * a_vertex;
	v_color = a_color;
	v_texcoord = a_texcoord;
	
	v_texcoord1.x = dot(u_axisX.xy, pos.xy) + u_axisX.z;
	v_texcoord1.y = dot(u_axisY.xy, pos.xy) + u_axisY.z;
	
	v_texcoord2.x = dot(u_axisX2.xy, pos.xy) + u_axisX2.z + u_tex2Offset.x;
	v_texcoord2.y = dot(u_axisY2.xy, pos.xy) + u_axisY2.z + u_tex2Offset.y;
	
	gl_Position = pos;
}