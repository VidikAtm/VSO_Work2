#ifdef GL_ES
	precision highp float;
#endif

uniform sampler2D sampler;
uniform sampler2D sampler1;

uniform mediump vec4 u_uvscale_t0;
uniform highp vec4 su_autoUVPixelSize0;

varying highp vec4 v_position; 
varying highp vec2 v_texcoord;

// #define TEMPORAL_AA_ENABLED 1
// #define TEMPORAL_AA_CLIPPING_ENABLED 1

#ifdef TEMPORAL_AA_ENABLED
    #ifdef TEMPORAL_AA_CLIPPING_ENABLED

        #define TARGETV vec3(0.0, 0.5, 0.0)
        vec3 camera(float time)
        {
            return vec3(cos(time) * 2.0, 1.2 + sin(time) * 0.5, 3.0);
        }

        void rayForPixel(in float aspectRatioInv, in vec2 screenCoords, in float time, out vec3 ro, out vec3 rd)
        {
            vec3 pos = camera(time);
            vec3 up = vec3(0.0, 1.0, 0.0);
            vec3 dir = normalize(TARGETV - pos);
            vec3 right = normalize(cross(dir, up));
            up = normalize(cross(right, dir));
            float fov = radians(50.0);    
            float imgU = tan(fov) * distance(pos, TARGETV);
            float imgV = imgU * aspectRatioInv;
            vec2 uv = screenCoords * 2.0 - 1.0;
            dir = normalize(TARGETV + uv.x * imgU * right + uv.y * imgV * up - pos);
            ro = pos;
            rd = dir;
        }
        vec2 pixelForPos(in float aspectRatioInv, in vec3 worldPos, in float time)
        {
            vec3 pos = camera(time);
            vec3 up = vec3(0.0, 1.0, 0.0);
            vec3 dir = normalize(TARGETV - pos);
            vec3 right = normalize(cross(dir, up));
            up = normalize(cross(right, dir));
            float fov = radians(50.0);
            float imgU = tan(fov) * distance(pos, TARGETV);
            float imgV = imgU * aspectRatioInv;
            float dWorld = dot(worldPos - pos, dir);
            float dProj = distance(pos, TARGETV);
            vec3 projPos = (worldPos - pos) * (dProj / dWorld) + pos - TARGETV;
            vec2 uv = vec2(dot(projPos, right) / imgU,
                        dot(projPos, up)    / imgV) * 0.5 + 0.5;
            return uv;
        }
        vec3 rgb2ycocg(in vec3 rgb)
        {
            float co = rgb.r - rgb.b;
            float t = rgb.b + co / 2.0;
            float cg = rgb.g - t;
            float y = t + cg / 2.0;
            return vec3(y, co, cg);
        }
        vec3 ycocg2rgb(in vec3 ycocg)
        {
            float t = ycocg.r - ycocg.b / 2.0;
            float g = ycocg.b + t;
            float b = t - ycocg.g / 2.0;
            float r = ycocg.g + b;
            return vec3(r, g, b);
        }

        vec3 clipToAABB(in vec3 cOld, in vec3 cNew, in vec3 centre, in vec3 halfSize)
        {
            if (all(lessThanEqual(abs(cOld - centre), halfSize))) {
                return cOld;
            }
            vec3 dir = (cNew - cOld);
            vec3 near = centre - sign(dir) * halfSize;
            vec3 tAll = (near - cOld) / dir;
            float t = 1e20;
            for (int i = 0; i < 3; i++) {
                if (tAll[i] >= 0.0 && tAll[i] < t) {
                    t = tAll[i];
                }
            }
            if (t >= 1e20) {
                return cOld;
            }
            return cOld + dir * t;
        }
        void main()
        {
            highp vec2 screenCoords = v_texcoord;
            mediump vec4 val = texture2D(sampler, screenCoords);
            highp vec2 pixelSize = su_autoUVPixelSize0.xy;

            if (all(lessThanEqual(v_texcoord * (1.0 / pixelSize.xy), vec2(1.0)))) {
                gl_FragColor = vec4(val.rgb, 1.0);
                return;
            }
            float aspectRatioInv = pixelSize.x / pixelSize.y;
            vec2 times = vec2(0.0, 0.0);
            vec3 currRO, currRD;
            rayForPixel(aspectRatioInv, screenCoords, times.x, currRO, currRD);
            vec3 worldPos = currRO + val.w * currRD;
            vec2 fcOld = pixelForPos(aspectRatioInv, worldPos, times.y);
            vec3 colorOld = texture2D(sampler1, fcOld).rgb;

            highp vec2 fcUVs[4];
            fcUVs[0] = screenCoords + vec2(-pixelSize.x,  0.0);
            fcUVs[1] = screenCoords + vec2( pixelSize.x,  0.0);
            fcUVs[2] = screenCoords + vec2( 0.0, -pixelSize.y);
            fcUVs[3] = screenCoords + vec2( 0.0,  pixelSize.y);
            vec3 mean = rgb2ycocg(val.rgb);
            vec3 stddev = mean * mean;
            for (int i = 0; i < 4; i++) {
                vec3 c = rgb2ycocg(texture2D(sampler, fcUVs[i]).rgb);
                mean += c;
                stddev += c * c;
            }
            const float mFactor = 1.0 / 5.0;
            mean *= mFactor;
            stddev = sqrt(stddev * mFactor - mean * mean);
            colorOld = ycocg2rgb(clipToAABB(rgb2ycocg(colorOld), rgb2ycocg(val.rgb), mean, stddev));
            
            gl_FragColor = vec4(mix(colorOld, val.rgb, 0.1), 1.0);
        }
    #else
        vec3 encodePalYuv(in vec3 rgb)
        {
            return vec3(
                dot(rgb, vec3(0.299, 0.587, 0.114)),
                dot(rgb, vec3(-0.14713, -0.28886, 0.436)),
                dot(rgb, vec3(0.615, -0.51499, -0.10001))
            );
        }

        vec3 decodePalYuv(in vec3 yuv)
        {
            return vec3(
                dot(yuv, vec3(1., 0., 1.13983)),
                dot(yuv, vec3(1., -0.39465, -0.58060)),
                dot(yuv, vec3(1., 2.03211, 0.))
            );
        }


        void main()
        {
            highp vec2 uv = v_texcoord;
            vec4 lastColor = texture2D(sampler1, uv);
            
            vec3 antialiased = lastColor.xyz;
            float mixRate = min(lastColor.w, 0.5);
            
            vec2 off = su_autoUVPixelSize0.xy;
            vec3 in0 = texture2D(sampler, uv).xyz;
            
            antialiased = mix(antialiased * antialiased, in0 * in0, mixRate);
            antialiased = sqrt(antialiased);
            
            // vec2 fcUVs[8];
            // fcUVs[0] = uv + vec2( pixelSize.x,  0.0);
            // fcUVs[1] = uv + vec2(-pixelSize.x,  0.0);
            // fcUVs[2] = uv + vec2( 0.0,  pixelSize.y);
            // fcUVs[3] = uv + vec2( 0.0, -pixelSize.y);
            // fcUVs[4] = uv + vec2( pixelSize.x, pixelSize.y);
            // fcUVs[5] = uv + vec2(-pixelSize.x, pixelSize.y);
            // fcUVs[6] = uv + vec2( pixelSize.x,-pixelSize.y);
            // fcUVs[7] = uv + vec2(-pixelSize.x,-pixelSize.y);

            vec3 in1 = texture2D(sampler, uv + vec2( pixelSize.x,  0.0)).xyz;
            vec3 in2 = texture2D(sampler, uv + vec2(-pixelSize.x,  0.0)).xyz;
            vec3 in3 = texture2D(sampler, uv + vec2( 0.0,  pixelSize.y)).xyz;
            vec3 in4 = texture2D(sampler, uv + vec2( 0.0, -pixelSize.y)).xyz;
            vec3 in5 = texture2D(sampler,  uv + vec2( pixelSize.x, pixelSize.y)).xyz;
            vec3 in6 = texture2D(sampler, uv + vec2(-pixelSize.x, pixelSize.y)).xyz;
            vec3 in7 = texture2D(sampler, uv + vec2( pixelSize.x,-pixelSize.y)).xyz;
            vec3 in8 = texture2D(sampler, uv + vec2(-pixelSize.x,-pixelSize.y)).xyz;
            
            antialiased = encodePalYuv(antialiased);
            in0 = encodePalYuv(in0);
            in1 = encodePalYuv(in1);
            in2 = encodePalYuv(in2);
            in3 = encodePalYuv(in3);
            in4 = encodePalYuv(in4);
            in5 = encodePalYuv(in5);
            in6 = encodePalYuv(in6);
            in7 = encodePalYuv(in7);
            in8 = encodePalYuv(in8);
            
            vec3 minColor = min(min(min(in0, in1), min(in2, in3)), in4);
            vec3 maxColor = max(max(max(in0, in1), max(in2, in3)), in4);
            minColor = mix(minColor,
            min(min(min(in5, in6), min(in7, in8)), minColor), 0.5);
            maxColor = mix(maxColor,
            max(max(max(in5, in6), max(in7, in8)), maxColor), 0.5);
            
            vec3 preclamping = antialiased;
            antialiased = clamp(antialiased, minColor, maxColor);
            
            mixRate = 1.0 / (1.0 / mixRate + 1.0);
            
            vec3 diff = antialiased - preclamping;
            float clampAmount = dot(diff, diff);
            
            mixRate += clampAmount * 4.0;
            mixRate = clamp(mixRate, 0.05, 0.5);
            
            antialiased = decodePalYuv(antialiased);
                
            gl_FragColor = vec4(antialiased, mixRate);
        }

    #endif
#else
    #define MULTIPLE_MAIN (1.0 / 4.0)
    #define MULTIPLE (1.0 / 8.0)
    #define MULTIPLE2 (1.0 / 16.0)

    #define TRESHOLD 0.001
    #define TRESHOLD_INV (1.0 / TRESHOLD)

    void main()
    {
        //vec2 pos = v_position.xy;
        highp vec2 screenCoords = v_texcoord;//pos * 0.5 + 0.5;
        highp float depthSrc = texture2D(sampler1, screenCoords).r;
        
        highp vec2 pixelSize = su_autoUVPixelSize0.xy;

        highp vec2 offsetW = vec2(pixelSize.x, 0.0);
        highp vec2 offsetH = vec2(0.0, pixelSize.y);
        highp vec2 offset_RT = vec2(pixelSize.x, pixelSize.y);
        highp vec2 offset_RD = vec2(pixelSize.x, -pixelSize.y);

        mediump vec4 blendF = vec4(
            texture2D(sampler1, screenCoords + offsetW).r,
            texture2D(sampler1, screenCoords - offsetW).r,
            texture2D(sampler1, screenCoords + offsetH).r,
            texture2D(sampler1, screenCoords - offsetH).r
        );
        blendF = abs((blendF) - depthSrc);
        blendF = clamp(blendF * TRESHOLD_INV, 0.0, 1.0);
        blendF = blendF * blendF * MULTIPLE;

        mediump vec4 blendF2 = vec4(
            texture2D(sampler1, screenCoords + offset_RT).r,
            texture2D(sampler1, screenCoords + offset_RD).r,
            texture2D(sampler1, screenCoords - offset_RT).r,
            texture2D(sampler1, screenCoords - offset_RD).r
        );
        blendF2 = abs((blendF2) - depthSrc);
        blendF2 = clamp(blendF2 * TRESHOLD_INV, 0.0, 1.0);
        blendF2 = blendF2 * blendF2 * MULTIPLE2;

        float lerpMain = blendF.x + blendF.y + blendF.z + blendF.w + blendF2.x + blendF2.y + blendF2.z + blendF2.w;
        mediump vec4 sum = texture2D(sampler, screenCoords) * (1.0 - lerpMain);
        
        sum += texture2D(sampler, screenCoords + offsetW) * blendF.x;
        sum += texture2D(sampler, screenCoords - offsetW) * blendF.y;
        sum += texture2D(sampler, screenCoords + offsetH) * blendF.z;
        sum += texture2D(sampler, screenCoords - offsetH) * blendF.w;
        
        sum += texture2D(sampler, screenCoords + offset_RT) * blendF2.x;	
        sum += texture2D(sampler, screenCoords + offset_RD) * blendF2.y;
        sum += texture2D(sampler, screenCoords - offset_RT) * blendF2.z;
        sum += texture2D(sampler, screenCoords - offset_RD) * blendF2.w;

        //sum = sum * 0.0001 + vec4(vec3(lerpMain), 1.0);

        gl_FragColor = sum;
    }
#endif
