//
//  ViewController.swift
//  ARFirstGame
//
//  Created by larvataAndroid on 2018/8/20.
//  Copyright © 2018年 junzhenIOS. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var firstBox : SCNNode?
    var secondBox : SCNNode?
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var targetView: UIView!
    @IBOutlet weak var measurementLabel: UILabel!
    @IBOutlet weak var setButton: UIButton!
    @IBAction func setPointButton(_ sender: UIButton) {
        
        if firstBox == nil {
            
            firstBox = addBox()
            if firstBox != nil {
            setButton.setTitle("Set End Point", for: .normal)
            }
            
        } else if secondBox == nil {
            secondBox = addBox()
            if secondBox != nil {
                calculationDistance()
                setButton.setTitle("Reset", for: .normal)

            }
        }else{
            firstBox?.removeFromParentNode()
            secondBox?.removeFromParentNode()
            firstBox = nil
            secondBox = nil
            measurementLabel.text = ""
            setButton.setTitle("Set Start Point", for: .normal)
        }
        
        
        
    }
    func calculationDistance() {

        if let firstBox = firstBox{
            if let secondBox = secondBox{
                let vector = SCNVector3Make(secondBox.position.x - firstBox.position.x, secondBox.position.y - firstBox.position.y, secondBox.position.z - firstBox.position.z)
                let distance = sqrt(vector.x * vector.x + vector.y * vector.y + vector.z * vector.z)
                measurementLabel.text = "\(distance)m"
            }
        }
        
                
            
        
    }
    func addBox() -> SCNNode? {
        let userTouch = sceneView.center
        let testResult = sceneView.hitTest(userTouch, types: .featurePoint)
        
        if let theResult = testResult.first{
            
            let box = SCNBox(width: 0.005, height: 0.005, length: 0.005, chamferRadius: 0.005)
            
            let meterial = SCNMaterial()
            box.firstMaterial = meterial
            
            let boxNode = SCNNode(geometry: box)
            boxNode.position = SCNVector3(theResult.worldTransform.columns.3.x,theResult.worldTransform.columns.3.y,theResult.worldTransform.columns.3.z)
            sceneView.scene.rootNode.addChildNode(boxNode)
            return boxNode
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        for node in sceneView.scene.rootNode.childNodes {
            let moveShips = SCNAction.moveBy(x: 0, y: -0.5, z: 0, duration: 2)
            let fadeOut = SCNAction.fadeOpacity(by: 0.5, duration: 1)
            let fadeIn =  SCNAction.fadeOpacity(by: 1, duration: 1)
            let routine = SCNAction.sequence([moveShips,fadeOut,fadeIn])
            let foreverRoutine = SCNAction.repeatForever(routine)
            
            node.runAction(foreverRoutine)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        //
    }
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        //
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
