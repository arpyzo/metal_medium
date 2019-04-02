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
    }
    
    func draw(in view: MTKView) {
        render(view.currentDrawable)
    }
    
}
