#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

varying vec2 v_tc0;
varying float v_alpha;

void main()
{
	gl_FragColor = texture2D(sampler, v_tc0);
	gl_FragColor.a = gl_FragColor.a * v_alpha;
}
