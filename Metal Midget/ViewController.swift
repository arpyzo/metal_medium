import UIKit
import MetalKit

class ViewController: UIViewController {
    var mtkView: MTKView!
    var scene: Scene!
    var renderer: Renderer!

    override func loadView() {
        self.view = MTKView()
        mtkView = (self.view as! MTKView)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let metalDevice = MTLCreateSystemDefaultDevice()!
        mtkView.device = metalDevice
        
        renderer = Renderer(metalDevice)
        mtkView.delegate = renderer
        
        scene = Scene(metalDevice)
        scene.updateScreenRatioMatrix(width:  Float(self.view.bounds.size.width),
                                      height: Float(self.view.bounds.size.height))
        renderer.scene = scene
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
