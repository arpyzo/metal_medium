//
//  Vertex.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 6/23/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

struct Vertex {
    var x, y, z: Float      // position
    var r, g, b, a: Float   // color
    var tx, ty: Float       // texture position
    
    func floatBuffer() -> [Float] {
        return [x, y, z, r, g, b, a, tx, ty]
    }
}
