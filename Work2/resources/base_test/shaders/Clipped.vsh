#ifdef GL_ES
precision highp float;
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
uniform mat4 u_coreModel;
/// @excludeFromShaderConstants
uniform vec4 u_clipPlain;
varying vec2 v_texcoord;
varying float v_clipPlainDistance;

void main()
{
	v_texcoord = a_texcoord;
	v_clipPlainDistance = dot(u_coreModel * a_vertex, u_clipPlain);
	gl_Position = u_coreModelViewProj * a_vertex;
}
