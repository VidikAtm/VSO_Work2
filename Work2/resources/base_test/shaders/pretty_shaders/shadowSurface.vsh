#ifdef GL_ES
precision highp float;
#endif

const int MAX_BONES = 80;

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec3 a_normal;
attribute vec4 a_weights;
attribute vec4 a_indices;

uniform mat4 u_coreModel;
uniform mat4 u_coreView;
uniform mat4 u_coreProj;

uniform float u_depthModifier;
//uniform vec4 mBonesArray[MAX_BONES*3];

/// @excludeFromShaderConstants
uniform mat4 u_lightMatrix;
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
/// @excludeFromShaderConstants
uniform mediump vec3 u_lightColor;

varying vec2 v_texcoord;
varying vec3 v_normal;
varying vec3 v_lightDir;
varying vec3 v_localLightDir;
varying vec3 v_lightColor;

void main()
{
	v_texcoord = a_texcoord;

	vec3 p = a_vertex.xyz;
	p = (u_coreModel * vec4(p, 1.0)).xyz;	
	v_normal = vec3(dot(u_coreModel[0].xyz, a_normal), dot(u_coreModel[1].xyz, a_normal), dot(u_coreModel[2].xyz, a_normal));
	v_normal = normalize(v_normal);

	v_lightColor = u_lightColor;
	v_lightDir = u_lightPos - p;
	v_localLightDir = vec3(dot(u_lightMatrix[0].xyz, v_lightDir), dot(u_lightMatrix[1].xyz, v_lightDir), dot(u_lightMatrix[2].xyz, v_lightDir));

	gl_Position = u_coreView * vec4(p, 1.0);
	
	gl_Position.w *= 1.0 + u_depthModifier;
	
	gl_Position = u_coreProj * gl_Position;
}
