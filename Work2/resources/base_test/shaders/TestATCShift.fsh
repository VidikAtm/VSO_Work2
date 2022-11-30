#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;
uniform sampler2D sampler2;
uniform sampler2D sampler3;

uniform vec4 u_coeff0;
uniform vec4 u_coeff1;
uniform vec4 u_coeff2;
uniform vec4 u_coeff3;

varying vec2 v_tc0;
varying vec2 v_tc1;
varying vec2 v_tc2;
varying vec2 v_tc3;

void main()
{
	vec4 tex0 = u_coeff0 * texture2D(sampler, v_tc0);
	vec4 tex1 = u_coeff1 * texture2D(sampler1, v_tc1);
	vec4 tex2 = u_coeff2 * texture2D(sampler2, v_tc2);
	vec4 tex3 = u_coeff3 * texture2D(sampler3, v_tc3);

	gl_FragColor = tex0 + tex1 + tex2 + tex3;
}
