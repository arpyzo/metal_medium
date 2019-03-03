import UIKit
import Metal
import MetalKit

protocol MetalViewControllerDelegate: class {
    func updateLogic(timeSinceLastUpdate: CFTimeInterval)
    func renderObjects(drawable: CAMetalDrawable)
    func updateObjectScale(newSize: CGSize)
}

class MetalViewController: UIViewController {
    var metalDevice: MTLDevice!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    
    weak var metalViewControllerDelegate: MetalViewControllerDelegate?
    
    @IBOutlet weak var mtkView: MTKView! {
        didSet {
            mtkView.delegate = self
            mtkView.preferredFramesPerSecond = 60
            mtkView.clearColor = MTLClearColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        metalDevice = MTLCreateSystemDefaultDevice()
        let metalLibrary = metalDevice.makeDefaultLibrary()!

        mtkView.device = metalDevice
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render(_ drawable: CAMetalDrawable?) {
        guard let drawable = drawable else { return }
        self.metalViewControllerDelegate?.renderObjects(drawable: drawable)
    }
}

// MARK: - MTKViewDelegate
extension MetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.metalViewControllerDelegate?.updateObjectScale(newSize: size)
        //if let window = view.window {
            //let scale = window.screen.nativeScale
            //let layerSize = view.bounds.size
            //view.contentScaleFactor = scale
            //view.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
        //}
        //currentDrawable.drawableSize = CGSize(width: 1.0, height: 1.0)
        //CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
    }
 /*    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0),
                                                             aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height),
                                                             nearZ: 0.01, farZ: 100.0)
    }*/
    
    func draw(in view: MTKView) {
        render(view.currentDrawable)
    }
    
}
