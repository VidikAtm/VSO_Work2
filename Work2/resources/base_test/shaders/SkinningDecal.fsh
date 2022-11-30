#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

uniform vec4 u_color;
uniform float u_amount;

varying vec2 v_texcoord;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord);
	vec4 tex1 = texture2D(sampler1, v_texcoord);
	gl_FragColor.rgb = mix(tex.rgb, tex1.rgb, u_amount) * u_color.rgb;
	gl_FragColor.a = tex.a * u_color.a;
}