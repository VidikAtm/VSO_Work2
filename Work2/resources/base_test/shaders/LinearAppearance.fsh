#ifdef GL_ES
precision highp float;
#endif

/// @default(0.5) @excludeFromShaderConstants
uniform mediump float u_percent;
uniform sampler2D sampler;
uniform float u_border;

varying vec2 v_texcoord;
varying mediump vec4 v_color;
varying float v_alphaGradient;

void main()
{
	mediump vec4 color = texture2D(sampler, v_texcoord); 
    color.a -= smoothstep(u_percent - u_border, u_percent, v_alphaGradient);
    gl_FragColor = color * v_color;
}
