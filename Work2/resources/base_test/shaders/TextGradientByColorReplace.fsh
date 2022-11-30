#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

/// @color
uniform vec4 u_replaceTarget;

uniform float u_distanceThreshold;


varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	vec4 textTex = texture2D(sampler, v_texcoord);
	vec4 grad1Tex = texture2D(sampler1, v_texcoord1);
	
	float t = max(0.0, (u_distanceThreshold - distance(textTex.rgb, u_replaceTarget.rgb)) / u_distanceThreshold);
	vec3 color = mix(textTex.rgb, grad1Tex.rgb, t);
	
	gl_FragColor.rgb = v_color.rgb * color;
	gl_FragColor.a = v_color.a * textTex.a;
}