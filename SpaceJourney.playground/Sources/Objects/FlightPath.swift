//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import SpriteKit
import CoreGraphics

//declare custom flightpath class to show the flightpath of the rocket
public class FlightPath : SKShapeNode {
    
    func updateFlightPath(pathArray: [CGPoint], isDashed: Bool = true) {
        let path = CGMutablePath()
        path.addLines(between: pathArray)
        
        if isDashed {
            let sequence: [CGFloat] = [20.0, 20.0]
            let dashed = path.copy(dashingWithPhase: 0, lengths: sequence)
            self.path = dashed
        } else {
            self.path = path
        }
        self.lineWidth = 5
        self.fillColor = .clear
        self.strokeColor = .init(white: 0.8, alpha: 0.8)
    }
    
}
