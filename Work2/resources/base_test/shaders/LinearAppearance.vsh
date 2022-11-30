// https://www.khronos.org/registry/OpenGL/specs/es/2.0/GLSL_ES_Specification_1.00.pdf

attribute vec4 a_vertex;
attribute vec2 a_texcoord;
attribute mediump vec4 a_color;

uniform mat4 u_coreModelViewProj;
uniform vec4 u_uvscale_t0;
uniform float u_border;
uniform float u_rotation;

varying vec2  v_texcoord;
varying mediump vec4 v_color;
varying float v_alphaGradient;

const float PI2 = 6.28318530718;

void main()
{
	v_texcoord = a_texcoord;
	v_color = a_color;

    float angle = u_rotation * PI2;
    v_alphaGradient = dot(a_texcoord * u_uvscale_t0.xy + u_uvscale_t0.zw - 0.5, vec2(cos(angle),sin(angle))) * (1.0-u_border) + 0.5;
	gl_Position = u_coreModelViewProj * a_vertex;
}
