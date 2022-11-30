#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_color;
varying vec2 v_texcoord;
varying float v_clipPlainDistance;

void main()
{
	if (v_clipPlainDistance < 0.0){
		discard;
	}
	gl_FragColor = u_color * texture2D(sampler, v_texcoord);
}