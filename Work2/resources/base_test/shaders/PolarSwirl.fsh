#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

varying vec2 v_texcoord;

// Спиральное закручивание текстуры.
varying vec4 v_rotation;

// Тайлинг текстуры шума
uniform vec2 u_tile;

// Выбор канала текстуры (красный, зеленый, синий)
uniform float R;
uniform float G;
uniform float B;

// Скорость анимации текстуры
uniform float u_speed;


// Основной цвет
/// @color
uniform mediump vec4 color;

// Анимация текстуры через вершинный цвет.
// Красный канал - анимация смещения. Обычно выставляется линейный график от 0 до 1, в течение жизни эффекта.
// Зеленый канал - размер тайлинга по Х. Можно задавать рандомные значения для каждой частицы, в пределах 0.7 - 1.0.
// Синий канал - смещение текстуры. Тут можно задать дополнительный рандом начального смещения текстуры. Значения от 0 до 1.
// Альфа канал - прозрачность текстуры.

varying vec4 v_color;

void main()
{
	float dott = distance(v_texcoord , vec2(0.5, 0.5));
	
	vec2 mulee = v_texcoord - 0.5;
	vec2 rotator = mulee * mat2(v_rotation.x , v_rotation.y, v_rotation.z, v_rotation.w) + 0.5;
	vec2 lerpResult = mix(rotator, v_texcoord, sqrt(dott));
	float fratan = atan((lerpResult.y - 0.5), (lerpResult.x - 0.5)) * 0.159;
	float offset = v_color.r * u_speed;
	
	float UU = (dott * u_tile.x) * v_color.g;
	
	vec2 finalUV = fract(vec2(UU + offset, fratan * u_tile.y ) + v_color.b);
	
	float ring = distance(dott, 0.270);
	
	float ringglow = (1.0 - ring) * 4.650;
	
	float ringEdges = clamp((ringglow - 3.550), 0.0, 1.0);
	
	vec4 tex = texture2D(sampler, finalUV);
	
	float red = tex.r * R;
	float green = tex.g * G;
	float blue = tex.b * B;
	
	gl_FragColor.rgb =  color.rgb;
	gl_FragColor.a = (((red + green + blue)) * v_color.a) * ringEdges;
}
