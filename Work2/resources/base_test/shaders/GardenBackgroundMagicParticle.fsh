#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler; // Texture
uniform sampler2D sampler1; // Light

varying vec4  v_color;
varying highp vec2 v_texcoord;
varying highp vec2 v_screencoord;

uniform highp float u_amp;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord);	
	vec4 light = texture2D(sampler1, v_screencoord);
	
	gl_FragColor = v_color * (tex.r + min(1.0, u_amp * (light.g + light.b)) * tex.g);
}