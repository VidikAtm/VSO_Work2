#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

/// @default(0) @excludeFromShaderConstants
uniform float u_gray;

varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	vec4 luminosity = vec4(0.3, 0.59, 0.11, 0);
	
	vec4 tex = texture2D(sampler, v_texcoord);
	tex *= v_color;
	
	float grey = dot(tex, luminosity);
	gl_FragColor = vec4(mix(vec3(grey, grey, grey), tex.rgb, u_gray), tex.a);
}