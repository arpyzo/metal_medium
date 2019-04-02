import UIKit
import simd

class SceneViewController: MetalViewController, MetalViewControllerDelegate {
    var texture: MTLTexture!
    var objectToDraw: Rectangle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        objectToDraw = Rectangle(metalDevice: metalDevice)
        
        self.metalViewControllerDelegate = self
    }
    
    func renderObjects(drawable:CAMetalDrawable) {
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
    }
    
    func updateObjectScale(newSize: CGSize) {
        // TODO: This isn't scale. It's a ratio
        objectToDraw.updateScale(scale: Float(newSize.width / newSize.height))
    }
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        // NO-OP
    }
}
