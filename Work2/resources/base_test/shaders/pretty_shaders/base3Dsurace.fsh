#ifdef GL_ES
precision mediump float;
#endif

highp mat3 transpose(in highp mat3 inMatrix) 
{
    highp vec3 i0 = inMatrix[0];
    highp vec3 i1 = inMatrix[1];
    highp vec3 i2 = inMatrix[2];

    return mat3(
		vec3(i0.x, i1.x, i2.x),
		vec3(i0.y, i1.y, i2.y),
		vec3(i0.z, i1.z, i2.z)
	);
}

#include "ShadowHelper.glsl"
// #define USE_BECKMANN_ANISOTROPIC 1 // or GGX anisotropic model
// #define SHADOWS_ENABLED 1
//#define CUSTOM_COLOR_ENABLED 1 // включает отдельную настраиваемую константу цвета для альбедо текстуры
// #define NORMAL_MAP_ENABLED 1
// #define SCREEN_SPACE_REFLECTIONS_ENABLED 1
// #define METALLNESS_ENABLED 1
// #define ANISATROPIC_ENABLED 1
// #define SUBSURFACE_SCATTERING_ENABLED 1
// #define METALLIC_FROM_BASE 1
// #define AO_FROM_NORMALMAP_A 1
// #define ROUGHTNESS_MAP_ENABLED 1
// #define TRANSPARENCY_ENABLED 1
// #define ALPHA_TEST_ENABLED 1
// #define ALPHA_THRESHOLD 0.5 // must be setted if ALPHA_TEST anabled
// #define TBN_ENABLED 1
// #define PERPIXEL_LIGHT_ENABLED 1
// #define THICKNESS_MAP_ENABLED 1
 #define CONTER_LIGHT_ENABLED 1
 
 #define ADDITIONAL_AMBIENT_LIGHTS_ENABLED 1

uniform mediump sampler2D sampler; // albedo and metallic

#ifdef SHADOWS_ENABLED
	uniform mediump sampler2D sampler1; // shadow map
#endif
// #ifndef DEPTH_TO_16B
// 	uniform sampler2D sampler2; // shadow map Sqw
// #endif

#ifdef NORMAL_MAP_ENABLED
	uniform mediump sampler2D sampler2; // Normal Map and roughness
#endif
#ifdef SCREEN_SPACE_REFLECTIONS_ENABLED
	uniform mediump sampler2D sampler3; // Reflect map
#endif

#if defined(CUSTOM_COLOR_ENABLED)
	/// @color @default(1.0, 1.0, 1.0, 1.0)
	uniform mediump vec4 u_colorCustom;
#endif

/// @default(0.0)
uniform float u_metallness;
/// @default(0.3)
uniform float u_roughness;
/// @default(0.5)
uniform float u_glossIntencity;
/// @excludeFromShaderConstants
uniform float u_tanHalfFOV;
/// @excludeFromShaderConstants
uniform float u_maxAttenuation;
/// @excludeFromShaderConstants
uniform float u_lightIntencity;
/// @excludeFromShaderConstants
uniform mediump vec3 u_ambientColor;

#ifdef CONTER_LIGHT_ENABLED
	/// @excludeFromShaderConstants
	uniform mediump vec3 u_conterLightColor;
	/// @excludeFromShaderConstants
	uniform float u_conterLightIntencity;
#endif

#ifdef ADDITIONAL_AMBIENT_LIGHTS_ENABLED
	/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightColor1;
		/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightColor2;
		/// @excludeFromShaderConstants
	uniform mediump vec3 u_addLightColor3;
#endif

#if defined(MASK_3D_ENABLED)
	/// @excludeFromShaderConstants
	uniform highp vec3 u_spherePos;
	/// @excludeFromShaderConstants
	uniform highp float u_sphereRadius;
	/// @default(0.25)
	uniform highp float u_diffuseAlphaMultiple;
#endif

#ifdef ANISATROPIC_ENABLED
	/// @range(0.01, 1.0) @default(0.5)
	uniform float u_anisatropy;
#endif

#ifdef SUBSURFACE_SCATTERING_ENABLED
	/// @color @default(0.5, 0.5, 0.5, 1.0)
	uniform vec4 subsurfaceColor;
	uniform float subSurfaceSCatteringTranslucency;
#endif

/// @range(0.0, 1.0) @default(0.0)
uniform float u_fresnelFactor;

varying mediump vec4 v_color;
varying highp vec3 v_normal;
varying highp vec3 v_tangent;
varying highp vec3 v_binormal;
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
varying highp vec2 v_texcoord;
varying highp float v_maxLightDistanceInv;

#ifdef SCREEN_SPACE_REFLECTIONS_ENABLED
	varying highp vec2 v_texCoord_SSR;
	varying highp float v_fresnel_SSR;
#endif

float PHBeckmann(float ndoth, float roughness)
{
	float ta = sqrt(1.0 / (ndoth * ndoth) - 1.0);
	float val = 1.0/(roughness*roughness*pow(ndoth,4.0))*exp(-(ta*ta)/(roughness*roughness));
	return val;
}

float fresnelReflectance(in vec3 H, in vec3 L, in float F0)
{
	float base = 1.0 - dot(L, H);
	float exponential = pow(base, 5.0);
	return exponential + F0 * (1.0 - exponential);
}
float CalcSpecular(
	in vec3 N, // Bumped surface normal
	in vec3 L, // Points to light
	in vec3 V, // Points to eye
	in float roughness, // Roughness
	in float rho_s // Specular brightness
#ifdef METALLNESS_ENABLED
	,in float metallic // metallic
//	, in vec3 baseColor
#endif
	)
{
	float result = 0.0;
	float NdotL = dot(N, L);
	if(NdotL > 0.0)
	{
		vec3 h = L + V; // Unnormalized half-way vector
		vec3 H = normalize(h);
		float ndoth = dot(N, H);
		float PH = PHBeckmann(ndoth, roughness);
	#ifdef METALLNESS_ENABLED
		float F = mix(fresnelReflectance(N, L, 0.028), 1.0, metallic);
		//float F = fresnelReflectance(N, V, mix(0.028, baseColor, metallic) );
	#else
		float F = fresnelReflectance(N, L, 0.028);
	#endif
		float frSpec = max(PH * F / dot( h, h ), 0.0);
		result = NdotL * rho_s * frSpec ; // BRDF * dot(N,L) * rho_s
	}
	
	return result;
}

#if defined(ANISATROPIC_ENABLED)

	float fresnel_schlick(in float LoH, in float F0)
	{
		return F0 + (1. - F0) * pow(1. - LoH, 5.);
	}

	#if defined(USE_BECKMANN_ANISOTROPIC)
		//-- Constants ----------------------------------------------------------------
		const float m_pi        = 3.14159265359;           /* MathConstant: PI                                 */
		const float m_i_pi      = 0.31830988618;           /* MathConstant: 1 / PI                             */
		const float m_sqrt_2    = 1.41421356237;           /* MathConstant: sqrt(2)                            */
		const float m_i_sqrt_2  = 0.70710678119;           /* MathConstant: 1/sqrt(2)                          */

		const float m_eps_3f    = 0.001;            
		const float m_eps_4f    = 0.0001;            

		//-----------------------------------------------------------------------------
		//-- Tangent Space Maths (PBRT) -----------------------------------------------
		float cos_theta(const vec3 w)       {return w.z;}
		float cos_2_theta(const vec3 w)     {return w.z*w.z;}
		float sin_2_theta(const vec3 w)     {return max(0., 1. - cos_2_theta(w));}
		float sin_theta(const vec3 w)       {return sqrt(sin_2_theta(w));}
		float tan_theta(const vec3 w)       {return sin_theta(w) / cos_theta(w);}
		float cos_phi(const vec3 w)         {return (sin_theta(w) == 0.) ? 1. : clamp(w.x / sin_theta(w), -1., 1.);}
		float sin_phi(const vec3 w)         {return (sin_theta(w) == 0.) ? 0. : clamp(w.y / sin_theta(w), -1., 1.);}
		float cos_2_phi(const vec3 w)       {return cos_phi(w) * cos_phi(w);}
		float sin_2_phi(const vec3 w)       {return sin_phi(w) * sin_phi(w);} 

		//-- Beckmann Distribution ----------------------------------------------------
		float p22_beckmann_anisotropic(float x, float y, float alpha_x, float alpha_y)
		{
			float x_sqr = x*x;
			float y_sqr = y*y;
			float sigma_x = alpha_x * m_i_sqrt_2;
			float sigma_y = alpha_y * m_i_sqrt_2;
			float sigma_x_sqr = sigma_x*sigma_x;
			float sigma_y_sqr = sigma_y*sigma_y;
			return( exp( -0.5 * ((x_sqr/sigma_x_sqr) + (y_sqr/sigma_y_sqr)) ) / ( 2. * m_pi * sigma_x * sigma_y ) );
		}

		float ndf_beckmann_anisotropic(vec3 omega_h, float alpha_x, float alpha_y)
		{
			float slope_x = - (omega_h.x/omega_h.z);
			float slope_y = - (omega_h.y/omega_h.z);
			float cos_theta = cos_theta(omega_h);
			float cos_2_theta = cos_theta * cos_theta;
			float cos_4_theta = cos_2_theta * cos_2_theta;
			float beckmann_p22 = p22_beckmann_anisotropic(slope_x,slope_y,alpha_x,alpha_y);
			return(beckmann_p22 / cos_4_theta);
		}

		float lambda_beckmann_anisotropic(vec3 omega, float alpha_x, float alpha_y)
		{
			float lambda = 0.;
			float cos_phi = cos_phi(omega);
			float sin_phi = sin_phi(omega);
			float alpha_o = sqrt(cos_phi*cos_phi*alpha_x*alpha_x + sin_phi*sin_phi*alpha_y*alpha_y); 
			float nu = 1. / (alpha_o * tan_theta(omega));

			if(nu < 1.6)
				lambda = (1. - 1.259*nu + 0.396*nu*nu) / (3.535*nu + 2.181*nu*nu); 
			
			return(lambda);
		}

		float CalcSpecularAnisotropic(
			in vec3 N, // Bumped surface normal
			in vec3 L, // Points to light
			in vec3 V, // Points to eye
			in float rho_s // Specular brightness
		#ifdef METALLNESS_ENABLED
			,in float metallic // metallic
		//	, in vec3 baseColor
		#endif
			, in vec2 roughnessAnisotropicVec
			)
		{
			vec3 H = normalize(V+L);
			
			float wi_dot_wh = clamp(dot(L,H),0.,1.);
			float wg_dot_wi = clamp(cos_theta(L),0.,1.);
							
			//-- Filament BRDF parametrization
			//-- Single scattering
			//-- diffuse lambertian term + specular term
			float reflectance 	= 1.0; 	// [0.35;1]
			float alpha_x 		= roughnessAnisotropicVec.x;
			float alpha_y 		= roughnessAnisotropicVec.y;
		#ifdef METALLNESS_ENABLED
			float F0 = 0.16*reflectance*reflectance*(1.0-metallic) + /*baseColor*/ 1.0 *metallic;
		#else
			float F0 = 0.16*reflectance*reflectance;
		#endif
					
			//-- NDF + G + F
			float lambda_wo = lambda_beckmann_anisotropic(V,alpha_x,alpha_y);
			float lambda_wi = lambda_beckmann_anisotropic(L,alpha_x,alpha_y);
			float D = ndf_beckmann_anisotropic(H,alpha_x,alpha_y);
			float G = 1. / (1. + lambda_wo + lambda_wi);
			
			
			float F  = fresnel_schlick(wi_dot_wh,F0);
			
			//-- Lighting
			float specular_microfacet = (D * F * G) / ( 4. * cos_theta(L) * cos_theta(V) );
			return specular_microfacet;
		}

	#else
		#define PI 3.141592654

		float CalcSpecularAnisotropic_distribution(in float NoH, in vec3 h,
				in vec3 tangent, in vec3 binormal, in float at, in float ab) 
		{
			float ToH = dot(tangent, h);
			float BoH = dot(binormal, h);
			float a2 = at * ab;
			highp vec3 v = vec3(ab * ToH, at * BoH, a2 * NoH);
			highp float v2 = dot(v, v);
			float w2 = a2 / v2;
			return a2 * w2 * w2 * (1.0 / PI);
		}
		float CalcSpecularAnisotropic_view(in vec3 Normal, in vec3 Light, in vec3 View,
				in vec3 tangent, in vec3 binormal, in float at, in float ab) 
		{
			float NoV = dot(Normal, View);
			float NoL = dot(Normal, Light);
			float ToV = dot(tangent, View);
			float ToL = dot(tangent, Light);
			float BoV = dot(binormal, View);
			float BoL = dot(binormal, Light);
			float lambdaV = NoL * length(vec3(at * ToV, ab * BoV, NoV));
			float lambdaL = NoV * length(vec3(at * ToL, ab * BoL, NoL));
			float v = 0.5 / (lambdaV + lambdaL);
			return clamp(v, 0.0, 1.0);
		}
	#endif
#endif

void main()
{
	mediump vec4 base = texture2D(sampler, v_texcoord);
	#if defined(CUSTOM_COLOR_ENABLED)
		mediump vec3 albedo = base.rgb * v_color.rgb * u_colorCustom.rgb;
	#else
		mediump vec3 albedo = base.rgb * v_color.rgb;
	#endif
	albedo = albedo * v_color.rgb;

#if defined(MASK_3D_ENABLED)
	vec3 diff = v_pos - u_spherePos;
	float distanceSqw = dot(diff,diff);
	if (distanceSqw > (u_sphereRadius * u_sphereRadius)) {
		discard;
	}

	mediump float intencity = dot(albedo.rgb,albedo.rgb) * u_diffuseAlphaMultiple;
	mediump float distFOut = distanceSqw * (1.0 / (u_sphereRadius * u_sphereRadius));
	mediump float alpha = distFOut;

	alpha = clamp( alpha - intencity, 0.0, 1.0);
	float alphaHighlight =  clamp((alpha - v_gages.z) * v_gages.w, 0.0, 1.0);

	base.a =  1.0 - clamp((alpha - v_gages.x) * v_gages.y, 0.0, 1.0);

	albedo.rgb = mix(albedo.rgb * (1.0 + (alphaHighlight)), vec3(1.0), alphaHighlight);
#endif
	
#ifdef ALPHA_TEST_ENABLED
	if (base.a < ALPHA_THRESHOLD) {
		discard;
	}
#endif
	
	float lightDist = length(v_lightDir);
	vec3 lightDir = v_lightDir / lightDist;
	vec3 viewDir = normalize(v_viewDir);
	
	vec3 normal = normalize(v_normal);
#ifdef NORMAL_MAP_ENABLED
	mediump vec4 normalMap = texture2D(sampler2, v_texcoord);
	mediump vec3 normalLocal = vec3(normalMap.rg * 2.0 - 1.0, normalMap.b);
#endif

float lightIntencity = u_lightIntencity; // u_glossIntencity

#ifdef ROUGHTNESS_MAP_ENABLED
	#ifdef NORMAL_MAP_ENABLED
		float roughness = normalMap.a * u_roughness;
	#else
		float roughness = u_roughness;
	#endif
#else
	float roughness = u_roughness;
	#ifdef AO_FROM_NORMALMAP_A
		#ifdef NORMAL_MAP_ENABLED
			float AO = normalMap.a * 1.0;//dot(albedo,albedo);//1.0;//normalMap.a;
		#else
			float AO = 1.0;
		#endif
	#endif
#endif

	#ifdef METALLNESS_ENABLED
		mediump float metallic = base.a * u_metallness;
	#else
		mediump float metallic = u_metallness;
	#endif
#ifdef TBN_ENABLED
		vec3 tangent = normalize(v_tangent);
		vec3 binormal = normalize(v_binormal);

		mat3 TBN = mat3(tangent, binormal, normal);
		#ifdef NORMAL_MAP_ENABLED
//			#ifdef PERPIXEL_LIGHT_ENABLED
			//mat3 TBN_inv = transpose(TBN);
			normal = normalize(TBN * normalLocal);
			// tangent = normalize(cross(normal, binormal));
			// binormal = normalize(cross(normal, tangent));
//			#endif
		#endif
#endif
	float NdotL = dot(lightDir, normal);


#ifdef SCREEN_SPACE_REFLECTIONS_ENABLED
	highp float z = sqrt( normal.x*normal.x + normal.y*normal.y) + 0.001;
	vec2 normalTransformed = normal.xy / z * (1.0 - z);
	normalTransformed.x = -normalTransformed.x;
	vec2 texCoordSSR = v_texCoord_SSR.xy + normalTransformed * 2.0;
	
	mediump vec4 reflectColor = texture2D(sampler3, texCoordSSR);
	#ifdef METALLNESS_ENABLED
		vec3 reflective = reflectColor.rgb * mix( vec3(1.0), albedo * 1.0 , metallic);
	#else
		vec3 reflective = reflectColor.rgb;
	#endif
#endif

#ifdef METALLNESS_ENABLED //===============================
	vec3 specularColor = mix(v_lightColor, albedo, metallic);
#else
	vec3 specularColor = v_lightColor;
#endif //===============================

#ifdef ANISATROPIC_ENABLED
	float anisotropy = u_anisatropy;// * (normalMap.a);

	#if defined(USE_BECKMANN_ANISOTROPIC)
		mat3 TBN_inv = transpose(TBN);
		float at = max(roughness * (1.0 + anisotropy), 0.001);
		float ab = max(roughness * (1.0 - anisotropy), 0.001);
		#ifdef METALLNESS_ENABLED
			vec3 N = normal;// normalize(TBN_inv * normalLocal);//normal;//
			vec3 L = normalize(TBN_inv * lightDir);
			vec3 V = normalize(TBN_inv * viewDir);
			float specularIntencity = CalcSpecularAnisotropic(N, L, V, lightIntencity, metallic, vec2(at, ab));
		#else
			vec3 N = normalize(TBN_inv * normalLocal);//normal;//
			vec3 L = normalize(TBN_inv * lightDir);
			vec3 V = normalize(TBN_inv * viewDir);
			float specularIntencity = CalcSpecularAnisotropic(N, L, V, lightIntencity, vec2(at, ab));
		#endif
	#else
		vec3 H = normalize(viewDir + lightDir);
		float NoH = clamp(dot(normal, H), 0.0, 1.0);
		float LoH = clamp(dot(lightDir, H), 0.0, 1.0);

		float at = max(roughness * (1.0 + anisotropy), 0.001);
		float ab = max(roughness * (1.0 - anisotropy), 0.001);

		//const float reflectance = 1.0;
		#ifdef METALLNESS_ENABLED
			float F0 = 0.16 * /*reflectance*reflectance*/(1.0-metallic) + /*baseColor*/ metallic;
		#else
			float F0 = 0.16;//*reflectance*reflectance;
		#endif
		
		float specularIntencity = CalcSpecularAnisotropic_distribution(NoH, H, tangent, binormal, at, ab);
		specularIntencity *= CalcSpecularAnisotropic_view(normal, lightDir, viewDir, tangent, binormal, at, ab);
		float sMul = 1.0 - NdotL;
		specularIntencity *= lightIntencity * /*fresnel_schlick(NdotL, F0)*/ (1.0 - sMul * sMul);
	#endif
#else
	#ifdef METALLNESS_ENABLED
		float specularIntencity = CalcSpecular(normal, lightDir, viewDir, roughness, lightIntencity, metallic);
	#else
		float specularIntencity = CalcSpecular(normal, lightDir, viewDir, roughness, lightIntencity);
	#endif
#endif	
	vec3 specular = specularColor * specularIntencity;
#ifdef AO_FROM_NORMALMAP_A
	specular *= AO * AO;
#endif	
	
#ifdef SHADOWS_ENABLED
	vec3 localLightDir = v_localLightDir;
	localLightDir.z = max(localLightDir.z, 0.0);
	vec2 uv = -localLightDir.xy / (localLightDir.z * u_tanHalfFOV) * 0.5 + vec2(0.5, 0.5);
	
	highp float zLinear = (lightDist - SM_ZBIAS) * v_maxLightDistanceInv;
	#ifdef ESM_ENABLED
		highp float sDepth = UnpackDepth32(texture2D(sampler1, uv));
		float s0 = ExponentFilter(sDepth, zLinear);
	#else
		#ifdef VSM_ENABLED
			#ifdef DEPTH_TO_16B
				highp vec2 sDepth = DecodeVec2FromVec4(texture2D(sampler1, uv));
			#else
				highp vec2 sDepth = vec2(UnpackDepth32(texture2D(sampler1, uv)), UnpackDepth32(texture2D(sampler2, uv)));
			#endif
			float s0 = ChebishevFilter(sDepth, zLinear);
		#else
			float s0 = FilterPCF(sampler1, uv, zLinear);
		#endif
	#endif
#else
	const float s0 = 1.0;
#endif
	float s0m = max(s0, min(-NdotL * 255.0, 1.0));
	s0 = s0m;
	float attenuation =  clamp(s0m * NdotL, 0.0, 1.0);

	vec3 colorLit = v_lightColor  * lightIntencity;
	vec3 colorUnlit = vec3(u_maxAttenuation * u_ambientColor); //subsurfaceColor.rgb * subsurfaceColor.a + 
	vec3 diffuseColor = colorLit * attenuation;// mix(colorUnlit, colorLit, attenuation);
	//diffuseColor = mix(colorUnlit, colorLit, attenuation);

#ifdef METALLNESS_ENABLED
	albedo = mix(albedo, vec3(0.0), metallic);
#endif

#ifdef SUBSURFACE_SCATTERING_ENABLED

	#ifdef THICKNESS_MAP_ENABLED
		mediump float thickness = base.a * base.a * subsurfaceColor.a;
	#else
		mediump float thickness = subsurfaceColor.a;
	#endif
	//vec3 Fr = specular * s0;
	vec3 diffuse = diffuseColor;// v_lightColor;
	float lightIntensity = 2.0;
	diffuse *= clamp((dot(normal, lightDir) + 0.5) / 2.25, 0.0, 1.0);
	//diffuseColor = diffuse;//mix(colorLit, diffuse, attenuation);// ;
	diffuse *= clamp(subsurfaceColor.rgb + NdotL, 0.0, 1.0);
	//diffuse *= mix(1.0, NdotL, thickness);
	//float SSSintencity = max( dot(normalize(vec3(1.0, 1.0, -(normal.x + normal.y) / normal.z)), lightDir), 0.0);
	float SSSintencity = clamp( (1.0- NdotL * NdotL) * (max(s0,thickness) - attenuation) - attenuation * thickness * 0.0 , 0.0, 1.0);
	diffuse += (subsurfaceColor.rgb * albedo.rgb) * thickness * subSurfaceSCatteringTranslucency * SSSintencity * lightIntencity;
	//Fd = max(Fd , u_maxAttenuation);
	#ifdef CONTER_LIGHT_ENABLED
		float conterLightAttenuation = max( - dot(lightDir, normal)/*1.0-NdotL*/, 0.0);
		//conterLightAttenuation = conterLightAttenuation * conterLightAttenuation;
		//Fd = max( Fd, u_conterLightIntencity * u_conterLightColor * conterLightAttenuation);
		diffuse += max(u_maxAttenuation * u_ambientColor, u_conterLightIntencity * u_conterLightColor * conterLightAttenuation);
	#else
		diffuse += u_maxAttenuation * u_ambientColor;
	#endif
	diffuseColor = mix(diffuseColor, diffuse, subSurfaceSCatteringTranslucency);
	//vec3 color = Fd * albedo;// + specular * s0;// * NdotL; // * albedo
	//color *= (lightIntensity * attenuation) * v_lightColor;
#else
	#ifdef CONTER_LIGHT_ENABLED
		float conterLightAttenuation = max( - dot(lightDir, normal)/*1.0-NdotL*/, 0.0);
		//conterLightAttenuation = conterLightAttenuation * conterLightAttenuation;
		diffuseColor += u_conterLightIntencity * u_conterLightColor * conterLightAttenuation;
	#endif
	//vec3 color = albedo * diffuseColor;// + specular * s0;
#endif


#ifdef ADDITIONAL_AMBIENT_LIGHTS_ENABLED
	float NdotL_1 =  max(dot(v_addLightDir1, normal), 0.0);
	diffuseColor += NdotL_1 * v_addLightIntencity1 * u_addLightColor1;
	float NdotL_2 =  max(dot(v_addLightDir2, normal), 0.0);
	diffuseColor += NdotL_2 * v_addLightIntencity2 * u_addLightColor2;
	float NdotL_3 =  max(dot(v_addLightDir3, normal), 0.0);
	diffuseColor += NdotL_3 * v_addLightIntencity3 * u_addLightColor3;
#endif

vec3 color = albedo * max(diffuseColor, colorUnlit);


#ifdef SCREEN_SPACE_REFLECTIONS_ENABLED
	float invFresnellocal = dot(viewDir,normal);
	float fresnelLocalSpec = (1.0 - invFresnellocal + u_fresnelFactor) / (1.0 - u_fresnelFactor);
	float glossLocal = 1.0 - roughness;//mix(1.0 - roughness,1.0, metallic);//mix(pow(1.0 - roughness, 4.0), 1.0 - roughness, metallic);
	#ifdef METALLNESS_ENABLED
		fresnelLocalSpec =  mix(clamp(pow(fresnelLocalSpec, 5.0), 0.0, 1.0), 1.0, metallic);
		glossLocal = mix(glossLocal * glossLocal, glossLocal, metallic);
	#else
		fresnelLocalSpec = clamp(pow(fresnelLocalSpec, 5.0), 0.0, 1.0);
	#endif
	color.xyz = mix(color.xyz, reflective , fresnelLocalSpec * glossLocal );
#endif

color.xyz = color.xyz + specular * s0;

#ifdef TRANSPARENCY_ENABLED
#if defined(CUSTOM_COLOR_ENABLED)
		gl_FragColor = vec4(color, base.a * v_color.a * u_colorCustom.rgb);
	#else
		gl_FragColor = vec4(color, base.a * v_color.a);
	#endif
#else
	gl_FragColor = vec4(color, 1.0);
#endif
	//gl_FragColor.rgb = pow(gl_FragColor.rgb, vec3((1.0 / 2.2)));

	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + reflective;//vec3(normal);//
	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(diffuseColor); 

	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(s0);//base.a

	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(sDepth.x);
#ifdef SCREEN_SPACE_REFLECTIONS_ENABLED
	//gl_FragColor.xyz = gl_FragColor.xyz * 0.001 + vec3(fresnelLocalSpec);
#endif
}
