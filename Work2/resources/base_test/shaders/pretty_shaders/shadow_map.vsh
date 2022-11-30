#ifdef GL_ES
precision highp float;
#endif

const int MAX_BONES = 80;

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec4 a_weights;
attribute vec4 a_indices;

uniform mat4 u_coreModel;
uniform mat4 u_coreModelViewProj;
uniform vec4 mBonesArray[MAX_BONES*3];
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
varying vec3 v_lightDir;

void main()
{
	v_lightDir = u_lightPos - (u_coreModel * vec4(a_vertex.xyz, 1.0)).xyz;
	gl_Position = u_coreModelViewProj * vec4(a_vertex.xyz, 1.0);
}
