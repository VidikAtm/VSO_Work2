#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

/// @default(.2)
uniform float _fadeval;
uniform vec2 _dir;

varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	vec4 col0 = texture2D(sampler, v_texcoord);
	vec4 col1 = texture2D(sampler1, v_texcoord + _dir);
	
	gl_FragColor = mix(col1, col0, _fadeval);
}