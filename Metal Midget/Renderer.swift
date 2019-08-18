import MetalKit

class Renderer: NSObject, MTKViewDelegate {
    var metalDevice: MTLDevice!

    var renderPipeline: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    var textureSampler: MTLSamplerState!

    var scene: Scene!
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
        
        scene.updateScreenRatioMatrix(width: Float(size.width), height: Float(size.height))
        
        let bufferSize = MemoryLayout<Float>.size * float4x4.numberOfElements()
        uniformBuffer = metalDevice.makeBuffer(length: bufferSize, options: [])
        
        let bufferPointer = uniformBuffer.contents()
        memcpy(bufferPointer, &scene.viewMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements())
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
        
        var commandBuffer: MTLCommandBuffer!
        commandBuffer = commandQueue.makeCommandBuffer()
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].clearColor = scene.clearColor
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            // TODO: change to "dontcare" once drawing entire screen
        renderPassDescriptor.colorAttachments[0].loadAction = .clear
        renderPassDescriptor.colorAttachments[0].storeAction = .store
        
        var renderEncoder: MTLRenderCommandEncoder!
        renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)
        renderEncoder.setRenderPipelineState(renderPipeline)
        
        // LOOP START
        
        for mapCol in 0...1 {
            for mapRow in 0...1 {
                var translationMatrix = float4x4.makeTranslationMatrix(Float(mapCol) * 0.3 - 0.4, Float(mapRow) * 0.3 + 0.3, 0)

                let bufferSize = MemoryLayout<Float>.size * float4x4.numberOfElements()
                let uniformBuffer2 = metalDevice.makeBuffer(length: bufferSize, options: [])
                
                let bufferPointer = uniformBuffer2!.contents()
                memcpy(bufferPointer, &translationMatrix, MemoryLayout<Float>.size * float4x4.numberOfElements()
                )
                
                renderEncoder.setVertexBuffer(scene.vertexBuffer1, offset: 0, index: 0)
                renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
                renderEncoder.setVertexBuffer(uniformBuffer2, offset: 0, index: 2)

                renderEncoder.setFragmentTexture(scene.map[mapCol][mapRow], index: 0)
                renderEncoder.setFragmentSamplerState(textureSampler, index: 0)
        
                renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.vertexCount1, instanceCount: scene.vertexCount1 / 3)
            }
        }
        // ITERATION
        
        //renderEncoder.setVertexBuffer(scene.vertexBuffer2, offset: 0, index: 0)
        //renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, index: 1)
        
        //renderEncoder.setFragmentTexture(scene.texture2, index: 0)
        //renderEncoder.setFragmentSamplerState(textureSampler, index: 0)
        
        //renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: scene.vertexCount2, instanceCount: scene.vertexCount2 / 3)
        
        // LOOP END
        
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
