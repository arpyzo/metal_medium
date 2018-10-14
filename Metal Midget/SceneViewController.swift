//
//  SceneViewController.swift
//  Metal Midget
//
//  Created by Robert Pyzalski on 10/14/18.
//  Copyright © 2018 Robert Pyzalski. All rights reserved.
//

import UIKit
import simd

class SceneViewController: MetalViewController, MetalViewControllerDelegate {
    var texture: MTLTexture!
    var objectToDraw: Rectangle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let path = Bundle.main.path(forResource: "zelda", ofType: "png")!
        //let data = NSData(contentsOfFile: path) as! Data
        //let texture = try! textureLoader.newTexture(with: data, options: [MTKTextureLoaderOptionSRGB : (false as NSNumber)])
        //texture = try! textureLoader.newTexture(name: "zelda.png", scaleFactor: 1.0, bundle: Bundle.main, options: [MTKTextureLoader.Option.SRGB : (false as NSNumber)])
        //let textureLoader = MTKTextureLoader(device: device!)
        texture = try! textureLoader.newTexture(URL: NSURL(fileURLWithPath: path) as URL, options: nil)
        
        //newTexture(name: "zelda.png", scaleFactor: CGFloat, bundle: Bundle?, options: [MTKTextureLoader.Option : Any]? = nil)
        
        objectToDraw = Rectangle(metalDevice: metalDevice)
        self.metalViewControllerDelegate = self
    }
    
    //MetalViewControllerDelegate calls this:
    func renderObjects(drawable:CAMetalDrawable) {
        
        objectToDraw.render(commandQueue: commandQueue, pipelineState: pipelineState, drawable: drawable, texture: texture)
        
    }
    //MetalViewControllerDelegate calls this:

    func updateObjectScale(newSize: CGSize) {
        objectToDraw.updateScale(scale: Float(newSize.height / newSize.width))
    }
    
    func updateLogic(timeSinceLastUpdate: CFTimeInterval) {
        // NO-OP
    }
}
