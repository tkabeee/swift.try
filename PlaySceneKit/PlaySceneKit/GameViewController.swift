//
//  GameViewController.swift
//  PlaySceneKit
//
//  Created by Takayuki Kondo on 2/27/16.
//  Copyright (c) 2016 tkabeee. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  
    // シーン生成
    let scene = SCNScene()
  
    // カメラ設置
    let cameraNode = SCNNode()
    cameraNode.camera = SCNCamera()
    cameraNode.position = SCNVector3Make(0, 50, 30)
    cameraNode.rotation = SCNVector4Make(1, 0, 0, -0.9)
    scene.rootNode.addChildNode(cameraNode)
  
    // 光源設置
    let ambientLightNode = SCNNode()
    ambientLightNode.light = SCNLight()
    ambientLightNode.light!.type = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor.lightGrayColor()
    scene.rootNode.addChildNode(ambientLightNode)
  
    // 影をつける光源設定
    let lightNode = SCNNode()
    lightNode.light = SCNLight()
    lightNode.light!.type = SCNLightTypeSpot
    lightNode.light!.color = UIColor.whiteColor()
    lightNode.light!.spotOuterAngle = 180
    lightNode.light!.castsShadow = true
    lightNode.position = SCNVector3Make(0, 50, 0)
    lightNode.rotation = SCNVector4Make(1, 0, 0, Float(M_PI_2))
    lightNode.name = "spotLight"
    scene.rootNode.addChildNode(lightNode)
  
    // 床の設置と当たり判定の設定
  
  
    // retrieve the SCNView
    let scnView = self.view as! SCNView
  
    // set the scene to the view
    scnView.scene = scene
  
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1.0)
  
    // add a tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
    scnView.addGestureRecognizer(tapGesture)
  }
  
  func handleTap(gestureRecognize: UIGestureRecognizer) {
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // check what nodes are tapped
    let p = gestureRecognize.locationInView(scnView)
    let hitResults = scnView.hitTest(p, options: nil)

    // check that we clicked on at least one object
    if hitResults.count > 0 {
      // retrieved the first clicked object
      let result: AnyObject! = hitResults[0]
      
      // get its material
      let material = result.node!.geometry!.firstMaterial!
      
      // highlight it
      SCNTransaction.begin()
      SCNTransaction.setAnimationDuration(0.5)
      
      // on completion - unhighlight
      SCNTransaction.setCompletionBlock {
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)
        
        material.emission.contents = UIColor.blackColor()
        
        SCNTransaction.commit()
      }
      
      material.emission.contents = UIColor.redColor()
      
      SCNTransaction.commit()
    }
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
