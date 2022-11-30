#include "autotexcoords.cginc"

#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mediump float u_quat14PixelShift;
uniform mediump float u_quat23Shift;

varying vec4 v_texcoordRaw;
varying vec2 v_texcoord1;

varying vec4 v_shifts14;
varying vec4 v_shifts23;

void main()
{
	v_texcoordRaw.xy = a_texcoord;
	v_texcoordRaw.zw = texCoordSampler01(a_texcoord);
	v_texcoord1.xy = texCoordSampler1(a_texcoord);
	
	v_shifts14 = vec4(u_quat14PixelShift * u_autoUVPixelSize0.x, u_quat14PixelShift * u_autoUVPixelSize0.y, u_quat23Shift * u_autoUVPixelSize0.z, u_quat23Shift * u_autoUVPixelSize0.w);
	v_shifts23 = vec4(u_quat14PixelShift * u_autoUVPixelSize1.x, u_quat14PixelShift * u_autoUVPixelSize1.y, u_quat23Shift * u_autoUVPixelSize1.z, u_quat23Shift * u_autoUVPixelSize1.w);
	
	gl_Position = u_coreModelViewProj * a_vertex;
}