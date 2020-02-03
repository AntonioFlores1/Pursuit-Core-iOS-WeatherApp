//
//  ARKitViewController.swift
//  WeatherApp
//
//  Created by antonio  on 2/1/20.
//  Copyright © 2020 Pursuit. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ARKitViewController: UIViewController,ARSCNViewDelegate,ARSessionDelegate  {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    
        var trackerNode: SCNNode!
        var Gamestarted = false
        var foundaSurface = false
        var trackingForArenaPosition = SCNVector3Make(0.0, 0.0, 0.0)
        
    ///Maps
       var arenaNode: SCNNode!
       var soldierNode: SCNNode!
       var cloudNode: SCNNode!
   
       override func viewDidLoad() {
                super.viewDidLoad()
                let scene = SCNScene()
        
        
//        let cameraNode = SCNNode()
//           cameraNode.camera = SCNCamera()
//           cameraNode.position = SCNVector3(x: 0, y: 0, z: 30)
//           scene.rootNode.addChildNode(cameraNode)
        
        
        
        
                sceneView.scene = scene
                sceneView.delegate = self
//                scene.rootNode.scale = SCNVector3(0.001,0.001,0.001)
//        scene.rootNode.position = SCNVector3Make(0,20,-80)
//                scene.position =
//.eulerAngles = SCNVector3Make(-300, -300, -300)
            }
  
    func createTrail(color: UIColor, geometry: SCNGeometry) -> SCNParticleSystem {
        let scene = SCNScene(named: "GeometryFighter.scnassets/Scenes/Trail.scn")
        let node:SCNNode = (scene?.rootNode.childNode(withName: "Trail", recursively: true)!)!
        let particleSystem:SCNParticleSystem = (node.particleSystems?.first)!
        particleSystem.particleColor = color
        particleSystem.emitterShape = geometry
        return particleSystem
    }
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                sceneView.session.delegate = self
                let configuration = ARWorldTrackingConfiguration()
                sceneView.session.run(configuration)
            }
            
            override func viewWillDisappear(_ animated: Bool) {
                super.viewWillDisappear(animated)
                sceneView.session.pause()
            }


            override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

                
                if Gamestarted {
               
                    
                } else {

                    guard let safeUnwrap = trackerNode else {return}
                    safeUnwrap.removeFromParentNode()
                    Gamestarted = true
                    
                    
//                    guard let arena = sceneView.scene.rootNode.childNode(withName: "Miami 2525.scn", recursively: false) else {return}
//                    arenaNode = arena
//                    arenaNode.position = SCNVector3Make(trackingForArenaPosition.x, trackingForArenaPosition.y, trackingForArenaPosition.z)
//                    let arenaRotate = SCNAction.rotateBy(x: 0, y: 0, z: 0, duration: 0)
                    
                    let soldierScene = SCNScene(named: "Miami 2525.scn")!

                    
                    soldierNode = soldierScene.rootNode
                    soldierNode.position = SCNVector3Make(trackingForArenaPosition.x, trackingForArenaPosition.y, trackingForArenaPosition.z)
                    soldierNode.scale = SCNVector3(1,1,1)
                    sceneView.scene.rootNode.addChildNode(soldierNode)
  

                       let ambientLightNode = SCNNode()
                       ambientLightNode.light = SCNLight()
                       ambientLightNode.light!.type = .ambient
                       ambientLightNode.light!.color = UIColor.darkGray
                      sceneView.scene.rootNode.addChildNode(ambientLightNode)
                    
                       let particles = SCNParticleSystem.init()
                    
                       particles.emittingDirection = SCNVector3.init(0, 1, 0)
                       particles.birthRate = 4000
//                    particles.orientationMode = .free
                       particles.emissionDuration = 0.1
                       particles.spreadingAngle = 1
//                    particles.blendMode = SCNParticleBlendMode.additive
                       particles.particleDiesOnCollision = false
                       particles.particleLifeSpan = 3
                       particles.particleVelocity = 10
                       particles.particleSize = 1
                       particles.particleColor = UIColor.white.withAlphaComponent(0.01)
                    
                       let box = SCNNode.init(geometry: SCNBox.init(width: 1, height: 1, length: 1, chamferRadius: 0))
                       box.addParticleSystem(particles)
                       box.runAction(SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: 0, z: 2, duration: 2)))
                    box.position = SCNVector3Make(trackingForArenaPosition.x, trackingForArenaPosition.y + 40, trackingForArenaPosition.z)
                    sceneView.scene.rootNode.addChildNode(box)
//                    let particles = SKEmitterNode(fileNamed: "cloud.sks")
//
//                    addChild(particles)
//                    cloudNode = cloudScene
//                    cloudNode.position = CGPoint(x: 0, y: 90)
//
//
//                        CGPoint(trackingForArenaPosition.x, trackingForArenaPosition.y + 90, trackingForArenaPosition.z)
//                    print("we here")
//                    arenaNode.position = SCNVector3Make(0,20,-20)
                    
//                    soldierNode = soldierScene.rootNode
//                    soldierNode.position = SCNVector3Make(trackingForArenaPosition.x, trackingForArenaPosition.y, trackingForArenaPosition.z)
//                    soldierNode.scale = SCNVector3(1,1,1)
////                    soldierNode.isPaused = true
//                    sceneView.scene.rootNode.addChildNode(soldierNode)

                }
            }
            
            
            
            func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
                guard !Gamestarted else {return}
                
                guard let hitTest = sceneView.hitTest(CGPoint(x: view.frame.midX, y: view.frame.midX), types: [.existingPlane,.featurePoint,.estimatedHorizontalPlane]).first else {return}
                
                let trans = SCNMatrix4(hitTest.worldTransform)
                trackingForArenaPosition = SCNVector3Make(trans.m41, trans.m42, trans.m43)
                
                if !foundaSurface {
                    let trackerPlane = SCNPlane(width: 0.15, height: 0.15)
                    trackerPlane.firstMaterial?.diffuse.contents = UIImage.init(named: "placer")
                    trackerPlane.firstMaterial?.isDoubleSided =  true
                    trackerNode = SCNNode(geometry: trackerPlane)
                    trackerNode.eulerAngles.x = -.pi * 0.5
                    sceneView.scene.rootNode.addChildNode(trackerNode)
                    foundaSurface = true
                }
                
                trackerNode.position = trackingForArenaPosition
            }
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            func session(_ session: ARSession, didFailWithError error: Error) {
                // Present an error message to the user
                
            }
            
            func sessionWasInterrupted(_ session: ARSession) {
                // Inform the user that the session has been interrupted, for example, by presenting an overlay
                
            }
            
            func sessionInterruptionEnded(_ session: ARSession) {
                // Reset tracking and/or remove existing anchors if consistent tracking is required
                
            }

}
