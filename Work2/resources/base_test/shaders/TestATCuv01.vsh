#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec2 v_tc0;
varying float v_alpha;

void main()
{
	v_tc0 = a_texcoord;
	v_alpha = texCoordSampler01(a_texcoord).x;
	
	gl_Position = u_coreModelViewProj * a_vertex;
}