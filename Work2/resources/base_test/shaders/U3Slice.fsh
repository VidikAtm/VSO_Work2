#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

uniform highp float u_start;
uniform highp vec3 u_line1;
uniform highp vec3 u_line2;
uniform highp vec3 u_line3;

varying highp vec2 v_texcoord;
varying vec4 v_color;

void main()
{
	float u;
	if (v_texcoord.x < u_start)
		u = 0.0;
	else if (v_texcoord.x < u_line1.x)
		u = u_line1.y * v_texcoord.x + u_line1.z;
	else if (v_texcoord.x < u_line2.x)
		u = u_line2.y * v_texcoord.x + u_line2.z;
	else if (v_texcoord.x < u_line3.x)
		u = u_line3.y * v_texcoord.x + u_line3.z;
	else
		u = 1.0;
	
	gl_FragColor = texture2D(sampler, vec2(u, v_texcoord.y)) * v_color;
}