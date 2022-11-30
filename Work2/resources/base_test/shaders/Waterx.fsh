// Шейдер воды для Township и Zoo Mania
#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform mediump vec4 u_lightParams;

varying vec4  v_color;
varying highp vec2 v_texcoord0;
varying highp vec2 v_texcoord1;

varying mediump float v_x;
varying mediump float v_y;

void main()
{
    // Блик
    float hlight = exp(-v_x * v_x * 8.0 - v_y * v_y * 1.0) * u_lightParams.w;

    // Выборки из текстуры
    vec4 col0 = texture2D(sampler, v_texcoord0);
    vec4 col1 = texture2D(sampler, v_texcoord1);

    // Перемножаем значения и получаем общий цвет
    vec4 col = col0 * col1;

    // Вычисляем финальный цвет пикселя
    vec4 pix;
    pix.rgb = v_color.rgb
              + col.r * u_lightParams.x          // засветы на волнах (R)
              + col.g * u_lightParams.y          // более крупные засветы на волнах (G)
              - (1.0 - col.a) * u_lightParams.z  // затемнение для имитации объема (A)
              + (col.r + 0.15) * hlight          // блик от Солнца
              //- col.b                          // затенение для придания объема (B)
    ;

    gl_FragColor.rgb = pix.rgb;
    gl_FragColor.a = 1.0;
}