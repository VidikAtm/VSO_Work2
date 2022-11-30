#ifdef GL_ES
precision highp float;
#endif

uniform sampler2D sampler;
uniform vec4 u_color;
uniform vec2 center;
uniform float progress;
varying vec2 v_texcoord;

void main()
{
    float frequency = 20.0;
    float speed = 10.0;
    float amplitude = 0.05;
    vec2 toUV = v_texcoord - center;
    float distanceFromCenter = length(toUV);
    vec2 normToUV = toUV / distanceFromCenter;
 
    float wave = cos(frequency * distanceFromCenter - speed * progress);
    float offset = progress * wave * amplitude;
 
    vec2 newUV = center + normToUV * (distanceFromCenter + offset);
	gl_FragColor = texture2D(sampler, newUV);
}