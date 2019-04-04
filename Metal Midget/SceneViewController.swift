import UIKit
import MetalKit
import simd

class SceneViewController: UIViewController {
    var mtkView: MTKView {
        return view as! MTKView
    }

    //var texture: MTLTexture!
    //var mtkView: MTKView!
    var renderer: Renderer!
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        
        //let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        //texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        //objectToDraw = Rectangle(metalDevice: metalDevice)
        
        
        //let metalDevice = MTLCreateSystemDefaultDevice()!
        
        //mtkView = MTKView()
        //mtkView.device = metalDevice
        //mtkView.preferredFramesPerSecond = 60
        //mtkView.clearColor = MTLClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        /*mtkView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mtkView)
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mtkView]|", options: [], metrics: nil, views: ["mtkView" : mtkView]))*/
        
        let metalDevice = MTLCreateSystemDefaultDevice()!
        mtkView.device = metalDevice
        
        //renderer = Renderer(metalDevice: metalDevice, mtkView: mtkView)
        renderer = Renderer(metalDevice: metalDevice)
        mtkView.delegate = renderer

        
        //self.metalViewControllerDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*func renderObjects(drawable: CAMetalDrawable) {
        renderer.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
    }*/
    
    /*func updateObjectScale(newSize: CGSize) {
        renderer.updateScale(newSize: newSize)
    }*/
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        // NO-OP
    }
}
