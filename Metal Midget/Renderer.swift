import Foundation
import Metal
import MetalKit
import QuartzCore

class Renderer: NSObject, MTKViewDelegate {
    //var mtkView: MTKView!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    
    var texture: MTLTexture!
    
    var vertexCount1: Int
    var vertexCount2: Int
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    var uniformBuffer: MTLBuffer!
    var samplerState: MTLSamplerState!
    var scaleMatrix: Matrix!
    
    var metalDevice: MTLDevice!
    
    //init(metalDevice: MTLDevice, mtkView: MTKView) {
    init(metalDevice: MTLDevice) {
        self.metalDevice = metalDevice
        //self.mtkView = mtkView
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        
        let metalLibrary = metalDevice.makeDefaultLibrary()!
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
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
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    //func updateScale(newSize: CGSize) {
        print("New screen size. Width: \(size.width), Height: \(size.height)")
        
        if (size.height > size.width) {
            scaleMatrix.m[0,0] = 1
            scaleMatrix.m[1,1] = Float(size.width / size.height)
        } else {
            scaleMatrix.m[0,0] = Float(size.height / size.width)
            scaleMatrix.m[1,1] = 1
        }
        
        var matrixData = scaleMatrix.rawFloat4x4()
        let matrixDataSize = MemoryLayout.size(ofValue: matrixData)
        uniformBuffer = metalDevice.makeBuffer(bytes: &matrixData, length: matrixDataSize, options: [])
    }
    
    func draw(in view: MTKView) {
    //    render(view.currentDrawable)
    //}
    //func render(drawable: CAMetalDrawable, texture: MTLTexture) {
        guard let drawable = view.currentDrawable else { return }
        //let drawable = view.currentDrawable!
        
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
