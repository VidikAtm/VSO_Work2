#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

/// @color @default(1,1,1,1)
uniform vec4 u_lum;

uniform vec3 u_mulU;
uniform vec3 u_addU;
uniform vec3 u_mulV;
uniform vec3 u_addV;

varying vec4 v_color;

varying vec2 v_texcoord;
varying vec2 v_texcoord1;

void main()
{
	vec4 mainTex = texture2D(sampler, v_texcoord);
	
	vec3 uTC = u_mulU * v_texcoord1.x + u_addU;
	vec3 vTC = u_mulV * v_texcoord1.y + u_addV;
	
	vec2 texCoord1;
	texCoord1.x = max( min(uTC.x, uTC.y), uTC.z );
	texCoord1.y = max( min(vTC.x, vTC.y), vTC.z );
	
	vec4 addTex = texture2D(sampler1, texCoord1);
	mainTex.rgb += u_lum.rgb * addTex.rgb * addTex.a;
	gl_FragColor = v_color * mainTex;
}