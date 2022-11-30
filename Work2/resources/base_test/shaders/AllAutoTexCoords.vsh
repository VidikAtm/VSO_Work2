#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec4 v_color;
varying vec4 v_texcoord01;
varying vec4 v_texcoord23;
varying vec2 v_texcoord4;

void main()
{
	v_color = a_color;
	v_texcoord01.xy = a_texcoord;
	v_texcoord01.zw = texCoordSampler1(a_texcoord);
	v_texcoord23.xy = texCoordSampler2(a_texcoord);
	v_texcoord23.zw = texCoordSampler3(a_texcoord);
	v_texcoord4 = texCoordSampler01(a_texcoord);
	gl_Position = u_coreModelViewProj * a_vertex;
}