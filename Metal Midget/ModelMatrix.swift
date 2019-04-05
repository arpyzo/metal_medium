import simd

// iPhone 8 - 750 x 1334

class ModelMatrix {
    var screenRatioMatrix = matrix_identity_float4x4
        
    func updateRatioMatrix(width: Float, height: Float) {
        if (height > width) {
            screenRatioMatrix[0,0] = 1
            screenRatioMatrix[1,1] = width / height
        } else {
            screenRatioMatrix[0,0] = height / width
            screenRatioMatrix[1,1] = 1
        }
    }
}
