//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit

func +(left: CGVector, right: CGVector) -> CGVector {
    var sum = CGVector()
    sum.dx = left.dx + right.dx
    sum.dy = left.dy + right.dy
    return sum
}

public class PathCalculator {
    
    
    var fullThrottleArray = [CGPoint]()
    var noneThrottleArray = [CGPoint]()
    var brakeThrottleArray = [CGPoint]()
    
    func calculatePoint(at time: TimeInterval, with type: ForceType, for mass: CGFloat, at position: CGPoint, atSpeed prevVelocity: CGVector, in world: SKScene) -> FuturePathType{
        
        let forceAtPoint = getForceAtPoint(position, in: world.physicsWorld)
        
        let specacc: CGFloat
        
        let rotation = Rocket.updateRotation(prevVelocity)
        
        switch type {
        case .increase:
            if fullThrottleArray.count <= 0 {
                fullThrottleArray.append(position)
            } else if fullThrottleArray.count == 1 {
                let point = CGPoint(x: -60 * sin(rotation) , y: 60 * cos(rotation))
                fullThrottleArray.append(point)
            }
            specacc = 3
            break
        case .decrease:
            if brakeThrottleArray.count <= 0 {
                brakeThrottleArray.append(position)
            } else if brakeThrottleArray.count == 1 {
                let point = CGPoint(x: -60 * sin(rotation) , y: 60 * cos(rotation))
                brakeThrottleArray.append(point)
            }
            specacc = -7
            break
        case .none:
            if noneThrottleArray.count <= 0{
                noneThrottleArray.append(position)
            } else if noneThrottleArray.count == 1 {
                let point = CGPoint(x: -60 * sin(rotation) , y: 60 * cos(rotation))
                noneThrottleArray.append(point)
            }
            specacc = 0
            break
        }
        
        let acceleration = Rocket.calculateAcceleration(CGVector(dx: 0, dy: specacc), speed: prevVelocity, rotation: rotation, yPosition: position.y)
        
        let force = forceAtPoint + acceleration
        
        let forceAcceleration = CGVector(dx: force.dx / mass, dy: force.dy / mass)
        
        let forceVelocity = CGVector(dx: forceAcceleration.dx * CGFloat(time), dy: forceAcceleration.dy * CGFloat(time))
        
        let velocity = prevVelocity + forceVelocity
        
        let distance = CGVector(dx: velocity.dx * CGFloat(time), dy: velocity.dy * CGFloat(time))
        
        let nextPoint = CGPoint(x: position.x + distance.dx / 11, y: position.y + distance.dy / 11)
        
        
        switch type {
        case .increase:
            fullThrottleArray.append(nextPoint)
            break
        case .decrease:
            brakeThrottleArray.append(nextPoint)
            break
        case .none:
            noneThrottleArray.append(nextPoint)
        }
        
        guard let rocket = world.childNode(withName: "rocket") as? Rocket else {
            //print("[FAILURE] Did not find rocket! .sc.tB.play.rocket")
            return .none
        }
        
        var return1 = shouldRecurrPointCalculation(nextPoint, for: type, in: world, at: rocket.position)
        
        switch return1 {
        case .maxedArrayNum( _, _):
            break
        case .reachedHeight( _):
            break
        case .none:
            return1 = calculatePoint(at: time, with: type, for: mass, at: nextPoint, atSpeed: velocity, in: world)
            break
        case .collided( _):
            break
        }
        return return1
    }
    
    func shouldRecurrPointCalculation(_ point: CGPoint, for type: ForceType, in world: SKScene, at position: CGPoint) -> FuturePathType {
        
        let nodes = world.physicsWorld.body(alongRayStart: position, end: point)
        let maxArrayNum = 100
        switch type {
        case .increase:
            if fullThrottleArray.count >= maxArrayNum / 2 {
                return .maxedArrayNum(point, CGVector.zero)
            } else if point.y >= position.y + 1750 {
                return .reachedHeight(point)
            } else if nodes != nil {
                return .collided(point)
            } else {
                return .none
            }
        case .decrease:
            if brakeThrottleArray.count >= maxArrayNum / 2 {
                return .maxedArrayNum(point, CGVector.zero)
            } else if point.y >= position.y + 1750 {
                return .reachedHeight(point)
            } else if nodes != nil {
                return .collided(point)
            } else {
                return .none
            }
        case .none:
            if noneThrottleArray.count >= maxArrayNum + 50 {
                return .maxedArrayNum(point, CGVector.zero)
            } else if point.y >= position.y + 1750 {
                return .reachedHeight(point)
            } else if nodes != nil {
                return .collided(point)
            } else {
                return .none
            }
        }
    }
    
    func getForceAtPoint(_ point: CGPoint, in world: SKPhysicsWorld) -> CGVector {
        var floatVectorPosition = vector_float3()
        floatVectorPosition.x = Float(point.x)
        floatVectorPosition.y = Float(point.y)
        floatVectorPosition.z = 0
        
        let floatVectorForceAtPoint = world.sampleFields(at: floatVectorPosition)
        
        var forceAtPoint = CGVector()
        forceAtPoint.dx = CGFloat(floatVectorForceAtPoint.x) * 20
        forceAtPoint.dy = CGFloat(floatVectorForceAtPoint.y) * 20
        
        return forceAtPoint
    }
    
}
