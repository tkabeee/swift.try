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
    let cameraNode          = SCNNode()
    cameraNode.camera       = SCNCamera()
//    cameraNode.position     = SCNVector3Make(0, 50, 30)
    cameraNode.position     = SCNVector3Make(0, 18, 20)
//    cameraNode.rotation     = SCNVector4Make(1, 0, 0, -0.9)
    cameraNode.rotation     = SCNVector4Make(1, 0, 0, -0.4)
    cameraNode.camera?.zFar = 300.0
    
    scene.rootNode.addChildNode(cameraNode)
  
    // 光源設置
    let ambientLightNode          = SCNNode()
    ambientLightNode.light        = SCNLight()
    ambientLightNode.light!.type  = SCNLightTypeAmbient
    ambientLightNode.light!.color = UIColor.lightGrayColor()

    scene.rootNode.addChildNode(ambientLightNode)
  
    // 影をつける光源設定
    let lightNode                   = SCNNode()
    lightNode.light                 = SCNLight()
    lightNode.light!.type           = SCNLightTypeSpot
    lightNode.light!.color          = UIColor.whiteColor()
    lightNode.light!.spotOuterAngle = 180
    lightNode.light!.castsShadow    = true
    lightNode.position              = SCNVector3Make(0, 50, 0)
    lightNode.rotation              = SCNVector4Make(1, 0, 0, -Float(M_PI_2))
    lightNode.name                  = "spotLight"

    scene.rootNode.addChildNode(lightNode)
  
    // 床の設置
    let floorGround = SCNFloor()
    floorGround.firstMaterial?.diffuse.contents = UIColor.orangeColor()
    
    let floorNode      = SCNNode()
    floorNode.geometry = floorGround
    floorNode.position = SCNVector3Make(0, 0, 0)
    floorNode.name     = "groundFloor"
    
    // 床への物体の当たり判定
    floorNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Static, shape: nil)
    
    scene.rootNode.addChildNode(floorNode)
    
    // 物体を発生
    let generatorSphere = SCNSphere(radius: 4.0)
    generatorSphere.firstMaterial?.diffuse.contents = UIColor(red: 0.3, green: 0.3, blue: 1, alpha: 0.7)
    
    let generatorNode         = SCNNode()
    generatorNode.geometry    = generatorSphere
    generatorNode.position    = SCNVector3Make(0, 32, 0)
    generatorNode.name        = "generatorSphere"
    generatorNode.castsShadow = false
    
    scene.rootNode.addChildNode(generatorNode)
    
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = true
    
    // show statistics such as fps and timing information
    scnView.showsStatistics = true
    
    // configure the view
    scnView.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
  
    // add a tap gesture recognizer
    let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
    scnView.addGestureRecognizer(tapGesture)

    // set the scene to the view
    scnView.scene = scene
  }
  
  func handleTap(gestureRecognize: UIGestureRecognizer) {
    // retrieve the SCNView
    let scnView = self.view as! SCNView
    
    // check what nodes are tapped
    let p = gestureRecognize.locationInView(scnView)
    let hitResults = scnView.hitTest(p, options: nil)

    // check that we clicked on at least one object
    if (hitResults.count > 0) {
      // retrieved the first clicked object
      let result: AnyObject! = hitResults[0]
      
      // get its material
      let material = result.node!.geometry!.firstMaterial!
      
      // 球体タップ判定
      let hitResultNode = result.node
      
      if (hitResultNode.name == "generatorSphere") {
        
        // カラー設定
        let hitResultDefColor = material.emission.contents

        // highlight it
        SCNTransaction.begin()
        SCNTransaction.setAnimationDuration(0.5)

        // on completion - unhighlight
        SCNTransaction.setCompletionBlock {
          SCNTransaction.begin()
          SCNTransaction.setAnimationDuration(0.5)
          
          material.emission.contents = hitResultDefColor
          
          SCNTransaction.commit()
        }
        
        material.emission.contents = UIColor.redColor()
        
        SCNTransaction.commit()
        
        // 新しい物体を生成
        self.createAnyGeometry()
        
      } else if (hitResultNode.name == "anyGeometry") {
        
        NSLog("remove: anyGeometry")
        
        // 物体のカラーを変更する
        material.emission.contents = UIColor.redColor()
        
        // 物体を削除する
        hitResultNode.runAction(SCNAction.sequence([SCNAction.fadeInWithDuration(0.2),SCNAction.removeFromParentNode()]))
        
      } else if (hitResultNode.name == "groundFloor") {

        // 戦闘機を表示
        self.removeStarFighterNode()
        self.createStarFighterNode()

      }
    }
  }
  
  func createAnyGeometry() {

    let rand_num = arc4random_uniform(5)

    // create New Geometry
    var geometry = SCNGeometry()

    // ランダムで形状を決定する
    switch (rand_num) {
      case 0:
        geometry = SCNPyramid(width: 4.5, height: 4.5, length: 4.5)
        break

      case 1:
        geometry = SCNCylinder(radius: 2.0, height: 3.5)
        break

      case 2:
        geometry = SCNSphere(radius: 2.0)
        break

      case 3:
        geometry = SCNTorus(ringRadius: 2.5, pipeRadius: 1.0)
        break

      case 4:
        geometry = SCNBox(width: 4.5, height: 4.5, length: 4.5, chamferRadius: 0.0)
      
      default:
        geometry = SCNBox(width: 3.0, height: 3.0, length: 3.0, chamferRadius: 1.0)
        break
    }
    
    // ランダムで色を決定
    geometry.firstMaterial?.diffuse.contents = UIColor(red: self.randomColorNumber(), green: self.randomColorNumber(), blue: self.randomColorNumber(), alpha: 1.0)
    
    // 形状の設定
    let geometryNode = SCNNode(geometry: geometry)
    geometryNode.position = SCNVector3Make(0.0, 30.0, 0.0)
    geometryNode.name = "anyGeometry"
    
    // 重力の設定
    geometryNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: nil)
    
    // シーンに追加
    let scnView = self.view as! SCNView
    scnView.scene!.rootNode.addChildNode(geometryNode)
  }
  
  func randomColorNumber()-> CGFloat {
    let color_number: Double = Double(arc4random_uniform(100))
    return CGFloat(color_number / 200.0 + 0.5)
  }
  
  func createStarFighterNode() {

    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    let starFighterNode = scene.rootNode.childNodeWithName("ship", recursively: true)!

    // モデルの初期設定
    starFighterNode.position = SCNVector3Make(0.0, 10.0, 0.0)
    starFighterNode.rotation = SCNVector4Make(0, 1, 0, Float(M_PI))
    starFighterNode.name     = "shipMesh"
    
    // モデルに重力を追加
    starFighterNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Dynamic, shape: nil)
    
    // シーンに追加
    let scnView = self.view as! SCNView
    scnView.scene!.rootNode.addChildNode(starFighterNode)
  }
  
  func removeStarFighterNode() {

    let scnView = self.view as! SCNView

    // Sceneに存在していたら削除
    if let starFighterNode = scnView.scene!.rootNode.childNodeWithName("shipMesh", recursively: true) {
      
      starFighterNode.removeFromParentNode()
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
