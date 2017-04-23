//  Created by Niklas Bülow on 28.03.17.
//  Copyright © 2017 Niklas Bülow. All rights reserved.

import CoreGraphics


/* declare enum for GameState:
 *
 * menu     : Menu with Launch Label is showed, initial property
 * launch   : Launchsequence with countdown
 * play     : User can play and interact with the game
 * pause    : PLAY GameState is paused
 * gameover : Show score on an GameOver view
 */
public enum GameState {
    case menu, launch, play, pause, gameover, settings
}

/* declare enum for available predefined PlanetTypes:
 *
 * gasgiant
 * ice
 * earthlike(atmosphereSize)
 * rock
 * metal
 * startPlanet
 */
public enum PlanetType {
    case gasgiant, ice, earthlike(CGFloat), rock, metal
}

/* declare enum for Forces applied to Rocket:
 *
 * increase : positive y force
 * decrease : negative y force
 * none     : zero y force
 */
public enum ForceType {
    case increase(CGFloat), decrease, none
}


/* declare endType of FuturePath
 *
 * reachedHeight: FuturePath reached max height relative to rocket
 * collided     : FuturePath collided with onject in scene
 * maxedArrayNum: FuturePath reached max amount of CGPoints
 * none
 */
public enum FuturePathType {
    case reachedHeight(CGPoint), collided(CGPoint), maxedArrayNum(CGPoint, CGVector), none
}
