#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform vec3 u_sample0;
uniform vec3 u_sample1;
uniform vec3 u_sample2;
uniform vec3 u_sample3;
uniform vec3 u_sample4;
uniform vec3 u_sample5;
uniform vec3 u_sample6;
uniform vec3 u_sample7;
uniform vec3 u_sample8;
uniform vec3 u_sample9;
uniform vec3 u_sample10;
uniform vec3 u_sample11;
uniform vec3 u_sample12;
uniform vec3 u_sample13;
uniform vec3 u_sample14;
uniform vec3 u_sample15;
uniform vec3 u_sample16;
uniform vec3 u_sample17;
uniform vec3 u_sample18;
uniform vec3 u_sample19;
uniform vec3 u_sample20;
uniform vec3 u_sample21;
uniform vec3 u_sample22;
uniform vec3 u_sample23;
uniform vec3 u_sample24;


varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	highp vec4 color = texture2D(sampler, v_texcoord + u_sample0.yz) * u_sample0.x;
	color += texture2D(sampler, v_texcoord + u_sample1.yz) * u_sample1.x;
	color += texture2D(sampler, v_texcoord + u_sample2.yz) * u_sample2.x;
	color += texture2D(sampler, v_texcoord + u_sample3.yz) * u_sample3.x;
	color += texture2D(sampler, v_texcoord + u_sample4.yz) * u_sample4.x;
	color += texture2D(sampler, v_texcoord + u_sample5.yz) * u_sample5.x;
	color += texture2D(sampler, v_texcoord + u_sample6.yz) * u_sample6.x;
	color += texture2D(sampler, v_texcoord + u_sample7.yz) * u_sample7.x;
	color += texture2D(sampler, v_texcoord + u_sample8.yz) * u_sample8.x;
	color += texture2D(sampler, v_texcoord + u_sample9.yz) * u_sample9.x;
	color += texture2D(sampler, v_texcoord + u_sample10.yz) * u_sample10.x;
	color += texture2D(sampler, v_texcoord + u_sample11.yz) * u_sample11.x;
	color += texture2D(sampler, v_texcoord + u_sample12.yz) * u_sample12.x;
	color += texture2D(sampler, v_texcoord + u_sample13.yz) * u_sample13.x;
	color += texture2D(sampler, v_texcoord + u_sample14.yz) * u_sample14.x;
	color += texture2D(sampler, v_texcoord + u_sample15.yz) * u_sample15.x;
	color += texture2D(sampler, v_texcoord + u_sample16.yz) * u_sample16.x;
	color += texture2D(sampler, v_texcoord + u_sample17.yz) * u_sample17.x;
	color += texture2D(sampler, v_texcoord + u_sample18.yz) * u_sample18.x;
	color += texture2D(sampler, v_texcoord + u_sample19.yz) * u_sample19.x;
	color += texture2D(sampler, v_texcoord + u_sample20.yz) * u_sample20.x;
	color += texture2D(sampler, v_texcoord + u_sample21.yz) * u_sample21.x;
	color += texture2D(sampler, v_texcoord + u_sample22.yz) * u_sample22.x;
	color += texture2D(sampler, v_texcoord + u_sample23.yz) * u_sample23.x;
	color += texture2D(sampler, v_texcoord + u_sample24.yz) * u_sample24.x;

	gl_FragColor = v_color * color;
}