//: Playground - noun: a place where people can play
//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.
//: ---
/*: 
## SPACEJOURNEY - WWDC 2017 playground by Niklas Bülow

### Basic Controls:
 
 * touch inside the upper half of the view to speed up and steer the rocket.
 * touch inside the lower half of the view to brake, but while braking you are not able to steer the rocket.
 
 If you want see the gravity of the planets, just turn on the "show Gravity" setting in the settings of the playground.
 
 You can find the code for the playground in the <- Sources folder of this playground
 
 */
//: ---
//: ### import API's
import SpriteKit
import PlaygroundSupport
//: ---
//: ### GAMEVARIABLES
let debugMode = false
//:set the windowSize of the view
let frame = CGRect(x: 0, y: 0, width: 400, height: 700)
//: ---
//:initialize the mainView
let view = SKView(frame: frame)
view.showsFPS = debugMode
view.showsPhysics = debugMode
view.showsFields = debugMode
view.showsDrawCount = debugMode
view.showsNodeCount = debugMode
view.showsQuadCount = debugMode
//:initialize mainGameScene
let scene = GameScene(size: frame.size)
//:connect mainGameScene to view
view.presentScene(scene)
//:show view as the PlaygroundLiveView
PlaygroundPage.current.liveView = view
//:known Bug : * no Burst after pause
