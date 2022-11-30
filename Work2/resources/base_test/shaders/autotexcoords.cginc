uniform mediump vec4 u_uvscale_t0;
uniform mediump vec4 u_uvscale_t1;
uniform mediump vec4 u_uvscale_t2;
uniform mediump vec4 u_uvscale_t3;

// .xy = 1 / RealWidth, .zw = Width / RealWidth
uniform mediump vec4 u_autoUVPixelSize0;
uniform mediump vec4 u_autoUVPixelSize1;
uniform mediump vec4 u_autoUVPixelSize2;
uniform mediump vec4 u_autoUVPixelSize3;

highp vec2 texCoordSampler01(highp vec2 texCoord)
{
	return texCoord * u_uvscale_t0.xy + u_uvscale_t0.zw;
}

highp vec2 texCoordSampler1(highp vec2 texCoord)
{
	return texCoord * u_uvscale_t1.xy + u_uvscale_t1.zw;
}

highp vec2 texCoordSampler2(highp vec2 texCoord)
{
	return texCoord * u_uvscale_t2.xy + u_uvscale_t2.zw;
}

highp vec2 texCoordSampler3(highp vec2 texCoord)
{
	return texCoord * u_uvscale_t3.xy + u_uvscale_t3.zw;
}