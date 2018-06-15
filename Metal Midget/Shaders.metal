//
//  Shaders.metal
//  Metal Midget
//
//  Created by Robert Pyzalski on 2/2/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

vertex float4 basic_vertex(const device packed_float3* vertex_array [[buffer(0)]], unsigned int vertex_id [[vertex_id]]) {
    return float4(vertex_array[vertex_id], 1.0);
}

fragment half4 basic_fragment() {
    return half4(1.0);
}

