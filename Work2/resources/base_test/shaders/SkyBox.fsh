#ifdef GL_ES
	precision highp float;
#endif

uniform samplerCube sampler;

varying vec3 v_texcoord;

void main()
{
	gl_FragColor = textureCube(sampler, v_texcoord);
}