#ifdef GL_ES
	precision highp float;
#endif

attribute highp vec4 a_vertex;
attribute highp vec2 a_texcoord;
attribute mediump vec4 a_color;

uniform highp mat4 u_modelview;

uniform highp float texelWidthOffset;
uniform highp float texelHeightOffset;

varying mediump vec2 v_texcoord;
varying mediump float offsetW;
varying mediump float offsetH;

void main()
{
	v_texcoord = a_texcoord.xy;
	offsetW = texelWidthOffset;
	offsetH = texelHeightOffset;

	gl_Position = u_modelview * a_vertex;
}
