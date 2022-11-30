#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;

//uniform mat4 u_autoWorldMatrix;
//uniform mat4 u_autoViewProjMatrix;
uniform vec3 u_autoWorldCameraPos;
uniform float u_reflectionDistance;
uniform float u_transparencyDistance;
uniform float u_reflectionPower;

varying vec4 v_color;
varying vec4 v_screenPos;
varying vec3 v_worldPos;

void main()
{
	vec2 texCoords = 0.5 * v_screenPos.xy / v_screenPos.w + 0.5;
	texCoords.y = 1.0 - texCoords.y;
	vec4 reflectionColor = texture2D(sampler, texCoords);
	
	vec3 dir= v_worldPos - u_autoWorldCameraPos;
	float dist = length(dir);
	//float r = dir.y / dist;
	float reflectiveness = dist / u_reflectionDistance;
	float transparency = dist / u_transparencyDistance;
	reflectiveness = clamp(reflectiveness, 0.0, 1.0);
	transparency = clamp(transparency, 0.0, 1.0);
	
	reflectiveness = pow(reflectiveness, u_reflectionPower);
	
	gl_FragColor.rgb = mix( v_color.rgb, reflectionColor.rgb, reflectionColor.a * reflectiveness);
	gl_FragColor.a = transparency;
}