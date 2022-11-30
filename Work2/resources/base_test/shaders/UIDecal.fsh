#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler; // Main texture
uniform sampler2D sampler1; // Decal texture

uniform mediump float u_decalOpacity;

varying vec4  v_color;
varying highp vec2 v_texcoord;
varying highp vec2 v_texcoord1;

void main()
{
	vec4 tex = texture2D(sampler, v_texcoord);	
	vec4 decal = texture2D(sampler1, v_texcoord1);
	tex.rgb = mix(tex.rgb, decal.rgb, decal.a * u_decalOpacity);
	gl_FragColor = tex * v_color;
}