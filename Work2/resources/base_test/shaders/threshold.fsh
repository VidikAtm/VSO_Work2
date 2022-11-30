#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform vec3 u_grey;
uniform float u_threshold;

varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	vec4 tex = v_color * texture2D(sampler, v_texcoord);
	if (dot(tex.rgb, u_grey) > u_threshold)
		gl_FragColor = tex;
	else
		gl_FragColor = vec4(0, 0, 0, tex.a);
}