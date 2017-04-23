//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit
import CoreGraphics

public extension GameScene {
    
    func gsMainGame() {
        
        self.levelGenerator = LevelGenerator()
        self.physicsWorld.contactDelegate = self
        self.scaleMode = .resizeFill
        self.currentGameState = .menu
        scoreSystem!.score = 0
        self.backgroundColor = .clear
        
        //initialize startPlanet where the rocket stands on at launch
        let startPlanetPosition = CGPoint(x: size.width / 2, y: -((size.width / 2)  * 3 / 8))
        let startPlanet = Universe.createPlanet(position: startPlanetPosition, circleOfRadius: size.width, type: .earthlike(50), gravitySize: 0, withPhysics: false, settings: settings!)
        
        //initialize rocket as player
        let rocket = Rocket()
        rocket.position = CGPoint(x: size.width / 2, y: startPlanet.position.y + startPlanet.frame.height / 2 + 60)
        
        let flightPath = gsFlightPath()
        
        //initialize startLabel to start the game on tap
        let startTitle = gsLabel(initText: "LAUNCH", name: "menu.launchbutton")
        startTitle.position = CGPoint(x: size.width / 2, y: startTitle.frame.height - 10)
        
        let startPic = gsTitle()
        startPic.position = CGPoint(x: size.width / 2, y: 750)
        
        let spButton = gsIcon(image: "settings")
        spButton.position = CGPoint(x: 360, y: 900)
        
        
        //add all previously initialized nodes to the scene
        addChilds([startPlanet, startTitle, rocket, flightPath, startPic, spButton])
        
    }
    
    func gsSettings() {
        
        self.backgroundColor = .darkGray
        
        self.currentGameState = .settings
        
        let settingsLabel = gsLabel(initText: "Settings", name: "settingsLabel")
        settingsLabel.position = CGPoint(x: size.width / 2, y: 800)
        
        let closeButton = gsIcon(image: "close")
        closeButton.position = CGPoint(x: 360, y: 900)
        
        let showGravityNodes = gsLabel(initText: "show Gravity:", name: "showGravity", size: 20)
        showGravityNodes.position = CGPoint(x: size.width / 3, y: 700)
        
        let showGravityNodesButton = gsIcon(image: "close")
        if settings!.showGravity {
            showGravityNodesButton.texture = SKTexture(imageNamed: "checked")
        } else {
            showGravityNodesButton.texture = SKTexture(imageNamed: "unchecked")
        }
        showGravityNodesButton.name = "showGravityButton"
        showGravityNodesButton.size = CGSize(width: 30, height: 30)
        showGravityNodesButton.position = CGPoint(x: size.width / 2 + 50 , y: 708)
        
        addChilds([settingsLabel, closeButton, showGravityNodes, showGravityNodesButton])
        
    }
    
    func gsPause() {
        
        guard let rocket = childNode(withName: "rocket") else {
            //print("[FAILURE] Did not find rocket!")
            return
        }
        pausedVelocity = rocket.physicsBody!.velocity
        
        rocket.physicsBody!.isResting = true
        rocket.physicsBody!.fieldBitMask = 2
        
        for i in children {
            i.isPaused = true
        }
        
        currentGameState = .pause
        
        guard let pauseButton = childNode(withName: "pause") as? SKSpriteNode else {
            //print("[FAILURE] Did not find pauseButton!")
            return
        }
        
        pauseButton.texture = SKTexture(imageNamed: "close")
        
        let pausedLabel = gsLabel(initText: "PAUSED", name: "pausedLabel", size: 100)
        pausedLabel.position = CGPoint(x: camera!.position.x , y: camera!.position.y + 500)
        
        let restartButton = gsLabel(initText: "restart", name: "restart", size: 70, color: .red)
        restartButton.position = CGPoint(x: camera!.position.x, y: camera!.position.y - 500)
        
        addChilds([pausedLabel, restartButton])
        
        
    }
    
    func gsDePause() {
        guard let pauseButton = childNode(withName: "pause") as? SKSpriteNode else {
            //print("[FAILURE] Did not find pauseButton!")
            return
        }
        
        pauseButton.texture = SKTexture(imageNamed: "pause")
        
        guard let rocket = childNode(withName: "rocket") as? Rocket else {
            //print("[FAILURE] Did not find rocket!")
            return
        }
        
        rocket.physicsBody!.isResting = false
        rocket.physicsBody!.fieldBitMask = 1
        rocket.physicsBody!.velocity = pausedVelocity!
        
        guard let restartButton = childNode(withName: "restart") else {
            //print("[FAILURE] Did not find rocket!")
            return
        }
        guard let pausedLabel = childNode(withName: "pausedLabel") else {
            //print("[FAILURE] Did not find rocket!")
            return
        }
        self.removeChildren(in: [restartButton, pausedLabel])
        
        currentGameState = .play
    }
    
    func gsGameOver() {
        
        removeAllChildren()
        
        self.backgroundColor = .darkGray
        
        let gameOverLabel = gsLabel(initText: "GAMEOVER", name: "gameOver", size: 100)
        gameOverLabel.position = CGPoint(x: camera!.position.x , y: camera!.position.y + 500)
        
        let bestScore = "Best Score: \(self.scoreSystem!.bestScore)"
        let bestScoreLabel = gsLabel(initText: bestScore, name: "bestScore", size: 70, color: .red)
        bestScoreLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y + 100)
        
        let currentScore = "Current Score: \(self.scoreSystem!.score)"
        let currentScoreLabel = gsLabel(initText: currentScore, name: "currentScore")
        currentScoreLabel.position = CGPoint(x: camera!.position.x, y: camera!.position.y)
        
        let restartButton = gsLabel(initText: "restart", name: "restart", size: 70, color: .red)
        restartButton.position = CGPoint(x: camera!.position.x, y: camera!.position.y - 500)
        
        
        addChilds([gameOverLabel, bestScoreLabel, currentScoreLabel, restartButton])
        
    }
    
}
