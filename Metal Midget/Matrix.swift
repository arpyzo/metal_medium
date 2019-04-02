//
//  Matrix.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 8/11/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import Foundation
import simd

class Matrix {
    //var translationMatrix = matrix_identity_float4x4
    var m = matrix_identity_float4x4

    // iPhone 8 1334-by-750
    init() {
        //m[0,0] = 0.5
        m[1,1] = 0.56

    }
        
    
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
        return m
    }
}
