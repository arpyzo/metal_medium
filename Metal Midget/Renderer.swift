import Foundation
import Metal
import QuartzCore

class Renderer {
    var vertexCount1: Int
    var vertexCount2: Int
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    var uniformBuffer: MTLBuffer!
    var samplerState: MTLSamplerState!
    var scaleMatrix: Matrix!
    
    var metalDevice: MTLDevice!
    
    init(metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        
        // TODO: Create here or in Rectangle?
        //var vertexData = Array<Float>()
        //for vertex in vertices {
        //    vertexData += vertex.floatBuffer()
        //}
        
        //let vertexDataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
        //vertexBuffer = metalDevice.makeBuffer(bytes: vertexData, length: vertexDataSize, options: [])
        
        let r1 = Rectangle()
        let r2 = Rectangle2()
        
        vertexBuffer1 = metalDevice.makeBuffer(bytes: r1.getVertexData(), length: r1.getDataSize(), options: [])
        vertexBuffer2 = metalDevice.makeBuffer(bytes: r2.getVertexData(), length: r2.getDataSize(), options: [])

        // TODO: Create here or in Matrix?
        scaleMatrix = Matrix()
        var matrixData = scaleMatrix.rawFloat4x4()
        let matrixDataSize = MemoryLayout.size(ofValue: matrixData)
        uniformBuffer = metalDevice.makeBuffer(bytes: &matrixData, length: matrixDataSize, options: [])
        
        samplerState = Renderer.defaultSampler(metalDevice)
        
        vertexCount1 = r1.getVertexData().count
        vertexCount2 = r2.getVertexData().count
    }
    
    func updateScale(scale: Float) {
        print("New scale: \(scale)")
        scaleMatrix.m[1,1] = scale
        var matrixData = scaleMatrix.rawFloat4x4()
        let matrixDataSize = MemoryLayout.size(ofValue: matrixData)
        uniformBuffer = metalDevice.makeBuffer(bytes: &matrixData, length: matrixDataSize, options: [])
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, texture: MTLTexture) {
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        var commandBuffer: MTLCommandBuffer!
        commandBuffer = commandQueue.makeCommandBuffer()
        
        var renderEncoder: MTLRenderCommandEncoder!
        renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.setVertexBuffer(vertexBuffer1, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

        renderEncoder.setFragmentTexture(texture, index: 0)
        if let samplerState = samplerState {
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount1, instanceCount: vertexCount1/3)
        
        renderEncoder.setVertexBuffer(vertexBuffer2, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder.setFragmentTexture(texture, index: 0)
        if let samplerState = samplerState {
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount2, instanceCount: vertexCount2/3)
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    class func defaultSampler(_ device: MTLDevice) -> MTLSamplerState {
        let pSamplerDescriptor:MTLSamplerDescriptor? = MTLSamplerDescriptor();
        
        if let sampler = pSamplerDescriptor {
            //sampler.minFilter             = MTLSamplerMinMagFilter.linear
            //sampler.magFilter             = MTLSamplerMinMagFilter.linear
            sampler.minFilter             = MTLSamplerMinMagFilter.nearest
            sampler.magFilter             = MTLSamplerMinMagFilter.nearest
            sampler.mipFilter             = MTLSamplerMipFilter.nearest
            sampler.maxAnisotropy         = 1
            sampler.sAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.tAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.rAddressMode          = MTLSamplerAddressMode.clampToEdge
            sampler.normalizedCoordinates = true
            sampler.lodMinClamp           = 0
            sampler.lodMaxClamp           = Float.greatestFiniteMagnitude
        }
        else {
            print("ERROR: Failed creating a sampler descriptor!")
        }
        return device.makeSamplerState(descriptor: pSamplerDescriptor!)!
    }
}
