//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit

public extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == 1 || contact.bodyB.categoryBitMask == 1 {
            
            guard let rocket = childNode(withName: "rocket") as? Rocket else {
                //print("[FAILURE] Did not find rocket!")
                return
            }
            
            guard let flightPath = childNode(withName: "flightPath") as? FlightPath else {
                //print("[FAILURE] Did not find flightPath!")
                return
            }
            
            removeChildren(in: [rocket, flightPath])
            
            let explosion = SKSpriteNode(imageNamed: "explosion")
            explosion.position = contact.contactPoint
            explosion.size = CGSize(width: 20, height: 20)
            
            addChild(explosion)
            
            makeExplosionAction()
            explosion.run(explosionAction!)
            
            if scoreSystem!.score > scoreSystem!.bestScore {
                scoreSystem!.bestScore = scoreSystem!.score
            }
            
            currentGameState = .gameover
            
            self.run(SKAction.wait(forDuration: 1), completion: gsGameOver)
        }
    }
    
}
