#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec2 v_texcoord0;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;
varying vec2 v_texcoord3;

void main()
{
	v_texcoord0 = a_texcoord;
	v_texcoord1 = texCoordSampler1(a_texcoord);
	v_texcoord2 = texCoordSampler2(a_texcoord);
	v_texcoord3 = texCoordSampler3(a_texcoord);
	
	gl_Position = u_coreModelViewProj * a_vertex;
}