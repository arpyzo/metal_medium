#include <metal_stdlib>

using namespace metal;

struct Uniforms {
    float4x4 model_matrix;
};

struct VertexIn {
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut basic_vertex(const device VertexIn* vertices [[ buffer(0) ]],
                              const device Uniforms& uniforms [[ buffer(1) ]],
                              unsigned int vid [[ vertex_id ]]) {
    
    VertexIn VertexIn = vertices[vid];
    
    float4x4 model_matrix = uniforms.model_matrix; // model view matrix
    
    VertexOut VertexOut;
    VertexOut.position = model_matrix * float4(VertexIn.position, 1);
    VertexOut.texCoord = VertexIn.texCoord;
    
    return VertexOut;
}

fragment float4 basic_fragment(VertexOut vertices [[stage_in]],
                               texture2d<float> tex2D [[ texture(0) ]],
                               sampler sampler2D [[ sampler(0) ]]) {
    
    float4 color = tex2D.sample(sampler2D, vertices.texCoord);
    return color;
}
