#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform float u_offs;
uniform vec2 u_coeff;

/// @color
uniform vec4 u_clr;
/// @color
uniform vec4 u_clrBody;

varying vec2 v_texcoord;

void main()
{
	vec4 n0 = texture2D(sampler, v_texcoord);
	vec4 n1 = texture2D(sampler, v_texcoord + vec2(u_offs, 0.0));
	vec4 n2 = texture2D(sampler, v_texcoord + vec2(-u_offs, 0.0));
	vec4 n3 = texture2D(sampler, v_texcoord + vec2(0.0, u_offs));
	vec4 n4 = texture2D(sampler, v_texcoord + vec2(0.0, -u_offs));
	vec4 n5 = texture2D(sampler, v_texcoord + vec2(-u_offs, -u_offs));
	vec4 n6 = texture2D(sampler, v_texcoord + vec2(u_offs, -u_offs));
	vec4 n7 = texture2D(sampler, v_texcoord + vec2(u_offs, u_offs));
	vec4 n8 = texture2D(sampler, v_texcoord + vec2(-u_offs, u_offs));
	
	float v = min(abs(n0.b - n1.b), 0.125) + 
			  min(abs(n0.b - n2.b), 0.125) + 
			  min(abs(n0.b - n3.b), 0.125) + 
			  min(abs(n0.b - n4.b), 0.125) + 
			  min(abs(n0.b - n5.b), 0.125) + 
			  min(abs(n0.b - n6.b), 0.125) + 
			  min(abs(n0.b - n7.b), 0.125) + 
			  min(abs(n0.b - n8.b), 0.125);
			  
	gl_FragColor.rgb = u_clr.rgb * v * u_coeff.x;
	
	if (n0.b > 0.05)
		gl_FragColor.rgb += u_clrBody.rgb;
	
	gl_FragColor.a = u_clr.a;
}