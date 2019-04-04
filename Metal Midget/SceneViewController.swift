import UIKit
import simd

class SceneViewController: MetalViewController, MetalViewControllerDelegate {
    var texture: MTLTexture!
    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        //objectToDraw = Rectangle(metalDevice: metalDevice)
        renderer = Renderer(metalDevice: metalDevice)
        
        self.metalViewControllerDelegate = self
    }
    
    func renderObjects(drawable: CAMetalDrawable) {
        renderer.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
    }
    
    func updateObjectScale(newSize: CGSize) {
        renderer.updateScale(newSize: newSize)
    }
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        // NO-OP
    }
}
