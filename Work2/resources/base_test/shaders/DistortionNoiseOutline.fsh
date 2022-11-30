#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

/// @color
uniform vec4 u_outlineColor;

/// @color @default(0.5, 0.0, 0.0, 1.0)
uniform vec4 u_darkColor;

/// @range(0, 1) @default(0.1)
uniform float u_distortion;

/// @default(0.5, 0.5)
uniform vec2 u_distortionOffset;

varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

void main()
{
	vec4 distortionTex = texture2D(sampler1, v_texcoord1);
	vec4 noiseTex = texture2D(sampler2, v_texcoord2);
	vec2 texcoord = v_texcoord + u_distortion * (distortionTex.xx - u_distortionOffset);
	vec4 mainTex = texture2D(sampler, texcoord);
	
	mainTex.rgb *= mix(v_color.rgb, u_darkColor.rgb, noiseTex.r);
	mainTex *= mix(1.0, u_darkColor.a, noiseTex.r);
	
	mainTex *= ((distortionTex.r + v_color.a - 1.0) * 5.0 * (1.0 - v_color.a) + v_color.a);
	
	float outline = 4.0 * mainTex.a * (1.0 - mainTex.a);
	outline = max(outline, step(mainTex.a, 0.5));
	mainTex.rgb *= mix(vec3(1.0, 1.0, 1.0), u_outlineColor.rgb, outline);
	
	gl_FragColor = mainTex;
}