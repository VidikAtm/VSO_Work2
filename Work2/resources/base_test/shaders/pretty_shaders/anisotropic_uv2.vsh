#ifdef GL_ES
precision highp float;
#endif

const int MAX_BONES = 80;

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec2 a_texcoord1;
attribute vec3 a_normal;
attribute vec4 a_weights;
attribute vec4 a_indices;
attribute vec3 a_tangent;
attribute vec3 a_binormal;

uniform mat4 u_coreModel;
uniform mat4 u_coreViewProj;
uniform vec4 mBonesArray[MAX_BONES * 3];
uniform vec4 u_coreCameraPos;
/// @excludeFromShaderConstants
uniform mat4 u_lightMatrix;
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
/// @excludeFromShaderConstants
uniform mediump vec3 u_lightColor;


varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec3 v_normal;
varying vec3 v_tangent;
varying vec3 v_binormal;
varying vec3 v_viewDir;
varying vec3 v_lightDir;
varying vec3 v_localLightDir;
varying vec3 v_lightColor;

void main()
{
	v_texcoord = a_texcoord;
	v_texcoord1 = a_texcoord1;

	int i0 = int(a_indices.x) * 3;
	int i1 = int(a_indices.y) * 3;
	int i2 = int(a_indices.z) * 3;
	int i3 = int(a_indices.w) * 3;
	vec4 m0, m1, m2;
	m0 = mBonesArray[i0] * a_weights.x + mBonesArray[i1] * a_weights.y + mBonesArray[i2] * a_weights.z + mBonesArray[i3] * a_weights.w;
	++i0;
	++i1;
	++i2;
	++i3;
	m1 = mBonesArray[i0] * a_weights.x + mBonesArray[i1] * a_weights.y + mBonesArray[i2] * a_weights.z + mBonesArray[i3] * a_weights.w;
	++i0;
	++i1;
	++i2;
	++i3;
	m2 = mBonesArray[i0] * a_weights.x + mBonesArray[i1] * a_weights.y + mBonesArray[i2] * a_weights.z + mBonesArray[i3] * a_weights.w;
	
	vec3 p = vec3(dot(m0, a_vertex), dot(m1, a_vertex), dot(m2, a_vertex));
	p = (u_coreModel * vec4(p, 1.0)).xyz;
	
	v_normal = vec3(dot(m0.xyz, a_normal), dot(m1.xyz, a_normal), dot(m2.xyz, a_normal));
	v_normal = vec3(dot(u_coreModel[0].xyz, v_normal), dot(u_coreModel[1].xyz, v_normal), dot(u_coreModel[2].xyz, v_normal));
	v_normal = normalize(v_normal);
	
	v_tangent = vec3(dot(m0.xyz, a_tangent), dot(m1.xyz, a_tangent), dot(m2.xyz, a_tangent));
	v_tangent = vec3(dot(u_coreModel[0].xyz, v_tangent), dot(u_coreModel[1].xyz, v_tangent), dot(u_coreModel[2].xyz, v_tangent));
	v_tangent = normalize(v_tangent);
	
	v_binormal = vec3(dot(m0.xyz, a_binormal), dot(m1.xyz, a_binormal), dot(m2.xyz, a_binormal));
	v_binormal = vec3(dot(u_coreModel[0].xyz, v_binormal), dot(u_coreModel[1].xyz, v_binormal), dot(u_coreModel[2].xyz, v_binormal));
	v_binormal = normalize(v_binormal);
	
	v_viewDir = u_coreCameraPos.xyz - p;
	v_lightColor = u_lightColor;
	v_lightDir = u_lightPos - p;
	v_localLightDir = vec3(dot(u_lightMatrix[0].xyz, v_lightDir), dot(u_lightMatrix[1].xyz, v_lightDir), dot(u_lightMatrix[2].xyz, v_lightDir));

	gl_Position = u_coreViewProj * vec4(p, 1.0);
}
