class Rectangle {
    var vertexData: Array<Float>
    var vertexDataSize: Int
    var vertexCount: Int

    init() {
        let TOP_LEFT     = Vertex(x: -0.5, y:  0.5, z:  0.0, tx: 0.0, ty: 0.0)
        let TOP_RIGHT    = Vertex(x:  0.5, y:  0.5, z:  0.0, tx: 1.0, ty: 0.0)
        let BOTTOM_LEFT  = Vertex(x: -0.5, y: -0.5, z:  0.0, tx: 0.0, ty: 1.0)
        let BOTTOM_RIGHT = Vertex(x:  0.5, y: -0.5, z:  0.0, tx: 1.0, ty: 1.0)

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
        
        vertexCount = vertexData.count
    }
}
