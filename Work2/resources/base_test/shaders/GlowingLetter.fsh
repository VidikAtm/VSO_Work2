#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
varying vec4 v_color;
varying vec3 v_texcoord;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord.xy);
	gl_FragColor.rgb = v_color.rgb * (v_color.a * tex.g + v_texcoord.z * tex.r);
	gl_FragColor.a = 1.0;
}