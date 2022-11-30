uniform sampler2D sampler1;
uniform sampler2D sampler2;
varying highp vec2 v_texcoord1;
varying highp vec2 v_texcoord2;

void main()
{
	mediump vec4 diffuse = texture2D(sampler1, v_texcoord1) * 0.5;
	mediump vec4 lightmap = texture2D(sampler2, v_texcoord2) * 0.5;
	
	gl_FragColor = diffuse + lightmap;
	gl_FragColor.a = 1.0;
}