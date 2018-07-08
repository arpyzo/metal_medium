//
//  ViewController.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 2/2/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import Metal

class ViewController: UIViewController {
    var metalDevice: MTLDevice!
    var metalLayer: CAMetalLayer!
    var pipelineState: MTLRenderPipelineState!
    var commandQueue: MTLCommandQueue!
    var timer: CADisplayLink!
    
    var objectToDraw: Triangle!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        metalDevice = MTLCreateSystemDefaultDevice()
        metalLayer = CAMetalLayer()
        metalLayer.device = metalDevice
        metalLayer.frame = view.layer.frame
        view.layer.addSublayer(metalLayer)

        objectToDraw = Triangle(metalDevice: metalDevice)
        
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        let metalLibrary = metalDevice.makeDefaultLibrary()!
        pipelineStateDescriptor.vertexFunction = metalLibrary.makeFunction(name: "basic_vertex")
        pipelineStateDescriptor.fragmentFunction = metalLibrary.makeFunction(name: "basic_fragment")
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineState = try! metalDevice.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        
        commandQueue = metalDevice.makeCommandQueue()
        
        timer = CADisplayLink(target: self, selector: #selector(ViewController.gameLoop))
        timer.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func render() {
        guard let drawable = metalLayer?.nextDrawable() else { return }
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, clearColor: nil)
    }

    @objc func gameLoop() {
        autoreleasepool {
            self.render()
        }
    }

}

