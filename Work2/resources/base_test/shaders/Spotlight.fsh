#ifdef GL_ES
	precision highp float;
#endif

uniform float u_border;
uniform float u_size;

varying vec4 v_color;

varying vec2 v_texcoord;

void main()
{
	float t = length(2.0 * v_texcoord - vec2(1.0,1.0));
	t = (t - u_border) / u_size;
	
	gl_FragColor.rgb = v_color.rgb;
	gl_FragColor.a = v_color.a * clamp(t, 0.0, 1.0);
}