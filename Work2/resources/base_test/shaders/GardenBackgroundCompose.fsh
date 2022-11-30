#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler; // Composed Texture
uniform sampler2D sampler1; // Background

uniform highp float u_shadow;
uniform highp float u_lightSpot;
uniform highp float u_lightRay;
uniform vec4 u_lightColor;

varying highp vec2 v_texcoord;

void main()
{
	vec4 light = texture2D(sampler, v_texcoord);
	vec4 back = texture2D(sampler1, v_texcoord);
	
	float grayscale = (back.r + back.g + back.b) / 3.0;
	float lightness = min(1.0, pow(grayscale, 3.0) * 20.0);
	
	float shadowCoeff = 1.0 - u_shadow * light.r;
	vec3 finalCoeff = vec3(shadowCoeff, shadowCoeff, shadowCoeff);
	finalCoeff += (light.g * u_lightSpot + light.b * u_lightRay) * lightness * u_lightColor.rgb; // Form light coeff
	gl_FragColor.rgb = back.rgb * finalCoeff + light.b * u_lightColor.rgb * u_lightRay; // Add streaks
	gl_FragColor.a = back.a;
}