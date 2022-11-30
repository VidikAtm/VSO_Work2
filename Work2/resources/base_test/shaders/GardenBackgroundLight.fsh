#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler; // Lightmask
uniform sampler2D sampler1; // Noise

uniform vec2 u_scale;
uniform vec2 u_offset;

varying vec4  v_color;
varying highp vec2 v_texcoord;
varying highp vec2 v_screencoord;

void main()
{
	vec4 lightMask = v_color * texture2D(sampler, v_texcoord);	
	vec4 noise = texture2D(sampler1, u_scale * v_screencoord + u_offset);
	
	gl_FragColor = lightMask * noise;
}