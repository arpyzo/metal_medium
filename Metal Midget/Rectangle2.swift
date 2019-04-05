class Rectangle2 {
    var vertexDataSize: Int
    var vertexData: Array<Float>
    
    init() {
        // x, y, z = 0
        // r, g, b, a = 1 (TODO: needed if texture?)
        // tx, ty - texture coords
        let TOP_LEFT     = Vertex(x: -1.0, y:  0.5, z:  0.0, r:  1.0, g:  0.0, b:  0.0, a:  1.0, tx: 0.0, ty: 0.0)
        let TOP_RIGHT    = Vertex(x:  0.0, y:  0.5, z:  0.0, r:  0.0, g:  1.0, b:  0.0, a:  1.0, tx: 1.0, ty: 0.0)
        let BOTTOM_LEFT  = Vertex(x: -1.0, y: -0.5, z:  0.0, r:  0.0, g:  0.0, b:  1.0, a:  1.0, tx: 0.0, ty: 1.0)
        let BOTTOM_RIGHT = Vertex(x:  0.0, y: -0.5, z:  0.0, r:  0.5, g:  0.5, b:  0.5, a:  1.0, tx: 1.0, ty: 1.0)
        
        // Triangles wound clockwise
        let vertices = [
            BOTTOM_RIGHT, BOTTOM_LEFT, TOP_LEFT,
            BOTTOM_RIGHT, TOP_LEFT, TOP_RIGHT
        ]
        
        vertexData = Array<Float>()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }
        
        vertexDataSize = vertexData.count * MemoryLayout.size(ofValue: vertexData[0])
    }
    
    func getDataSize() -> Int {
        return vertexDataSize
    }
    
    func getVertexData() -> Array<Float> {
        return vertexData
    }
}
