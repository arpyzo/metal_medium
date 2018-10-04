//
//  ViewController.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 2/2/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import Metal
import MetalKit

class ViewController: UIViewController {
    var metalDevice: MTLDevice!
    //var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var textureLoader: MTKTextureLoader!
    //var timer: CADisplayLink!
    
    var texture: MTLTexture!
    var objectToDraw: Rectangle!
    
    @IBOutlet weak var mtkView: MTKView! {
        didSet {
            mtkView.delegate = self
            mtkView.preferredFramesPerSecond = 60
            mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        metalDevice = MTLCreateSystemDefaultDevice()
        mtkView.device = metalDevice
        //metalLayer = CAMetalLayer()
        //metalLayer.device = metalDevice
        //metalLayer.frame = view.layer.frame // OLD CODE
        //view.layer.addSublayer(metalLayer)
        
        textureLoader = MTKTextureLoader(device: metalDevice)
        
        //let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        //let data = NSData(contentsOfFile: path) as! Data
        //let texture = try! textureLoader.newTexture(with: data, options: [MTKTextureLoaderOptionSRGB : (false as NSNumber)])
        //texture = try! textureLoader.newTexture(name: "zelda.png", scaleFactor: 1.0, bundle: Bundle.main, options: [MTKTextureLoader.Option.SRGB : (false as NSNumber)])
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")
        //let textureLoader = MTKTextureLoader(device: device!)
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path!) as URL, options: nil)

        //newTexture(name: "zelda.png", scaleFactor: CGFloat, bundle: Bundle?, options: [MTKTextureLoader.Option : Any]? = nil)


        objectToDraw = Rectangle(metalDevice: metalDevice)
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        let metalLibrary = metalDevice.makeDefaultLibrary()!
        pipelineStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        //timer = CADisplayLink(target: self, selector: #selector(ViewController.gameLoop))
        //timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    /*override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let window = view.window {
            let scale = window.screen.nativeScale
            let layerSize = view.bounds.size
            //2
            view.contentScaleFactor = scale
            metalLayer.frame = CGRect(x: 0, y: 0, width: layerSize.width, height: layerSize.height)
            metalLayer.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
            
            //projectionMatrix = Matrix4.makePerspectiveViewAngle(Matrix4.degrees(toRad: 85.0), aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height), nearZ: 0.01, farZ: 100.0)

        }
    }*/

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
        //objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable)
    }*/
    
    func render(_ drawable: CAMetalDrawable?) {
        guard let drawable = drawable else { return }
        //self.metalViewControllerDelegate?.renderObjects(drawable)
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
    }


    /*@objc func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }*/

}
// MARK: - MTKViewDelegate
extension ViewController: MTKViewDelegate {
    
    // 1
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        if let window = view.window {
            let scale = window.screen.nativeScale
            //let layerSize = view.bounds.size
            view.contentScaleFactor = scale
            //view.drawableSize = CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
        }
        //currentDrawable.drawableSize = CGSize(width: 1.0, height: 1.0)
        //CGSize(width: layerSize.width * scale, height: layerSize.height * scale)
    }
 /*    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        projectionMatrix = float4x4.makePerspectiveViewAngle(float4x4.degrees(toRad: 85.0),
                                                             aspectRatio: Float(self.view.bounds.size.width / self.view.bounds.size.height),
                                                             nearZ: 0.01, farZ: 100.0)
    }*/
    
    // 2
    func draw(in view: MTKView) {
        render(view.currentDrawable)
    }
    
}
