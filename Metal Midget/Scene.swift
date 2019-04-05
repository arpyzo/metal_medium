import MetalKit

class Scene {
    var textureLoader: MTKTextureLoader!
    var texture: MTLTexture!
    
    var vertexCount1: Int
    var vertexCount2: Int
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    
    init(metalDevice: MTLDevice) {
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        
        let r1 = Rectangle()
        let r2 = Rectangle2()
        
        vertexCount1 = r1.getVertexData().count
        vertexCount2 = r2.getVertexData().count
        
        vertexBuffer1 = metalDevice.makeBuffer(bytes: r1.getVertexData(), length: r1.getDataSize(), options: [])
        vertexBuffer2 = metalDevice.makeBuffer(bytes: r2.getVertexData(), length: r2.getDataSize(), options: [])
    }
}