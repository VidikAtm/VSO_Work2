#ifdef GL_ES
precision highp float;
#endif

const int MAX_BONES = 80;

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec4 a_weights;
attribute vec4 a_indices;

uniform mat4 u_coreModelViewProj;
uniform vec4 mBonesArray[MAX_BONES*3];
uniform vec4 u_color;

varying vec2 v_texcoord;
varying vec4 v_color;

void main()
{
	v_texcoord = a_texcoord;
	v_color = u_color;

	int i = int(a_indices.x) * 3;
	vec3 p = vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.x;
	
	i = int(a_indices.y) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.y;
	
	i = int(a_indices.z) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.z;
	
	i = int(a_indices.w) * 3;
	p += vec3(dot(mBonesArray[i], a_vertex), dot(mBonesArray[i+1], a_vertex), dot(mBonesArray[i+2], a_vertex)) * a_weights.w;

	gl_Position = u_coreModelViewProj * vec4(p, 1.0);
}