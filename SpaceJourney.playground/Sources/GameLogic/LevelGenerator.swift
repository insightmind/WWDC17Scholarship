//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import CoreGraphics
import SpriteKit

public class LevelGenerator {
    
    var nextPlanet: CGFloat
    var sortedPoints = [String: CGPoint]()
  
    public func shouldUpdate(_ points: [CGPoint], position: CGPoint ) -> Bool {
        if position.y + 4000 >= nextPlanet {
            
            var normalPoints = [CGPoint]()
            
            for i in points {
                if i.y <= nextPlanet  {
                    normalPoints.append(CGPoint(x: i.x, y: nextPlanet))
                } else {
                    normalPoints.append(i)
                }
            }
            if normalPoints[0].x <= normalPoints[1].x {
                sortedPoints["smaller"] = normalPoints[0]
                sortedPoints["bigger"] = normalPoints[1]
            } else {
                sortedPoints["smaller"] = normalPoints[1]
                sortedPoints["bigger"] = normalPoints[0]
            }
            
            return true
            
        }
        
        return false
        
    }
    
    public func getPlanet(_ scoreSystem: ScoreSystem, settings: Settings) -> SKShapeNode{
        guard let smaller = sortedPoints["smaller"] else {
            //print("[FAILURE] did not find smaller point!")
            fatalError()
        }
        guard let bigger = sortedPoints["bigger"] else {
            //print("[FAILURE] did not find bigger point!")
            fatalError()
        }
        
        let radius = randomBetweenNumbers(firstNum: 100, secondNum: 300)
        var planetPoint = CGPoint(x: 0, y: 0)
        
        var isNotPossible = true
        let gravitySize = randRange(lower: 100, upper: 700)
        while isNotPossible {
            let planetCenter = randomBetweenNumbers(firstNum: -300 , secondNum: 700)
            if (planetCenter + radius < bigger.x - 60) || (planetCenter - radius > smaller.x + 60)  {
                planetPoint = CGPoint(x: planetCenter, y: nextPlanet)
                isNotPossible = false
            }
        }
        let gravityStrength = randomBetweenNumbers(firstNum: 1, secondNum: 3)
        let planetType: PlanetType
        let typeRandom = randRange(lower: 0, upper: 5)
        switch typeRandom {
        case 1:
            planetType = .gasgiant
            break
        case 2:
            planetType = .ice
            break
        case 3:
            planetType = .earthlike(randomBetweenNumbers(firstNum: 20, secondNum: 80))
            break
        case 4:
            planetType = .metal
            break
        default:
            planetType = .rock
            break
        }
        let planet = Universe.createPlanet(position: planetPoint, circleOfRadius: CGFloat(radius), color: randomColor(), type: planetType, gravitySize: Float(gravitySize), gravityStrength: Float(gravityStrength), withPhysics: true, settings: settings)
        
        updateNext(scoreSystem)
        
        return planet
    }
    
    public init() {
        nextPlanet = 2000
    }
    
    func updateNext(_ scoreSystem: ScoreSystem) {
        
        let minPoint = 700 / (1 + sigmoid(t: scoreSystem.score / 100))
        let maxPoint = 1500 / (1 + sigmoid(t: scoreSystem.score / 100))
        
        nextPlanet = randomBetweenNumbers(firstNum: nextPlanet + CGFloat(minPoint), secondNum: nextPlanet + CGFloat(maxPoint)) + 100
        scoreSystem.addNextScoreHeight(nextPlanet)
    }
    
    public func randomBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
    func random() -> CGFloat {
        
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
        
    }
    
    func randomColor() -> UIColor {
        return UIColor(red:   self.random(),
                       green: self.random(),
                       blue:  self.random(),
                       alpha: 1.0)
    }
    
    func sigmoid(t: Int) -> Double {
        
        let s = 1 / (1 + pow(M_E, Double(-t)))
        
        return s
    }
}
