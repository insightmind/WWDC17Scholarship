//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit
import CoreGraphics

public extension GameScene {
    //method when the view is clicked or touched
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //finding out the location and the connected node of the touch
        let touch = touches.first
        guard let locationOfTouch = touch?.location(in: self) else {
            //print("[FAILURE] Location of touch could not be found")
            return
        }
        
        //check the currentGameState for appropriate actions
        switch currentGameState {
            
        case .menu:
            
            guard let selectedNodeInScene = self.nodes(at: locationOfTouch).first else {
                //print("[FAILURE] Could not find node at specific location of touch")
                //print(locationOfTouch)
                return
            }
            
            //find out if the touched node is the launchLabel, if that is the case
            //run the countDownAction followed by fadOutAction
            //and change the current GameState to LAUNCH followed by PLAY
            if selectedNodeInScene.name == "menu.launchbutton" {
                
                launchOff()
                
            } else if selectedNodeInScene.name == "settings" {
                
                removeAllActions()
                removeAllChildren()
                
                gsSettings()
            }
            break
            
        case .play:
            
            if locationOfTouch.y > (camera!.position.y) {
                applyForce = .increase((locationOfTouch.x - 200) / 100)
            } else {
                applyForce = .decrease
            }
            
            guard let selectedNodeInScene = self.nodes(at: locationOfTouch).first else {
                //print("[FAILURE] Could not find node at specific location of touch")
                return
            }
            
            if selectedNodeInScene.name == "pause" {
                
                gsPause()
            }
            
            break
            
        case .settings:
            guard let selectedNodeInScene = self.nodes(at: locationOfTouch).first else {
                //print("[FAILURE] Could not find node at specific location of touch")
                return
            }
            
            if selectedNodeInScene.name == "showGravityButton" {
                guard let node = selectedNodeInScene as? SKSpriteNode else {
                    //print("[FAILURE] Selected node is not an SKSpriteNode!")
                    return
                }
                
                if settings!.showGravity {
                    node.texture = SKTexture(imageNamed: "unchecked")
                    settings!.showGravity = false
                } else {
                    node.texture = SKTexture(imageNamed: "checked")
                    settings!.showGravity = true
                }
            } else if selectedNodeInScene.name == "close" {
                
                let gameScene = GameScene(size: frame.size, prevScoreSystem: scoreSystem, prevSettings: settings)
                self.view?.presentScene(gameScene)
                
            }
            
            break
            
        case .pause:
            
            guard let selectedNodeInScene = self.nodes(at: locationOfTouch).first else {
                //print("[FAILURE] Could not find node at specific location of touch")
                return
            }
            
            if selectedNodeInScene.name == "pause" {
                gsDePause()
            } else if selectedNodeInScene.name == "restart" {
                
                let transition = SKTransition.fade(withDuration: 1.0)
                let gameScene = GameScene(size: frame.size, prevScoreSystem: scoreSystem, prevSettings: settings)
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
            break
            
        case .gameover:
            
            guard let selectedNodeInScene = self.nodes(at: locationOfTouch).first else {
                //print("[FAILURE] Could not find node at specific location of touch")
                return
            }
            
            if selectedNodeInScene.name == "restart" {
                
                let transition = SKTransition.fade(withDuration: 1.0)
                let gameScene = GameScene(size: frame.size, prevScoreSystem: scoreSystem, prevSettings: settings)
                self.view?.presentScene(gameScene, transition: transition)
                
            }
            
        default:
            break
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        switch currentGameState {
        case .play:
            
            //finding out the location and the connected node of the touch
            let touch = touches.first
            guard let locationOfTouch = touch?.location(in: self) else {
                //print("[FAILURE] Location of touch could not be found")
                return
            }
            if locationOfTouch.y > (camera!.position.y) {
                applyForce = .increase((locationOfTouch.x - 200) / 100)
            } else {
                applyForce = .decrease
            }
            break
        default:
            break
        }
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        applyForce = .none
    }
}
