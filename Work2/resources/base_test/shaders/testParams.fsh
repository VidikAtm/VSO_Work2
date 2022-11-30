#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;

/// @default(.33)
uniform float _floatval;
uniform vec2 _vec2val;
uniform vec3 _vec3val;
uniform vec4 _vec4val;
/// @color
uniform vec4 _colorval;

varying vec4 v_color;
varying vec2 v_texcoord;

// based of http://www.chilliant.com/rgb2hsv.html
vec3 hue2rgb(in float hue)
{
	vec3 result;
	result.r = abs(hue * 6.0 - 3.0) - 1.0;
	result.g = 2.0 - abs(hue * 6.0 - 2.0);
	result.b = 2.0 - abs(hue * 6.0 - 4.0);
	
	result = clamp(result, .0, 1.0);
	return result;
}

void main()
{
	gl_FragColor = vec4( hue2rgb(v_texcoord.y), 1.0 );
	
	// _floatval
	gl_FragColor = (v_texcoord.x > .0 && v_texcoord.x < .2)? vec4(1.0) * step(v_texcoord.y,_floatval) :gl_FragColor;
	
	// _vec2val
	gl_FragColor = (v_texcoord.x > .2 && v_texcoord.x < .4)? vec4( step(v_texcoord.y,_vec2val.x),
		step(v_texcoord.y,_vec2val.y),
		step(v_texcoord.y, (_vec2val.x+_vec2val.y) * .5),
		1.0 ) :gl_FragColor;
	
	// _vec3val
	gl_FragColor = (v_texcoord.x > .4 && v_texcoord.x < .6)? vec4( step(v_texcoord.y,_vec3val.x),
		step(v_texcoord.y,_vec3val.y),
		step(v_texcoord.y,_vec3val.z),
		1.0 ) :gl_FragColor;
	
	// _vec4val
	gl_FragColor = (v_texcoord.x > .6 && v_texcoord.x < .8)? vec4( step(v_texcoord.y,_vec4val.x),
		step(v_texcoord.y,_vec4val.y),
		step(v_texcoord.y,_vec4val.z),
		1.0 ) :gl_FragColor;
	gl_FragColor = (v_texcoord.x > .6 && v_texcoord.x < .7)? gl_FragColor * _vec4val.w :gl_FragColor;
	
	// _colorval
	gl_FragColor = (v_texcoord.x > .8 && v_texcoord.x < 1.0)? gl_FragColor * vec4(_colorval.xyz, 1.0) :gl_FragColor;
	gl_FragColor = (v_texcoord.x > .9 && v_texcoord.x < 1.0)? gl_FragColor * _colorval.w :gl_FragColor;
}