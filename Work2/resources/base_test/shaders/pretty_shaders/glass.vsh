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
uniform vec4 mBonesArray[MAX_BONES * 3];
uniform vec4 u_coreCameraPos;
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
/// @excludeFromShaderConstants
uniform mediump vec3 u_lightColor;

/// @range(-50.0, 50.0) @default(3.01)
uniform float offset_SSR; // "дальность" отражения.

varying vec2 v_texcoord;
varying vec3 v_normal;
varying vec3 v_viewDir;
varying vec3 v_lightDir;
varying vec3 v_lightColor;
//---------------------------------------------------------------------------------------------------------------------
varying vec2 v_texCoord_SSR;
// varying float v_fresnel_SSR;

void main()
{
	v_texcoord = a_texcoord;

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
	v_viewDir = u_coreCameraPos.xyz - p;
	v_lightColor = u_lightColor;
	v_lightDir = u_lightPos - p;

	mat4 viewProj = u_coreProj * u_coreView;

	gl_Position = viewProj * vec4(p, 1.0);

	vec4 screenPosition = gl_Position / gl_Position.w;
	 
	vec3 normal = normalize( mat3(viewProj[0].xyz, viewProj[1].xyz, viewProj[2].xyz) * v_normal );

	highp float z = sqrt( normal.x*normal.x + normal.y*normal.y) + 0.001;
	vec2 normalTransformed = normal.xy / z * (1.0 - z);

	v_texCoord_SSR = (screenPosition.xy + 1.0) * 0.5 + normalTransformed * offset_SSR;
}
