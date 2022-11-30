#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1; // Spreading speed texture

uniform float u_radius;
uniform float u_textureSize;
uniform float u_spreadCoeff;

uniform float u_minSpeed;
uniform float u_maxSpeedIncrease;


varying vec4 v_color;
varying vec2 v_texcoord;

void main()
{
	float speed = u_minSpeed + texture2D(sampler1, v_texcoord).b * u_maxSpeedIncrease;

	float offs = u_radius / u_textureSize;
	
	highp vec4 color = texture2D(sampler, v_texcoord + vec2(offs, 0.0));
	color += texture2D(sampler, v_texcoord + vec2(-offs, 0.0));
	color += texture2D(sampler, v_texcoord + vec2(0.0, offs));
	color += texture2D(sampler, v_texcoord + vec2(0.0, -offs));
	color *= u_spreadCoeff * speed;
	
	color += texture2D(sampler, v_texcoord);

	gl_FragColor = v_color * color;
}