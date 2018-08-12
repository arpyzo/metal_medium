//
//  Matrix.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 8/11/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import Foundation
import GLKit
import simd

class Matrix {
    var matrix: GLKMatrix4
    
    init() {
        matrix = GLKMatrix4MakeScale(2.0, 1.0, 1.0)
    }
    
    var translationMatrix = matrix_identity_float4x4
    var m = matrix_identity_float4x4
    
    //var iii = translationMatrix.subscript(1)
    
    //func floatBuffer() -> simd_float4x4 {
    func floatBuffer() -> [Float] {
        //return (0..<16).map { i in matrix.m[i] }
        //return (0..<16).map { i in translationMatrix.subscript(i) }
        //return translationMatrix
        return [2.0,m[0,1],m[0,2],m[0,3],
                m[1,0],m[1,1],m[1,2],m[1,3],
                m[2,0],m[2,1],m[2,2],m[2,3],
                m[3,0],m[3,1],m[3,2],m[3,3]
               ]
    }
}
