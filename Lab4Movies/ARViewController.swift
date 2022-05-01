//
//  ARViewController.swift
//  Lab4Movies
//
//  Created by Aaron Butler on 10/23/19.
//  Copyright © 2019 Aaron Butler. All rights reserved.
//
//https://mobile-ar.reality.news/how-to/arkit-101-place-2d-images-like-painting-photo-wall-augmented-reality-0187598/
import UIKit
import SceneKit
import ARKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var grids = [Grid]()
    var image: UIImage!
    var placed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        //sceneView.showsStatistics = true
        
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .vertical
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if placed == false {
            guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
            let grid = Grid(anchor: planeAnchor)
            self.grids.append(grid)
            node.addChildNode(grid)
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if placed == false {
            guard let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .vertical else { return }
            let grid = self.grids.filter { grid in
                return grid.anchor.identifier == planeAnchor.identifier
                }.first
            
            guard let foundGrid = grid else {
                return
            }
            
            foundGrid.update(anchor: planeAnchor)
        }
    }
    @objc func tapped(gesture: UITapGestureRecognizer) {
        print(placed)
        if placed == false {
            // Get 2D position of touch event on screen
            let touchPosition = gesture.location(in: sceneView)
            
            // Translate those 2D points to 3D points using hitTest (existing plane)
            let hitTestResults = sceneView.hitTest(touchPosition, types: .existingPlaneUsingExtent)
            
            // Get hitTest results and ensure that the hitTest corresponds to a grid that has been placed on a wall
            guard let hitTest = hitTestResults.first, let anchor = hitTest.anchor as? ARPlaneAnchor, let gridIndex = grids.firstIndex(where: { $0.anchor == anchor }) else {
                return
            }
            addPainting(hitTest, grids[gridIndex])
        }
        
    }
    func addPainting(_ hitResult: ARHitTestResult, _ grid: Grid) {
        placed = true
        self.sceneView.debugOptions = []
        // 1.
        let planeGeometry = SCNPlane(width: 0.5, height: 0.78)
        let material = SCNMaterial()
        material.diffuse.contents = image
        planeGeometry.materials = [material]
        
        // 2.
        let paintingNode = SCNNode(geometry: planeGeometry)
        paintingNode.transform = SCNMatrix4(hitResult.anchor!.transform)
        paintingNode.eulerAngles = SCNVector3(paintingNode.eulerAngles.x + (-Float.pi / 2), paintingNode.eulerAngles.y, paintingNode.eulerAngles.z)
        paintingNode.position = SCNVector3(hitResult.worldTransform.columns.3.x, hitResult.worldTransform.columns.3.y, hitResult.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(paintingNode)
        grid.removeFromParentNode()
        grids = []
        //https://stackoverflow.com/questions/28738551/how-can-i-remove-all-nodes-from-a-scenekit-scene
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            if node.physicsBody?.type == .static {
                node.removeFromParentNode()
            }
        }
    }
    @IBAction func share(_ sender: Any) {
//        let imageRenderer = UIGraphicsImageRenderer(size: sceneView.bounds.size)
//        let picToShare = imageRenderer.image { ctx in
//            sceneView.drawHierarchy(in: sceneView.bounds, afterScreenUpdates: true)
//        }
       //self.sceneView.debugOptions = []
        sceneView.debugOptions.remove(ARSCNDebugOptions.showFeaturePoints)
        
        //https://stackoverflow.com/questions/46011724/how-do-you-screenshot-an-arkit-camera-view
       
        let picToShare = sceneView.snapshot()
        let activity = UIActivityViewController(activityItems: [picToShare], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
    }
    @IBAction func clear(_ sender: Any) {
        placed = false
        grids = []
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
    }
    
}
