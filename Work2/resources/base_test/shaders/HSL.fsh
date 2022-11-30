#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	
	vec4 tex = texture2D(sampler, v_texcoord);
	
	// Цвет вертекса используем как HSL (не путать с HSB (HSV)!)
	// R - Hue, G - Saturation, L - Lightness
	// Вот тут описана разница: https://en.wikipedia.org/wiki/HSL_and_HSV
	
	// Считаем "чистый" RGB поканально:
	
	float x = v_color.r * 6.0;

	float cr1 = clamp(x-4.0,0.0,1.0);
	float cr2 = clamp(2.0-x,0.0,1.0);
	float cg = clamp(2.0-abs(x-2.0),0.0,1.0);
	float cb = clamp(2.0-abs(x-4.0),0.0,1.0);
    
	// Считываем Saturation
	
    vec3 pure_color = v_color.g * (vec3((cr1 + cr2), (cg), (cb)));
    
	// Связываем Lightness и Saturation
	
    float l = mix(v_color.b, 2. * (v_color.b - .5),v_color.g);
    
	// Та-даа
	
	gl_FragColor = vec4(tex.rgb * clamp(pure_color + l, 0., 1.), tex.a * v_color.a);
	
}