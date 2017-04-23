//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit
import Foundation

//declare rocket class that represents the player
public class Rocket : SKSpriteNode {
    
    func setBurstRelative(to acceleration: CGFloat, duration: TimeInterval = 0.1, rotate: CGFloat = 0) {
        setBurstScale(to: acceleration, duration: duration)
        setBurstRotation(rotation: rotate)
    }
    
    func setBurstRotation(rotation: CGFloat = 0) {
        guard let centerNode1 = self.childNode(withName: "cn1") else {
            //print("[FAILURE] Could not find centerNode1")
            return
        }
        guard let centerNode2 = self.childNode(withName: "cn2") else {
            //print("[FAILURE] Could not find centerNode2")
            return
        }
        
        let rotate = SKAction.rotate(toAngle: rotation, duration: 0)
        
        centerNode1.run(rotate)
        centerNode2.run(rotate)
    }
    
    func setBurstScale(to acceleration: CGFloat, duration: TimeInterval = 0.1) {
        guard let centerNode1 = self.childNode(withName: "cn1") else {
            //print("[FAILURE] Could not find centerNode1")
            return
        }
        guard let centerNode2 = self.childNode(withName: "cn2") else {
            //print("[FAILURE] Could not find centerNode2")
            return
        }
        
        guard let engineBurst1 = centerNode1.childNode(withName: "eb1") as? SKSpriteNode else {
            //print("[FAILURE] Could not find burst1")
            return
        }
        
        guard let engineBurst2 = centerNode2.childNode(withName: "eb2") as? SKSpriteNode else {
            //print("[FAILURE] Could not find burst2")
            return
        }
        
        let scale: SKAction
        let position: SKAction
        
        if engineBurst1.isHidden || engineBurst2.isHidden{
            engineBurst1.isHidden = false
            engineBurst2.isHidden = false
        }
        
        if acceleration > 0 {
            
            scale = SKAction.scaleY(to: 60, duration: duration)
            position = SKAction.moveTo(y: -30, duration: duration)
            
        } else {
            
            scale = SKAction.scaleY(to: 0, duration: duration)
            position = SKAction.moveTo(y: 0, duration: duration)
        }
        
        engineBurst1.run(position)
        engineBurst1.run(scale)
        
        engineBurst2.run(position)
        engineBurst2.run(scale)
    }
    
    func speedUp(by acceleration: CGVector, animationDuration: TimeInterval = 0.1){
        
        setBurstRelative(to: acceleration.dy, duration: animationDuration, rotate: (acceleration.dx / (2 * CGFloat.pi)))

        let accelerationVector = Rocket.calculateAcceleration(acceleration, speed: physicsBody!.velocity, rotation: zRotation, yPosition: self.position.y)
        
        physicsBody!.applyImpulse(accelerationVector)
        
    }
    
    class func calculateAcceleration(_ acceleration: CGVector, speed: CGVector, rotation: CGFloat, yPosition: CGFloat) -> CGVector {
        
        let prevYValue = speed.dy
        let prevXValue = speed.dx
        
        let maxYValue = 200 + yPosition / 60
        
        let yValue: CGFloat
        var xValue: CGFloat
        var dis: CGFloat = 1
        
        if (prevYValue + acceleration.dy) < 0 && prevYValue > -400 {
            if prevYValue < 0 {
                yValue = acceleration.dy
            } else {
                yValue = 0
            }
        } else if prevYValue >= maxYValue || prevYValue <= -maxYValue {
            yValue = maxYValue - prevYValue - 2
        } else {
            yValue = acceleration.dy
        }
        
        if prevXValue >= 200 || prevXValue <= -200 {
            xValue = 0
        } else {
            xValue = acceleration.dx
        }
        
        if prevXValue <= -500 || prevXValue >= 500 {
            dis = 0
            xValue = -prevXValue
        }
        
        return CGVector(dx: -yValue * sin(rotation) * dis + xValue, dy: yValue * cos(rotation))
    }
    
    class func updateRotation(_ velocity: CGVector) -> CGFloat{
        
        let dx = velocity.dx
        let dy = velocity.dy
        
        let sq = sqrt(dx*dx+dy*dy)
        
        if sq > 0.1 {
            let angle = atan2(dy, dx)
            return angle - .pi / 2
        }
        return 0
    }
    
    public init(imageNamed name: String = "rocket") {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: texture.size())
        
        self.name = name
        self.size = CGSize(width: self.size.width / 13, height: self.size.height / 13)
        
        self.setUpEngineBursts()
        
        self.setUpPhysicsBody()
    }
    
    func setUpEngineBursts() {
        let centerNode1 = SKNode()
        centerNode1.name = "cn1"
        centerNode1.position = CGPoint(x: -19, y: -60)
        centerNode1.zPosition = -5
        self.addChild(centerNode1)
        
        let engineBurst1 = SKSpriteNode(imageNamed: "fire2")
        engineBurst1.name = "eb1"
        engineBurst1.isHidden = true
        engineBurst1.size = CGSize(width: 25, height: 1)
        engineBurst1.zPosition = -10
        centerNode1.addChild(engineBurst1)
        
        let centerNode2 = SKNode()
        centerNode2.name = "cn2"
        centerNode2.position = CGPoint(x: 21, y: -60)
        centerNode2.zPosition = -5
        self.addChild(centerNode2)
        
        let engineBurst2 = SKSpriteNode(imageNamed: "fire3")
        engineBurst2.name = "eb2"
        engineBurst2.isHidden = true
        engineBurst2.size = CGSize(width: 25, height: 1)
        engineBurst2.zPosition = -10
        centerNode2.addChild(engineBurst2)

    }
    
    func setUpPhysicsBody() {
        physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width / 2, height: self.size.height))
        physicsBody!.mass = 1
        physicsBody!.linearDamping = 0.0
        physicsBody!.friction = 0
        physicsBody!.allowsRotation = true
        physicsBody!.affectedByGravity = false
        physicsBody!.isDynamic = false
        physicsBody!.usesPreciseCollisionDetection = true
        physicsBody!.categoryBitMask = 1
        physicsBody!.contactTestBitMask = 2
        physicsBody!.collisionBitMask = 2
        physicsBody!.fieldBitMask = 1
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
