#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

/// @color
uniform vec4 u_replaceGreen;
/// @color
uniform vec4 u_replaceBlue;

varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

void main()
{
	vec4 textTex = texture2D(sampler, v_texcoord);
	vec4 grad1Tex = texture2D(sampler1, v_texcoord1);
	vec4 grad2Tex = texture2D(sampler2, v_texcoord2);
	
	vec3 color = mix(grad1Tex.rgb, grad2Tex.rgb, textTex.r);
	color = mix(color, u_replaceGreen.rgb, textTex.g * u_replaceGreen.a);
	color = mix(color, u_replaceBlue.rgb, textTex.b * u_replaceBlue.a);
	
	gl_FragColor.rgb = v_color.rgb * color;
	gl_FragColor.a = v_color.a * textTex.a;
}