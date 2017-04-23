//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit
import Foundation

public extension GameScene {
    
    func updateCamPosition(_ view: SKView) {
        cam = SKCameraNode()
        cam.zPosition = -10
        self.camera = cam
        self.addChild(cam)
        cam.position = CGPoint(x: view.frame.width / 2, y: view.frame.height / 2)
    }
    
    func deleteOldNodes(_ position: CGPoint) {
        var remChilds = [SKNode]()
        for i in 0..<(children.count - 1) {
            if children[i].name == nil{
                if children[i].position.y < (position.y - 2000) {
                    remChilds.append(children[i])
                }
            }
        }
        removeChildren(in: remChilds)
    }
    
    func playCountDown(_ node: SKLabelNode) {
        makeCountdownAction(node)
        var actionSequence = [SKAction]()
        actionSequence.append(countdownAction!)
        actionSequence.append(SKAction.fadeOut(withDuration: 0))
        let action = SKAction.sequence(actionSequence)
        node.run(action)
    }
    
    func addChilds(_ nodes: [SKNode]) {
        for i in nodes {
            addChild(i)
        }
    }
    
    func launchOff() {
        guard let title = self.childNode(withName: "menu.launchbutton") as? SKLabelNode else {
            //print("[FAILURE] Selected node is not an SKLabelNode FC: .tB.menu.if")
            return
        }
        
        guard let rocket = self.childNode(withName: "rocket") as? Rocket else {
            //print("[FAILURE] Did not find rocket! .sc.tB.play.rocket")
            return
        }
        
        guard let titlePic = childNode(withName: "title") as? SKSpriteNode else {
            //print("[FAILURE] Did not find titlePic!")
            return
        }
        
        makeDissolveAction()
        titlePic.run(dissolveAction!)
        
        currentGameState = .launch
        
        playCountDown(title)
        
        let scaleFactor: CGFloat = 2.5
        let zoomOutAction = SKAction.scale(to: scaleFactor, duration: 10)
        self.camera?.run(zoomOutAction)
        
        title.text = "LAUNCH"
        
        gsForPlay(rocket)
    }
}

