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
        
        renderer = Renderer(metalDevice: metalDevice)
        mtkView.delegate = renderer
        
        scene = Scene(metalDevice: metalDevice)
        renderer.scene = scene
    }
    
    /*override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }*/
}
