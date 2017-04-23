//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit


//declare custom planet class for planet "obstacles" in the game
public class Universe {
    
    public init(){}
    
    public class func createPlanet(position: CGPoint = CGPoint(x: 0, y: 0), circleOfRadius radius: CGFloat, color: SKColor = .green, type: PlanetType, gravitySize: Float = 300, gravityStrength: Float = 1, withPhysics: Bool, settings: Settings) -> SKShapeNode {
        
        let planet = SKShapeNode(circleOfRadius: radius)
        planet.zPosition = -10
        planet.position = position
        planet.name = "planet"
        
        switch type {
        case .earthlike(let atmosphereSize):
            planet.fillColor = SKColor.mixColors(color1: .black, color2: color, intensity1: 0.3, intensity2: 0.7)
            
            //initialize the atmosphere of the startPlanet
            let atmosphere = SKShapeNode(circleOfRadius: radius + atmosphereSize)
            let atmosphereColor = SKColor.init(red: 0.2, green: 0.4, blue: 1, alpha: 0.8)
            atmosphere.strokeColor = atmosphereColor.withAlphaComponent(0.7)
            atmosphere.fillColor = atmosphere.strokeColor
            atmosphere.zPosition = -2
            
            //nodes["atmosphere"] = atmosphere
            planet.addChild(atmosphere)
            
            break
        case .rock:
            planet.fillColor = SKColor.mixColors(color1: .gray, color2: color, intensity1: 0.9, intensity2: 0.1)
            break
        case .ice:
            planet.fillColor = SKColor.mixColors(color1: .blue, color2: color, intensity1: 0.7, intensity2: 0.3)
            break
        case .gasgiant:
            planet.fillColor = SKColor.mixColors(color1: .brown, color2: color, intensity1: 0.6, intensity2: 0.4).withAlphaComponent(0.7)
            break
        case .metal:
            planet.fillColor = SKColor.mixColors(color1: .gray, color2: color, intensity1: 0.7, intensity2: 0.3)
            break
        }
        
        planet.strokeColor = planet.fillColor
        planet.zPosition = 0
        
        if withPhysics {
            planet.physicsBody = SKPhysicsBody(edgeLoopFrom: planet.path!)
            planet.physicsBody!.categoryBitMask = 2
            planet.physicsBody!.contactTestBitMask = 1
            planet.physicsBody!.collisionBitMask = 1
        }
        
        if gravitySize > 0 {
            let gravityField = SKFieldNode.radialGravityField()
            gravityField.region = SKRegion(radius: Float(radius) + gravitySize)
            gravityField.strength = gravityStrength
            gravityField.isEnabled = true
            gravityField.categoryBitMask = 1
            planet.addChild(gravityField)
            
            if settings.showGravity {
                let gravityView = SKShapeNode(circleOfRadius: radius + CGFloat(gravitySize))
                gravityView.fillColor = .red
                gravityView.fillColor = gravityView.fillColor.withAlphaComponent(CGFloat(gravityStrength * 0.1))
                gravityView.strokeColor = gravityView.fillColor
                gravityView.zPosition = -100
            
                planet.addChild(gravityView)
            }
        }
        
        return planet
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public class func createGravityField(for planet: SKShapeNode, size: Float, strength: Float) -> SKFieldNode {
        return SKFieldNode()
    }
    
}

extension SKColor {
    class func mixColors(color1: SKColor, color2: SKColor, intensity1 i1: CGFloat = 0.5, intensity2 i2: CGFloat = 0.5) -> SKColor {
        var c1: [CGFloat] = [0,0,0,0]
        var c2: [CGFloat] = [0,0,0,0]
        
        let total = i1 + i2
        let ci1 = i1/total
        let ci2 = i2/total
        
        color1.getRed(&c1[0], green: &c1[1], blue: &c1[2], alpha: &c1[3])
        color2.getRed(&c2[0], green: &c2[1], blue: &c2[2], alpha: &c2[3])
        
        let mix = SKColor(red: ci1 * c1[0] + ci2 * c2[0], green: ci1 * c1[1] + ci2 * c2[1], blue: ci1 * c1[2] + ci2 * c2[2], alpha: ci1 * c1[3] + ci2 * c2[3])
        
        return mix
    }
}
