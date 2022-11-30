attribute vec2 a_vertex;
attribute mediump vec4 a_texcoord;
attribute mediump float a_texcoord1;

uniform mat4 u_coreModelViewProj;

varying mediump vec3 v_highlight;
varying vec2 v_texcoord;

void main()
{
	v_texcoord = a_texcoord.xy;
	v_highlight.xy = a_texcoord.zw;
	v_highlight.z = a_texcoord1;
	
	gl_Position = a_vertex.x * u_coreModelViewProj[0] + a_vertex.y * u_coreModelViewProj[1] + u_coreModelViewProj[3];
}
