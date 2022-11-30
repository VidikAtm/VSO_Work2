#ifdef GL_ES
precision highp float;
#endif

#define ADDITIONAL_AMBIENT_LIGHTS_ENABLED

//#define VERTEX_COLOR_ENABLED 1
//#define TBN_ENABLED 1
//#define SKINNING_ENABLED 1
//#define 3D_MASK_ENABLED 1
#if defined(SKINNING_ENABLED)
	const int MAX_BONES = 80; 
#endif

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute vec3 a_normal;
#if defined(SKINNING_ENABLED)
	attribute vec4 a_weights;
	attribute vec4 a_indices;
	//attribute vec3 a_tangent;
#endif
#ifdef TBN_ENABLED
	attribute vec3 a_binormal;
#endif
#if defined(VERTEX_COLOR_ENABLED)
	attribute mediump vec4 a_color;
#endif

uniform vec4 u_color;

uniform mat4 u_coreModel;
uniform mat4 u_coreView;
uniform mat4 u_coreProj;
uniform float u_depthModifier;

#if defined(SKINNING_ENABLED)
	uniform vec4 mBonesArray[MAX_BONES * 3];
#endif
uniform vec4 u_coreCameraPos;
/// @excludeFromShaderConstants
uniform mat4 u_lightMatrix;
/// @excludeFromShaderConstants
uniform vec3 u_lightPos;
/// @excludeFromShaderConstants
uniform mediump vec3 u_lightColor;
/// @excludeFromShaderConstants
uniform float u_maxLightDistance;

#ifdef ADDITIONAL_AMBIENT_LIGHTS_ENABLED
	/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightPos1;
	/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightPos2;
	/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightPos3;

	/// @excludeFromShaderConstants
	uniform float u_lightIntencity1;
	/// @excludeFromShaderConstants
	uniform float u_lightIntencity2;
	/// @excludeFromShaderConstants
	uniform float u_lightIntencity3;
	/// @excludeFromShaderConstants
	uniform highp float v_addLightDistanceInv1;
	/// @excludeFromShaderConstants
	uniform highp float v_addLightDistanceInv2;
	/// @excludeFromShaderConstants
	uniform highp float v_addLightDistanceInv3;
#endif

#if defined(MASK_3D_ENABLED)
	/// @default(0.9)
	uniform highp float u_softGage;
	/// @default(3.0)
	uniform highp float u_highlightGage;
#endif

//uniform float u_LightFresnelFactor; // отрезаем расчёт интенсивности по этой границе.

/// @range(-50.0, 50.0) @default(0.5)
uniform float offset_SSR; // "дальность" отражения.


varying mediump vec4 v_color;
varying highp vec2 v_texcoord;
varying highp vec3 v_normal;
#ifdef TBN_ENABLED
	varying highp vec3 v_tangent;
	varying highp vec3 v_binormal;
#endif
varying highp vec3 v_viewDir;
varying highp vec3 v_lightDir;
#ifdef ADDITIONAL_AMBIENT_LIGHTS_ENABLED
	varying highp vec3 v_addLightDir1;
	varying highp vec3 v_addLightDir2;
	varying highp vec3 v_addLightDir3;
	varying highp float v_addLightIntencity1;
	varying highp float v_addLightIntencity2;
	varying highp float v_addLightIntencity3;
#endif


#if defined(MASK_3D_ENABLED)
	varying highp vec3 v_pos;
	varying highp vec4 v_gages;
#endif

varying highp vec3 v_localLightDir;
varying mediump vec3 v_lightColor;
varying highp float v_maxLightDistanceInv;

//---------------------------------------------------------------------------------------------------------------------
varying highp vec2 v_texCoord_SSR;
// varying highp float v_fresnel_SSR;
//
// const vec3 eyeDir = vec3(0., 0., 1.);
//---------------------------------------------------------------------------------------------------------------------
vec2 getSphereMapCoords(vec3 eye, vec3 normal)
{
	vec3 reflected = reflect(eye, normal);
	float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
	return reflected.xy / m + 0.5;
}

vec2 getSSRCoords(vec3 eye, vec3 normal, vec2 scrPos)
{
	vec3 reflected = (reflect(eye, normal)*0.5);
	float m = 2.8284271247461903 * sqrt( reflected.z+1.0 );
	return normal.xy / (8.0 + dot(eye,normal)) + ((scrPos+1.0) * 0.5);
}
//---------------------------------------------------------------------------------------------------------------------

//varying vec3 v_worldPos;

void main()
{
	v_color = u_color;
	#if defined(VERTEX_COLOR_ENABLED)
		v_color *= a_color;
	#endif
	
	v_texcoord = a_texcoord;
#if defined(SKINNING_ENABLED)
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
		
	#ifdef TBN_ENABLED
		v_binormal = vec3(dot(m0.xyz, a_binormal), dot(m1.xyz, a_binormal), dot(m2.xyz, a_binormal));
		v_binormal = vec3(dot(u_coreModel[0].xyz, v_binormal), dot(u_coreModel[1].xyz, v_binormal), dot(u_coreModel[2].xyz, v_binormal));
		v_binormal = normalize(v_binormal);
		v_tangent = normalize(cross(v_normal, v_binormal));
	#endif
#else
	vec3 p = a_vertex.xyz;
	p = (u_coreModel * vec4(p, 1.0)).xyz;
	
	v_normal = a_normal.xyz;
	v_normal = vec3(dot(u_coreModel[0].xyz, v_normal), dot(u_coreModel[1].xyz, v_normal), dot(u_coreModel[2].xyz, v_normal));
	v_normal = normalize(v_normal);
#endif

#if defined(MASK_3D_ENABLED)
	v_gages.x = u_softGage;
	v_gages.y = 1.0 / (1.0 - v_gages.x);
	v_gages.z = u_softGage * u_highlightGage - (u_highlightGage - 1.0);
	v_gages.w = 1.0 / (1.0 - v_gages.z);
	
	v_pos = p;
#endif

	v_viewDir = u_coreCameraPos.xyz - p;
	v_lightColor = u_lightColor;
	v_lightDir = u_lightPos - p;
#ifdef ADDITIONAL_AMBIENT_LIGHTS_ENABLED
	v_addLightDir1 = (u_addLightPos1 - p);
	v_addLightDir2 = (u_addLightPos2 - p);
	v_addLightDir3 = (u_addLightPos3 - p);
	v_addLightIntencity1 = min(length(v_addLightDir1) * v_addLightDistanceInv1, 1.0);
	v_addLightIntencity2 = min(length(v_addLightDir2) * v_addLightDistanceInv2, 1.0);
	v_addLightIntencity3 = min(length(v_addLightDir3) * v_addLightDistanceInv3, 1.0);
	v_addLightIntencity1 = (1.0 - v_addLightIntencity1 * v_addLightIntencity1) * u_lightIntencity1;
	v_addLightIntencity2 = (1.0 - v_addLightIntencity2 * v_addLightIntencity2) * u_lightIntencity2;
	v_addLightIntencity3 = (1.0 - v_addLightIntencity3 * v_addLightIntencity3) * u_lightIntencity3;
	v_addLightDir1 = normalize(v_addLightDir1);
	v_addLightDir2 = normalize(v_addLightDir2);
	v_addLightDir3 = normalize(v_addLightDir3);
#endif
	v_localLightDir = vec3(dot(u_lightMatrix[0].xyz, v_lightDir), dot(u_lightMatrix[1].xyz, v_lightDir), dot(u_lightMatrix[2].xyz, v_lightDir));

	v_maxLightDistanceInv = 1.0 / u_maxLightDistance;

	gl_Position = u_coreView * vec4(p, 1.0);
	gl_Position.w *= 1.0 + u_depthModifier;
	gl_Position = u_coreProj * gl_Position;
	gl_Position = gl_Position / gl_Position.w;
	vec4 screenPosition = gl_Position / gl_Position.w;
	 
	mat4 viewProj = u_coreProj * u_coreView;
	vec3 normal = normalize( mat3(viewProj[0].xyz, viewProj[1].xyz, viewProj[2].xyz) * v_normal );

	highp float z = sqrt( normal.x*normal.x + normal.y*normal.y) + 0.001;
	vec2 normalTransformed = normal.xy / z * (1.0 - z);

	v_texCoord_SSR = (screenPosition.xy + 1.0) * 0.5;
}
