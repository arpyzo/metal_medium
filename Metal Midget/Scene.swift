import MetalKit

class Scene {
    var scaleMatrix: float4x4!
    
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
        
        scaleMatrix = float4x4.makeScalingMatrix(1, 2, 0)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        let path1 = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture1 = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path1) as URL, options: nil)
        let path2 = Bundle.main.path(forResource: "sun", ofType: "png")!
        texture2 = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path2) as URL, options: nil)

        let r1 = Rectangle()
        let r2 = Rectangle2()
        
        vertexCount1 = r1.vertexCount
        vertexCount2 = r2.vertexCount

        vertexBuffer1 = metalDevice.makeBuffer(bytes: &r1.vertexData, length: r1.vertexDataSize, options: [])
        vertexBuffer2 = metalDevice.makeBuffer(bytes: &r2.vertexData, length: r2.vertexDataSize, options: [])
    }
}
