#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;
uniform sampler2D sampler3;

uniform mediump float u_coeff;
uniform mediump float u_coeff1;
uniform mediump float u_coeff2;
uniform mediump float u_coeff3;

varying highp vec4 v_texcoord01;
varying highp vec4 v_texcoord23;
varying highp vec2 v_texcoord4;

void main()
{
	vec4 tex0 = texture2D(sampler, v_texcoord01.xy);
	vec4 tex1 = texture2D(sampler1, v_texcoord01.zw);
	vec4 tex2 = texture2D(sampler2, v_texcoord23.xy);
	vec4 tex3 = texture2D(sampler3, v_texcoord23.zw);
	
	gl_FragColor.rgb = mix(tex0.rgb, vec3(v_texcoord4.xy, 0), u_coeff);
	gl_FragColor.r += u_coeff1 * tex1.r * tex1.a;
	gl_FragColor.g += u_coeff2 * tex2.r * tex2.a;
	gl_FragColor.b += u_coeff3 * tex3.r * tex3.a;
	gl_FragColor.a = tex0.a;
}