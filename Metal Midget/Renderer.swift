import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!

    var renderPipeline: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    var textureSampler: MTLSamplerState!

    var scene: Scene!
    var modelMatrix: Matrix!
    var uniformBuffer: MTLBuffer!

    init(_ metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        
        let metalLibrary = metalDevice.makeDefaultLibrary()!
        
        let samplerDescriptor: MTLSamplerDescriptor! = MTLSamplerDescriptor()
        textureSampler = metalDevice.makeSamplerState(descriptor: samplerDescriptor)

        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipeline = try! metalDevice.makeRenderPipelineState(descriptor: pipelineDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        print("New screen size. Width: \(size.width), Height: \(size.height)")
        
        modelMatrix = modelMatrix ?? Matrix()
        modelMatrix.updateRatioMatrix(width: Float(size.width), height: Float(size.height))
        
        uniformBuffer = metalDevice.makeBuffer(bytes: &modelMatrix.screenRatioMatrix,
                                               length: MemoryLayout.size(ofValue: modelMatrix.screenRatioMatrix),
                                               options: [])
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
        renderPassDescriptor.colorAttachments[0].clearColor = scene.clearColor
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        var commandBuffer: MTLCommandBuffer!
        commandBuffer = commandQueue.makeCommandBuffer()
        
        var renderEncoder: MTLRenderCommandEncoder!
        renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(renderPipeline)
        
        renderEncoder.setVertexBuffer(scene.vertexBuffer1, offset: 0, index: 0)
        renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)

        renderEncoder.setFragmentTexture(scene.texture, index: 0)
        renderEncoder.setFragmentSamplerState(textureSampler, index: 0)
        
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
}
