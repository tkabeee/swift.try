//
//  GameViewController.swift
//  TestGameSceneKit
//
//  Created by Takayuki Kondo on 2/15/16.
//  Copyright (c) 2016 tkabeee. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    // create a new scene
    let scene = SCNScene(named: "art.scnassets/ship.scn")!

    // create and add a camera to the scene
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    scene.rootNode.addChildNode(cameraNode)

    // place the camera
    cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)

    // create and add a light to the scene
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light!.type = SCNLightTypeOmni
    lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
    scene.rootNode.addChildNode(lightNode)

    // create and add an ambient light to the scene
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor.darkGrayColor()
    scene.rootNode.addChildNode(ambientLightNode)

    // retrieve the ship node
    let ship = scene.rootNode.childNodeWithName("ship", recursively: true)!
    
    // ship node rotation
    ship.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
    
    // animate the 3d object
//    ship.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))

    // Stars Particle
    let stars = SCNParticleSystem(named: "stars.scnp", inDirectory: "")!
    scene.rootNode.addParticleSystem(stars)
    
    // retrieve the SCNView
    let scnView = self.view as! SCNView

    // set the scene to the view
    scnView.scene = scene

    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true

    // show statistics such as fps and timing information
    scnView.showsStatistics = true

    // configure the view
    scnView.backgroundColor = UIColor.blackColor()

    // add a tap gesture recognizer
//    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
//    scnView.addGestureRecognizer(tapGesture)
  }
  
  func handleTap(gestureRecognize: UIGestureRecognizer) {
  }
    
  override func shouldAutorotate() -> Bool {
    return true
  }

  override func prefersStatusBarHidden() -> Bool {
    return true
  }
    
  override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
    if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
      return .AllButUpsideDown
    } else {
      return .All
    }
  }
    
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Release any cached data, images, etc that aren't in use.
  }

}
