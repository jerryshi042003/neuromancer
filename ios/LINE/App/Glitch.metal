#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Horizontal tearing plus a red/blue channel split. amount 0...1.
[[ stitchable ]] half4 lineGlitch(float2 pos, SwiftUI::Layer layer, float time, float amount) {
    float band = floor(pos.y / 7.0);
    float tick = floor(time * 14.0);
    float n = fract(sin(band * 12.9898 + tick * 78.233) * 43758.5453);
    float shift = (n > 1.0 - amount * 0.4) ? (n - 0.5) * 90.0 * amount : 0.0;
    float split = 2.0 + 6.0 * amount;
    half4 r = layer.sample(pos + float2(shift + split, 0));
    half4 g = layer.sample(pos + float2(shift, 0));
    half4 b = layer.sample(pos + float2(shift - split, 0));
    float scan = 0.85 + 0.15 * step(0.5, fract(pos.y / 3.0));
    return half4(r.r, g.g, b.b, max(max(r.a, g.a), b.a)) * half(scan);
}
