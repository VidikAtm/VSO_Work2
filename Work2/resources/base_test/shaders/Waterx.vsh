attribute vec4 a_vertex;
attribute vec4 a_color;
attribute vec2 a_texcoord;

uniform mat4 u_coreModelViewProj;
/// @excludeFromShaderConstants
uniform float u_time;
uniform vec2 u_uvScale;

varying vec4 v_color;
varying vec2 v_texcoord0;
varying vec2 v_texcoord1;
varying mediump float v_x;
varying mediump float v_y;

void main()
{
	v_color = a_color;
	
	float t = u_time * 0.01;  // Общий коэффициент скорости
    
    // генерируем текстурные координаты и анимируем их
	v_texcoord0 = a_vertex.xy * u_uvScale.x;// 0.004;
	v_texcoord1 = a_vertex.xy * u_uvScale.y;// 0.015;
	
	v_texcoord0.y -= t;
    v_texcoord1.y += t;
    
    vec4 vertex = a_vertex;
    
    // волнение
    
    //float w_t0 = v_texcoord0.x * 80.0 + v_texcoord0.y * 40.0;
    //float w_t1 = v_texcoord0.x * 40.0 + v_texcoord0.y * 20.0 - t * 143.5;
    //float yoff = sin(w_t0) * sin(w_t1) * 10.0; // Волнение
    //vertex.y += yoff;
    
	gl_Position = u_coreModelViewProj * vertex;
	
	v_x = gl_Position.x; // Для блика - позиция относительно экрана
	v_y = gl_Position.y - 0.5;
}