precision highp float;

//uniform samplerCube sampler;
//uniform mediump sampler2D sampler; // Reflect map
uniform mediump sampler2D sampler1; // Reflect map

/// @default(0.1)
uniform float u_roughness;
/// @default(0.5)
uniform float u_glossIntencity;
/// @default(0.5)
uniform float u_reflection;
/// @range(0.0, 1.0) @default(0.0)
uniform float u_fresnelFactor;

varying highp vec2 v_texcoord;
varying vec2 v_texCoord_SSR;
varying vec3 v_normal;
varying vec3 v_viewDir;
varying vec3 v_lightDir;
varying vec3 v_lightColor;

float PHBeckmann(float ndoth, float m)
{
	float ta = sqrt(1.0 / (ndoth * ndoth) - 1.0);
	//float alpha = acos(ndoth);
	//float ta = tan(alpha);
	float val = 1.0/(m*m*pow(ndoth,4.0))*exp(-(ta*ta)/(m*m));
	return val;
}

float fresnelReflectance(vec3 H, vec3 V, float F0)
{
	float base = 1.0 - dot(V, H);
	float exponential = pow(base, 5.0);
	return exponential + F0 * (1.0 - exponential);
}

float GlassSpecular(
	vec3 N, // Bumped surface normal
	vec3 L, // Points to light
	vec3 V, // Points to eye
	float m, // Roughness
	float rho_s // Specular brightness
	)
{
	float result = 0.0;
	float ndotl = dot(N, L);
	if(ndotl > 0.0)
	{
		vec3 h = L + V; // Unnormalized half-way vector
		vec3 H = normalize(h);
		float ndoth = dot(N, H);
		float PH = PHBeckmann(ndoth, m);
		float F = fresnelReflectance(H, V, 0.28);
		float frSpec = max(PH * F / dot( h, h ), 0.0);
		result = ndotl * rho_s * frSpec; // BRDF * dot(N,L) * rho_s
	}
	
	return result;
}

void main()
{
	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);
	
	vec3 lightDir = normalize(v_lightDir);
	vec3 viewDir = normalize(v_viewDir);
	//vec3 viewDir = vec3(0.0, 0.0, 1.0);
	vec3 normal = normalize(v_normal);
	float ndotl = max(0.0, dot(lightDir, normal));
	float vdotn = max(0.0, dot(normal, viewDir));
	
	vec3 reflection = 2.0 * vdotn * normal - viewDir;
	
	//vec3 reflectionColor = texture2D(sampler, v_texCoord_SSR).rgb * 0.01;//
	//vec3 reflectionColor = vec3(1.0);//vec3(1.0);//textureCube(sampler, reflection).xyz;
	float lightIntencity = GlassSpecular(normal, lightDir, viewDir, u_roughness, u_glossIntencity);
	vec3 specularColor = v_lightColor * lightIntencity;
	//gl_FragColor.xyz = mix(vec3(1.0, 1.0, 1.0), texture2D(sampler1, v_texcoord).xyz, max(0.0, ndotl)); // ambient occlusion

	
	float invFresnellocal = dot(viewDir,normal);
	float fresnelLocalSpec = (1.0 - invFresnellocal + u_fresnelFactor) / (1.0 - u_fresnelFactor);
	fresnelLocalSpec =  clamp(pow(fresnelLocalSpec, 5.0), 0.0, 1.0);
	// gl_FragColor.xyz = mix(gl_FragColor.xyz, reflectionColor , fresnelLocalSpec);
	mediump vec4 reflectColor = texture2D(sampler1, v_texCoord_SSR);//  * 0.0001 + uv
	vec3 reflectionColor = reflectColor.rgb * (1.0 - fresnelLocalSpec * fresnelLocalSpec * 0.5); //+ dot(albedo, albedo)

	gl_FragColor.xyz = reflectionColor + specularColor;
	

	gl_FragColor.a = lightIntencity + 1.0 - vdotn + fresnelLocalSpec ;
}
