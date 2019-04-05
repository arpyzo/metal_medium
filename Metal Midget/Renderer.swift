import MetalKit
import QuartzCore

class Renderer: NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!

    var renderPipeline: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    
    var uniformBuffer: MTLBuffer!
    var samplerState: MTLSamplerState!
    var modelMatrix: Matrix!
    
    var scene: Scene!
        
    init(metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        
        let metalLibrary = metalDevice.makeDefaultLibrary()!
        
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipeline = try! metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        modelMatrix = Matrix()
        var matrixData = modelMatrix.rawFloat4x4()
        let matrixDataSize = MemoryLayout.size(ofValue: matrixData)
        uniformBuffer = metalDevice.makeBuffer(bytes: &matrixData, length: matrixDataSize, options: [])
        
        samplerState = Renderer.defaultSampler(metalDevice)
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("New screen size. Width: \(size.width), Height: \(size.height)")
        
        if (size.height > size.width) {
            modelMatrix.matrix[0,0] = 1
            modelMatrix.matrix[1,1] = Float(size.width / size.height)
        } else {
            modelMatrix.matrix[0,0] = Float(size.height / size.width)
            modelMatrix.matrix[1,1] = 1
        }
        
        var matrixData = modelMatrix.rawFloat4x4()
        let matrixDataSize = MemoryLayout.size(ofValue: matrixData)
        uniformBuffer = metalDevice.makeBuffer(bytes: &matrixData, length: matrixDataSize, options: [])
    }
    
    func draw(in view: MTKView) {
        // UPDATE HERE
        //let systemTime = CACurrentMediaTime()
        //print("Time: \(systemTime)")
        //let timeDifference = (lastRenderTime == nil) ? 0 : (systemTime - lastRenderTime!)
        //lastRenderTime = systemTime
        //update(dt: timeDifference)

        if (scene == nil) { return }
        guard let drawable = view.currentDrawable else { return }
        
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
        
        renderEncoder.setVertexBuffer(scene.vertexBuffer1, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

        renderEncoder.setFragmentTexture(scene.texture, index: 0)
        if let samplerState = samplerState {
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.vertexCount1, instanceCount: scene.vertexCount1 / 3)
        
        /*renderEncoder.setVertexBuffer(vertexBuffer2, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        renderEncoder.setFragmentTexture(texture, index: 0)
        if let samplerState = samplerState {
            renderEncoder.setFragmentSamplerState(samplerState, index: 0)
        }
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertexCount2, instanceCount: vertexCount2/3)*/
        
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
