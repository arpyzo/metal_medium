import simd

// iPhone 8 - 750 x 1334

class Matrix {
    var matrix = matrix_identity_float4x4

    /*func floatBuffer() -> [Float] {
        //return (0..<16).map { i in matrix.m[i] }
        //return (0..<16).map { i in translationMatrix.subscript(i) }
        //return translationMatrix
        return [   0.5, m[0,1], m[0,2], m[0,3],
                m[1,0],    1.5, m[1,2], m[1,3],
                m[2,0], m[2,1], m[2,2], m[2,3],
                m[3,0], m[3,1], m[3,2], m[3,3]
               ]
    }*/
    
    func rawFloat4x4() -> float4x4 {
        return matrix
    }
}
