#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;

/// @range(0.0,1.0) @default(0.5) @comment("1D параметр")
uniform mediump float u_vec1;
/// @default(0.5,0.3) @comment("2D параметр")
uniform mediump vec2  u_vec2;
/// @default(1.0,2.0,3.0) @comment('3D параметр')
uniform mediump vec3  u_vec3;
/// @color @default(1,1,1,1) @comment('4D параметр как color')
uniform    vec4  u_vec4;

varying highp vec2 v_texcoord;

void main()
{
	vec4 tex1 = texture2D(sampler, v_texcoord);
	vec4 tex2 = texture2D(sampler1, v_texcoord + u_vec2);
	vec4 tex3 = texture2D(sampler2, v_texcoord + u_vec3.xy);
	
	gl_FragColor.rgb = mix(mix(tex1.rgb, tex2.rgb, tex2.a * u_vec1), u_vec4.rgb * tex3.rgb, tex3.a * u_vec4.a);
	gl_FragColor.a = tex1.a;
}