//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import Foundation
import SpriteKit
import CoreGraphics

public extension GameScene {
    
    func gsLabel(initText: String, name: String, size: CGFloat = 40, color: SKColor = .white) -> SKLabelNode {
        let startTitle = SKLabelNode(text: initText)
        startTitle.name = name
        startTitle.fontSize = size
        startTitle.fontName = "Futura-Bold"
        startTitle.fontColor = color
        startTitle.zPosition = 101
        return startTitle
    }
    
    
    func gsFlightPath() -> FlightPath {
        let flightPath = FlightPath(rectOf: CGSize(width: 1, height: 1))
        flightPath.name = "flightPath"
        flightPath.position = CGPoint.zero
        flightPath.isHidden = true
        flightPath.zPosition = -20
        return flightPath
    }
    
    func gsTitle() -> SKSpriteNode {
        let node =  SKSpriteNode(imageNamed: "title")
        node.size = CGSize(width: node.size.width / 2.3, height: node.size.height / 2.3)
        node.zPosition = 101
        node.name = "title"
        return node
    }
    
    func gsIcon(image: String) -> SKSpriteNode {
        let node = SKSpriteNode(imageNamed: image)
        if image == "pause" {
            node.size = CGSize(width: 100, height: 100)
        } else {
            node.size = CGSize(width: 50, height: 50)
        }
        node.zPosition = 102
        node.name = image
        return node
    }

}
