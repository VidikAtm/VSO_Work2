#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
#if defined(ENGINE_OS_ANDROID)
	uniform sampler2D sampler1;
 	uniform int CombinedTexture;
#endif

varying mediump vec3 v_highlight;
varying vec2 v_texcoord;
	
void main()
{
	gl_FragColor = texture2D(sampler, v_texcoord);

	float borderHighlight = v_highlight.x * v_highlight.y * 0.33
								+ (1.0 - clamp((1.0 - v_highlight.x) * 8.0, 0.0, 1.0)) * 0.5
								+ (1.0 - clamp((1.0 - v_highlight.y) * 8.0, 0.0, 1.0)) * 0.5;

	gl_FragColor.rgb += borderHighlight * v_highlight.z;

#if defined(ENGINE_OS_ANDROID)
 	if (CombinedTexture == 1){
 		gl_FragColor.a = texture2D(sampler1, v_texcoord).r;
 	}
#endif
}