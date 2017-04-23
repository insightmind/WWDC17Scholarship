//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import CoreGraphics
import SpriteKit

public class ScoreSystem {
    
    var bestScore = 0
    var score = 0
    var nextScoreHeight: [CGFloat] = [2000]
    
    public func updateScore(_ position: CGPoint, scoreNode: SKLabelNode) {
        if nextScoreHeight[0] < position.y {
            score += 1
            scoreNode.text = String(score)
            nextScoreHeight.remove(at: 0)
        }
    }
    
    public func addNextScoreHeight(_ height: CGFloat) {
        nextScoreHeight.append(height)
    }
}
