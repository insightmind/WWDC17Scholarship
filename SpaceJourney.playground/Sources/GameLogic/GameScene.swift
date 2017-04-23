//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit
import AVFoundation

// declare main SpriteKitGameScene
public class GameScene : SKScene, SKSceneDelegate, SKPhysicsContactDelegate{
    
    var pausedVelocity: CGVector?
    var scoreSystem: ScoreSystem?
    var launchCountDownNum = 10
    var currentGameState = GameState.menu
    var settings: Settings?
    
    var explosionAction: SKAction?
    var countdownAction: SKAction?
    var dissolveAction: SKAction?
    
    var cam: SKCameraNode!
    var applyForce = ForceType.none
    var isLaunched: Bool = false
    var levelGenerator: LevelGenerator!
    var score: Int = 0
    
    // configure init function with necessary nodes for the scene at start
    public init(size: CGSize, prevScoreSystem: ScoreSystem? = nil, prevSettings: Settings? = nil) {
        
        super.init(size: size)
        self.delegate = self
        
        if prevScoreSystem == nil {
            self.scoreSystem = ScoreSystem()
        } else {
            self.scoreSystem = prevScoreSystem
        }
        
        if prevSettings == nil {
            self.settings = Settings()
        } else {
            self.settings = prevSettings
        }
        
        gsMainGame()
    }
    
    override public func didMove(to view: SKView) {
        updateCamPosition(view)
    }
    
    public func update(_ currentTime: TimeInterval, for scene: SKScene) {
        switch currentGameState {
        case .play:
            
            guard let rocket = self.childNode(withName: "rocket") as? Rocket else {
                //print("[FAILURE] Did not find rocket! .sc.play.rocket")
                return
            }
            guard let flightPath = self.childNode(withName: "flightPath") as? FlightPath else {
                //print("[FAILURE] Did not find flighpath!")
                return
            }
            
            let pathCalc = PathCalculator()
            _ = pathCalc.calculatePoint(at: 2, with: .increase(0), for: rocket.physicsBody!.mass, at: rocket.position, atSpeed: rocket.physicsBody!.velocity, in: self)
            _ = pathCalc.calculatePoint(at: 2, with: .decrease, for: rocket.physicsBody!.mass, at: rocket.position, atSpeed: rocket.physicsBody!.velocity, in: self)
            _ = pathCalc.calculatePoint(at: 1, with: .none, for: rocket.physicsBody!.mass, at: rocket.position, atSpeed: rocket.physicsBody!.velocity, in: self)
            
            flightPath.updateFlightPath(pathArray: pathCalc.noneThrottleArray)
            
            guard let point1 = pathCalc.fullThrottleArray.last else {
                //print("[FAILURE]")
                return
            }
            guard let point2 = pathCalc.brakeThrottleArray.last else {
                //print("[FAILURE]")
                return
            }
            guard let score = scoreSystem else {
                //print("[FAILURE] ScoreSystem not found")
                return
            }
            
            if levelGenerator.shouldUpdate([point1, point2], position: rocket.position) {
                self.addChild(levelGenerator.getPlanet(score, settings: settings!))
            }
            
            guard let scoreLabel = self.childNode(withName: "score") as? SKLabelNode else {
                //print("[FAILURE] Selected node is not an SKLabelNode FC: .tB.menu.if")
                return
            }
            
            score.updateScore(rocket.position, scoreNode: scoreLabel)
            
            deleteOldNodes(rocket.position)
            
            break
        default:
            break
        }
    }
    
    public func didSimulatePhysics(for scene: SKScene) {
        
        switch currentGameState {
        
        case .play:
            
            guard let rocket = self.childNode(withName: "rocket") as? Rocket else {
                //print("[FAILURE] Did not find rocket! .sc.play.rocket")
                return
            }
            
            camera!.position.y = rocket.position.y + 200
            
            guard let scoreLabel = self.childNode(withName: "score") as? SKLabelNode else {
                //print("[FAILURE] Selected node is not an SKLabelNode FC: .tB.menu.if")
                return
            }
            scoreLabel.position.y = camera!.position.y + 775
            
            guard let spLabel = childNode(withName: "pause") as? SKSpriteNode else {
                //print("[FAILURE] Did not find spLabel!")
                return
            }
            spLabel.position.y = camera!.position.y + 800
            
            play()
            
            break
        case .gameover:
            
            break
            
        case .settings:
            
            break
        default:
            guard let rocket = self.childNode(withName: "rocket") as? Rocket else {
                //print("[FAILURE] Did not find rocket! .sc.play.rocket")
                return
            }
            
            camera!.position.y = rocket.position.y + 200
            
            guard let launchTitle = self.childNode(withName: "menu.launchbutton") as? SKLabelNode else {
                //print("[FAILURE] Selected node is not an SKLabelNode FC: .tB.menu.if")
                return
            }
            
            launchTitle.position.y = camera!.position.y - camera!.yScale * 200 - 125
            break
        }
    }
    
    func play() {
        guard let rocket = self.childNode(withName: "rocket") as? Rocket else {
            //print("[FAILURE] Did not find rocket! .sc.play.rocket")
            return
        }
        guard let flightPath = self.childNode(withName: "flightPath") as? FlightPath else {
            //print("[FAILURE] Did not find flighpath!")
            return
        }
        if isLaunched != true {
            
            flightPath.isHidden = false
            
            rocket.physicsBody!.isDynamic = true
            rocket.speedUp(by: CGVector(dx: 0, dy: 100), animationDuration: 1)
            isLaunched = true
        }

        
        rocket.zRotation = Rocket.updateRotation(rocket.physicsBody!.velocity)
        
        switch applyForce {
        case .increase(let xAcceleration):
            rocket.speedUp(by: CGVector(dx: xAcceleration, dy: 3))
            break
        case .decrease:
            rocket.speedUp(by: CGVector(dx: 0, dy: -7))
            break
        case .none:
            rocket.setBurstRelative(to: 0)
            break
        }
        
        if rocket.position.x <= (frame.minX - 300){
            rocket.position.x = frame.maxX + 299
        } else if rocket.position.x >= (frame.maxX + 300) {
            rocket.position.x = frame.minX - 299
        }
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

