// Ink + flowing mist background for Ghostty, animated in real time.
// Deep charcoal ink base, three layers of drifting fog, print grain.
// Composited behind terminal text.

float br_hash(vec2 p) {
    p = fract(p * vec2(234.34, 435.345));
    p += dot(p, p + 34.23);
    return fract(p.x * p.y);
}

float br_noise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    vec2 u = f * f * (3.0 - 2.0 * f);
    float a = br_hash(i);
    float b = br_hash(i + vec2(1.0, 0.0));
    float c = br_hash(i + vec2(0.0, 1.0));
    float d = br_hash(i + vec2(1.0, 1.0));
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

float br_fbm(vec2 p, int oct) {
    float v = 0.0;
    float amp = 0.5;
    for (int i = 0; i < 5; i++) {
        if (i >= oct) break;
        v += amp * br_noise(p);
        p = mat2(0.8, 0.6, -0.6, 0.8) * p * 2.0 + vec2(3.1, 1.7);
        amp *= 0.5;
    }
    return v;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 tuv = fragCoord / iResolution.xy;
    vec2 uv = tuv;
    uv.y = 1.0 - uv.y; // Metal: origin is top-left
    float t = iTime * 0.03;

    vec2 p = vec2(uv.x * iResolution.x / iResolution.y, uv.y);

    // deep ink base, gently darker toward the top
    vec3 col = mix(vec3(0.075, 0.082, 0.095), vec3(0.055, 0.060, 0.070), uv.y);

    // three drifting mist layers
    float m1 = br_fbm(p * 1.6 + vec2(t * 0.35, t * 0.06), 4);
    float m2 = br_fbm(p * 2.8 + vec2(-t * 0.22, 0.0) + 7.3, 4);
    float m3 = br_fbm(p * 0.9 + vec2(t * 0.12, 3.1), 3);
    float mist = smoothstep(0.38, 0.78, m1) * 0.55
               + smoothstep(0.42, 0.80, m2) * 0.40
               + smoothstep(0.48, 0.85, m3) * 0.35;
    col = mix(col, vec3(0.42, 0.47, 0.53), clamp(mist, 0.0, 1.0) * 0.55);

    // print grain
    col += (br_noise(uv * 900.0) - 0.5) * 0.02;

    // keep terminal content; replace only background-colored pixels
    vec4 term = texture(iChannel0, tuv);
    float bg = smoothstep(0.09, 0.03, distance(term.rgb, iBackgroundColor));
    bg = max(bg, step(term.a, 0.05));
    float outA = max(term.a, bg * step(term.a, 0.05));
    fragColor = vec4(mix(term.rgb, clamp(col, 0.0, 1.0), bg), outA);
}
