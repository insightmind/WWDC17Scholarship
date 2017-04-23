//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit
import CoreGraphics

public extension GameScene {
    
    func gsForPlay(_ node: Rocket) {
        
        let scoreLabel = gsLabel(initText: "0", name: "score")
        scoreLabel.fontSize = 70
        scoreLabel.position = CGPoint(x: -225, y: 1500)
        
        guard let spLegacy = childNode(withName: "settings") as? SKSpriteNode else {
            //print("[FAILURE] did not find SettingsButton")
            return
        }
        
        removeChildren(in: [spLegacy])
        
        let spButton = gsIcon(image: "pause")
        spButton.position = CGPoint(x: 600, y: 1600)
        
        addChilds([scoreLabel, spButton])
    }
    
}
