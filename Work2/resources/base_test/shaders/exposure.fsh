#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

varying vec2 v_texcoord;
varying vec4 v_color;

void main()
{

	// Старый "цветовой" хак:
	// если умножить цвета на 2, то когда в вершинных цветах 50% серого - 
	// видим исходный цвет текстуры, а если белый - тогда цвета аддитивно подсвечиваются

	vec4 color = texture2D(sampler, v_texcoord) * v_color * 2.;
	gl_FragColor = vec4(color.r, color.g, color.b, color.a * .5);
}
