struct Vertex {
    var x, y, z: Float      // position
    var r, g, b, a: Float   // color
    var tx, ty: Float       // texture position
    
    func floatBuffer() -> [Float] {
        return [x, y, z, r, g, b, a, tx, ty]
    }
}
