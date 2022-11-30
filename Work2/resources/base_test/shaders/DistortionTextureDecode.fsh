#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

uniform mediump float u_scale;

varying highp vec2 v_texcoord;
varying vec4  v_color;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord);
	vec4 mask = texture2D(sampler1, v_texcoord);
	vec3 color = vec3(tex.rg, 0);
	float scale = u_scale * v_color.a * mask.r;
	if (color.r > 0.5)
		gl_FragColor.rg = color.rb * scale;
	else
		gl_FragColor.rg = color.br * scale;
	if (color.g > 0.5)
		gl_FragColor.ba = color.gb * scale;
	else
		gl_FragColor.ba = color.bg * scale;
}