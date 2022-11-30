#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

/// @default(0.33)
uniform float _amp;
/// @default(0.33)
uniform float _amp1;
/// @default(0.33)
uniform float _amp2;

varying vec4 v_color;
varying vec2 v_texcoord;
varying vec2 v_texcoord1;
varying vec2 v_texcoord2;

void main()
{
	vec4 color = texture2D(sampler, v_texcoord);	
	color.rgb *= _amp;
	color.rgb += _amp1 * texture2D(sampler1, v_texcoord1).rgb;
	color.rgb += _amp2 * texture2D(sampler2, v_texcoord2).rgb;
	gl_FragColor = v_color * color;
}