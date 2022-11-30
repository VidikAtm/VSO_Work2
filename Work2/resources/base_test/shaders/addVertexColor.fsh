#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

varying vec2 v_texcoord;

varying vec4 v_color;

void main()
{
	vec4 baseColor = texture2D(sampler, v_texcoord);

	// Тупо прибавляем вершинный цвет, а не умножаем на него,
	// но только цвет, а не альфу. Её оставляем умножаться.

	gl_FragColor = vec4(baseColor.rgb + v_color.rgb, baseColor.a * v_color.a);
}
