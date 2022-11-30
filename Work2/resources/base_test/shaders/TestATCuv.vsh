#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec2 v_tc0;
varying vec2 v_tc1;
varying vec2 v_tc2;
varying vec2 v_tc3;

void main()
{
	v_tc0 = a_texcoord;
	v_tc1 = texCoordSampler1(a_texcoord);
	v_tc2 = texCoordSampler2(a_texcoord);
	v_tc3 = texCoordSampler3(a_texcoord);
	
	gl_Position = u_coreModelViewProj * a_vertex;
}