#include <metal_stdlib>

using namespace metal;

struct Uniforms {
    float4x4 viewMatrix;
};

struct Uniforms2 {
    float4x4 translationMatrix;
};

struct VertexIn {
    packed_float3 position;
    packed_float2 texCoord;
};

struct VertexOut {
    float4 position [[ position ]];
    float2 texCoord;
};

vertex VertexOut basic_vertex(const device VertexIn* vertices [[ buffer(0) ]],
                              const device Uniforms& uniforms [[ buffer(1) ]],
                              const device Uniforms2& uniforms2 [[ buffer(2) ]],
                              unsigned int vertexId [[ vertex_id ]]) {
    
    VertexIn vertexIn = vertices[vertexId];
    
    VertexOut vertexOut;
    vertexOut.position = uniforms.viewMatrix * uniforms2.translationMatrix * float4(vertexIn.position, 1);
    //vertexOut.position = uniforms.viewMatrix * float4(vertexIn.position, 1);
    vertexOut.texCoord = vertexIn.texCoord;
    
    return vertexOut;
}

fragment float4 basic_fragment(VertexOut vertices [[ stage_in ]],
                               texture2d<float> texture2D [[ texture(0) ]],
                               sampler sampler2D [[ sampler(0) ]]) {
    
    float4 color = texture2D.sample(sampler2D, vertices.texCoord);
    return color;
}
