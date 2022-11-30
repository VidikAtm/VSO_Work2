#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

/// @color
uniform vec4 u_colorGTarget;
/// @color
uniform vec4 u_color1Target;
/// @color
uniform vec4 u_color2Target;
/// @color
uniform vec4 u_color3Target;
/// @color
uniform vec4 u_color1;
/// @color
uniform vec4 u_color2;
/// @color
uniform vec4 u_color3;

uniform float u_distanceThreshold;


varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

float calculateBlendCoeff(vec3 color, vec3 targetColor)
{
	float proj = dot(color, targetColor);
	float targetColorNormSqr = dot(targetColor, targetColor);
	return sqrt(proj) * max(0.0, (u_distanceThreshold - distance(color, targetColor * (proj / targetColorNormSqr))) / u_distanceThreshold);
}

void main()
{
	vec4 textTex = texture2D(sampler, v_texcoord);
	vec4 grad1Tex = texture2D(sampler1, v_texcoord1);
	vec4 grad2Tex = texture2D(sampler2, v_texcoord2);
	
	vec3 color = grad1Tex.rgb; 
	color = mix(color, u_color3.rgb, calculateBlendCoeff(textTex.rgb, u_color3Target.rgb) * u_color3.a);
	color = mix(color, u_color1.rgb, calculateBlendCoeff(textTex.rgb, u_color1Target.rgb) * u_color1.a);
	color = mix(color, u_color2.rgb, calculateBlendCoeff(textTex.rgb, u_color2Target.rgb) * u_color2.a);
	color = mix(color, grad2Tex.rgb, calculateBlendCoeff(textTex.rgb, u_colorGTarget.rgb));
	
	//vec3 color;
	//color.r = calculateBlendCoeff(textTex.rgb, u_color1Target.rgb);
	//color.g = calculateBlendCoeff(textTex.rgb, u_color2Target.rgb);
	//color.b = calculateBlendCoeff(textTex.rgb, u_color3Target.rgb);
	
	gl_FragColor.rgb = v_color.rgb * color;
	gl_FragColor.a = v_color.a * textTex.a;
}