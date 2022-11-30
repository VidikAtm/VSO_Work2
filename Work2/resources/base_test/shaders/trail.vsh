#ifdef GL_ES
precision highp float;
#endif

attribute vec2 a_vertex;
attribute vec2 a_normal;
attribute vec3 a_weights;
attribute vec4 a_color;

uniform mat4 u_coreModelViewProj;
uniform vec4 u_colorStart;
uniform vec4 u_colorEnd;
uniform vec2 u_time; // x = current_time, y = 1.0 / timeFade
uniform float u_texCoordlerp;
uniform float u_constAlphaFactor;
uniform mediump vec2  u_texscaleU;

varying vec4 v_color;
varying vec2 v_texcoord;


void main()
{
	float intencity = 1.0 - clamp((u_time.x - a_weights.x) * u_time.y, 0.0 , 1.0);
	//v_color = vec4(mix(u_colorEnd.xyz, u_colorStart.xyz, intencity), a_color.w * intencity);
	v_color = vec4(mix(u_colorEnd.xyz, u_colorStart.xyz, intencity), intencity * (1.0 - u_constAlphaFactor) + u_constAlphaFactor) * a_color;
	
	v_texcoord = vec2(u_texscaleU.x + (intencity * ( 1.0 - u_texCoordlerp) + a_weights.y * u_texCoordlerp) * u_texscaleU.y, a_weights.z );
	vec2 position = a_vertex.xy + a_normal * (1.0 - intencity);
	gl_Position = u_coreModelViewProj * vec4(position, 0.0, 1.0);
}