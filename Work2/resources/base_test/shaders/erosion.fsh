#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;

varying vec2 v_texcoord;

uniform float hardness; // множитель "резкости"
uniform float alphaAdd; // 0 - не меняет полупрозрачность, 1 - делает её непрозрачной, если указано высокое значение в hardness

varying vec4 v_color;

void main()
{
	vec4 c = texture2D(sampler, v_texcoord);
	
	float a = clamp(hardness * (c.a + v_color.a - 1.0), 0.0, c.a + alphaAdd);
	
	gl_FragColor = vec4(c.rgb * v_color.rgb, a);
}
