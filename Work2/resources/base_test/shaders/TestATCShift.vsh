#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform vec2 u_shiftPixels;
uniform vec2 u_shiftAbsolute;

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
	
	v_tc0 = v_tc0 + u_shiftPixels * u_autoUVPixelSize0.xy;
	v_tc1 = v_tc1 + u_shiftPixels * u_autoUVPixelSize1.xy;
	v_tc2 = v_tc2 + u_shiftPixels * u_autoUVPixelSize2.xy;
	v_tc3 = v_tc3 + u_shiftPixels * u_autoUVPixelSize3.xy;
	
	v_tc0 = v_tc0 + u_shiftAbsolute * u_autoUVPixelSize0.zw;
	v_tc1 = v_tc1 + u_shiftAbsolute * u_autoUVPixelSize1.zw;
	v_tc2 = v_tc2 + u_shiftAbsolute * u_autoUVPixelSize2.zw;
	v_tc3 = v_tc3 + u_shiftAbsolute * u_autoUVPixelSize3.zw;
	
	gl_Position = u_coreModelViewProj * a_vertex;
}