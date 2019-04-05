import MetalKit

class Scene {
    var clearColor: MTLClearColor
    
    var textureLoader: MTKTextureLoader!
    var texture1: MTLTexture!
    var texture2: MTLTexture!

    var vertexCount1: Int
    var vertexCount2: Int
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    
    init(_ metalDevice: MTLDevice) {
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        let path1 = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture1 = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path1) as URL, options: nil)
        let path2 = Bundle.main.path(forResource: "sun", ofType: "png")!
        texture2 = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path2) as URL, options: nil)

        let r1 = Rectangle()
        let r2 = Rectangle2()
        
        vertexCount1 = r1.getVertexData().count
        vertexCount2 = r2.getVertexData().count
        
        vertexBuffer1 = metalDevice.makeBuffer(bytes: r1.getVertexData(), length: r1.getDataSize(), options: [])
        vertexBuffer2 = metalDevice.makeBuffer(bytes: r2.getVertexData(), length: r2.getDataSize(), options: [])
    }
}
