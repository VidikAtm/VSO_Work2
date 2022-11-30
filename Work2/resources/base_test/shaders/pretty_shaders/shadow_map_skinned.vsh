#ifdef GL_ES
precision highp float;
#endif

const int MAX_BONES = 80;

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec4 a_weights;
attribute vec4 a_indices;

uniform mat4 u_coreModel;
uniform mat4 u_coreViewProj;
uniform vec4 mBonesArray[MAX_BONES*3];
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
varying vec3 v_lightDir;

void main()
{
	int i = int(a_indices.x) * 3;
	vec3 p = vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.x;
	
	i = int(a_indices.y) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.y;
	
	i = int(a_indices.z) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.z;
	
	i = int(a_indices.w) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.w;
	
	p = (u_coreModel * vec4(p, 1.0)).xyz;
	
	v_lightDir = u_lightPos - p;
	
	gl_Position = u_coreViewProj * vec4(p, 1.0);
}
