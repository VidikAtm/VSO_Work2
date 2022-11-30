#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_color;
varying vec2 v_texcoord;

void main()
{
	vec4 luminosity = vec4(0.3, 0.59, 0.11, 0);
	vec3 sepia = vec3(1, 0.8, 0.6);
	vec4 tex = texture2D(sampler, v_texcoord);
	float grey = dot(tex, luminosity);
	gl_FragColor = vec4(vec3(grey, grey, grey) * sepia, tex.a);
}