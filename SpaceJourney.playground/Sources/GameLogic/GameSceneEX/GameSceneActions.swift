//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit

extension GameScene {
    
    //configure CountDownAction for startTitle
    func makeCountdownAction(_ node: SKLabelNode, duration: TimeInterval = 1, scaleFactor: CGFloat = 1.36) {
        
        let sc = scaleFactor - 0.18 * (11 - CGFloat(self.launchCountDownNum))
        
        var actionSequence = [SKAction]()
        
        /* Action to change the text and the color of the node,
         * everytime the countdownAction is called:
         * text decreases from 10 to 0
         * color.redValue is increased by 0.1
         * when text was 0 then color is full red and text shows "GO"
         */
        let changeVal = SKAction.run {
            if self.launchCountDownNum > 0 {
                let gb: CGFloat = 1 - 0.1 * (10 - CGFloat(self.launchCountDownNum))
                node.fontColor = SKColor.init(red: 1 , green: gb, blue: gb, alpha: 1)
                node.text = String(self.launchCountDownNum)
                self.launchCountDownNum -= 1
            } else if self.launchCountDownNum == 0 {
                node.fontColor = .red
                node.text = "GO"
                
                self.currentGameState = .play
            }
        }
        
        /* initialize Actions:
         * scale text in first half of duration,
         * then fade it out in the last half of the duration
         * to get it back to normal undo both actions instantly
         */
        let scaleBig = SKAction.scale(by: sc, duration: duration / 2)
        let fadeOut = SKAction.fadeOut(withDuration: duration / 2)
        let fadeIn = SKAction.fadeIn(withDuration: 0)
        
        //append all previous initialized Actions in correct order ti the ActionSequence
        actionSequence.append(changeVal)
        actionSequence.append(scaleBig)
        actionSequence.append(fadeOut)
        actionSequence.append(fadeIn)
        
        //set countdownAction to the Action of the ActionSequence, which iterates 11 times
        countdownAction = SKAction.repeat(SKAction.sequence(actionSequence), count: 11)
        
    }
    
    func makeExplosionAction() {
        let explosion = SKAction.group([SKAction.scale(to: 50, duration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
            
        let sequence = SKAction.sequence([explosion, SKAction.removeFromParent()])
            
        explosionAction = sequence
    }
    
    func makeDissolveAction() {
        let dissolve = SKAction.group([SKAction.fadeOut(withDuration: 1)])
        
        let sequence = SKAction.sequence([dissolve, SKAction.removeFromParent()])
        
        dissolveAction = sequence
    }
    
}
