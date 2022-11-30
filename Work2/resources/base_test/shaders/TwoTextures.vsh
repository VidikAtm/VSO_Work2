#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

/// @default(1.0, 1.0)
uniform vec2 u_distortionUvScale;
uniform vec2 u_distortionUvOffset;
/// @default(1.0, 1.0)
uniform vec2 u_noiseUvScale;
uniform vec2 u_noiseUvOffset;

void main()
{
	v_color = a_color;
	v_texcoord = a_texcoord;
	v_texcoord1 = v_texcoord * u_distortionUvScale + u_distortionUvOffset;
	v_texcoord2 = v_texcoord * u_noiseUvScale+ u_noiseUvOffset;
	gl_Position = u_coreModelViewProj * a_vertex;
}