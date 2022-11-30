#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

uniform mediump float u_vec1;
uniform mediump float u_vec2;
uniform mediump vec3  u_vec3new;
uniform    vec4  u_vec4;

varying highp vec2 v_texcoord;

void main()
{
	vec4 tex1 = texture2D(sampler, v_texcoord);
	vec4 tex2 = texture2D(sampler1, v_texcoord + u_vec3new.xy);
	
	gl_FragColor.rgb = mix(tex1.rgb, u_vec1 * tex2.rgb, tex2.a);
	gl_FragColor.a = tex1.a * u_vec2;
}