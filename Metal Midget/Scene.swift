import MetalKit

class Scene {
    var scalingMatrix: float4x4!
    var screenRatioMatrix: float4x4!
    var viewMatrix: float4x4!
    
    var clearColor: MTLClearColor
    
    var textureLoader: MTKTextureLoader!
    var texture1: MTLTexture!
    var texture2: MTLTexture!

    var vertexCount1: Int
    var vertexCount2: Int
    var vertexBuffer1: MTLBuffer!
    var vertexBuffer2: MTLBuffer!
    
    var map = [[MTLTexture]]()
    
    init(_ metalDevice: MTLDevice) {
        clearColor = MTLClearColor(red: 0.0, green: 104.0/255.0, blue: 5.0/255.0, alpha: 1.0)
        
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
        
        map.append([texture1, texture2])
        map.append([texture2, texture1])
        
        updateScalingMatrix(x: 1, y: 1)
        updateScreenRatioMatrix(width: 1, height: 1)
    }
    
    func updateScalingMatrix(x: Float, y: Float) {
        scalingMatrix = float4x4.makeScalingMatrix(x, y, 0)
        viewMatrix = screenRatioMatrix * scalingMatrix

    }

    // iPhone 8 - 750 x 1334
    func updateScreenRatioMatrix(width: Float, height: Float) {
        var screenRatioMatrix = matrix_identity_float4x4
        
        if (height > width) {
            screenRatioMatrix[0,0] = 1
            screenRatioMatrix[1,1] = width / height
        } else {
            screenRatioMatrix[0,0] = height / width
            screenRatioMatrix[1,1] = 1
        }
        
        viewMatrix = screenRatioMatrix * scalingMatrix
    }
}
