#ifdef GL_ES
	precision highp float;
#endif

uniform mediump sampler2D sampler;
uniform highp float u_width;       // толщина обводки
uniform mediump vec4 u_outlineColor;  // Цвет обводки (с альфой)
uniform mediump float u_filling;   // заливка центральной части

varying mediump vec4 v_color;
varying highp vec2 v_texcoord;

void main(void) {
	vec4 color = texture2D(sampler, v_texcoord);
	float s0 = 0.0;
	
	// original method
	float s = u_width;
	float s1 = s * 1.414;
	float s2 = s;
	float sum = 0.0;
	
	sum += texture2D(sampler, v_texcoord + vec2(-s1, -s1)).a;
	sum += texture2D(sampler, v_texcoord + vec2(-s2, s0)).a;
	sum += texture2D(sampler, v_texcoord + vec2(-s1, +s1)).a;
	
	sum += texture2D(sampler, v_texcoord + vec2(s0, -s2)).a;
	sum += texture2D(sampler, v_texcoord + vec2(s0, +s2)).a;
	
	sum += texture2D(sampler, v_texcoord + vec2(+s1, -s1)).a;
	sum += texture2D(sampler, v_texcoord + vec2(+s2, s0)).a;
	sum += texture2D(sampler, v_texcoord + vec2(+s1, +s1)).a;
	
	sum -= 1.0;
	sum = clamp(sum, 0.0, 1.0);
	
	sum *= clamp(1.0 - color.a * u_filling, 0.0, 1.0); // Вырезаем здание из середины.
	// end of original
	
	// added squares method
	float d = u_width * 0.5;
	float d0 = 0.0;
	float d1 = s * 1.414;
	float d2 = s;
	float dum = 0.0;
	
	dum += abs(texture2D(sampler, v_texcoord + vec2(-d1, -d1)).a - texture2D(sampler, v_texcoord + vec2(d1, d1)).a);
	dum += abs(texture2D(sampler, v_texcoord + vec2(-d1, d1)).a - texture2D(sampler, v_texcoord + vec2(d1, -d1)).a);
	
	dum += abs(texture2D(sampler, v_texcoord + vec2(d2, d0)).a - texture2D(sampler, v_texcoord + vec2(-d2, d0)).a);
	dum += abs(texture2D(sampler, v_texcoord + vec2(d0, d2)).a - texture2D(sampler, v_texcoord + vec2(d0, -d2)).a);
	
	dum = clamp(dum, 0.0, 1.0);
	// end added squares
	
	sum = clamp(sum + dum, 0.0, 1.0);
	
	vec4 result = vec4(u_outlineColor.rgb, u_outlineColor.a * sum);
	gl_FragColor = result;
}
