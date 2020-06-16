//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//

import CoreGraphics

import SpriteKit
import UIKit
import PlaygroundSupport


let view: SKView = SKView()
PlaygroundPage.current.liveView = view
view.frame = UIScreen.main.bounds

//#-end-hidden-code
/*:
# Welcome to the Shepherd Game

In this game, you are a shepherd who tries to keep his sheeps safe and grouped.

To do so, you can draw (with hand or with an Apple Pencil) a fence that sheeps will try to avoid.

If a sheep does out of the screen, you lost it. You lose when you have lost all your sheeps.

Sheeps will group themself when they meet each other.

However, the weather will sometimes become stormy, and your sheeps are afraid of thunderstorms.

When they hear thunder, they will panick for a short time and break all groups.

**Please disable "Show Results" to play the game**

---

You can here modify the amount of sheeps you starts with (default: 30) and the maximum length of the fence you can draw (default: 10).
*/
ShepherdGame.NO_SHEEP_AT_START = /*#-editable-code*/30/*#-end-editable-code*/
ShepherdGame.FENCE_LENGTH = /*#-editable-code*/10/*#-end-editable-code*/

//#-hidden-code
let scene = ShepherdGame(size: view.frame.size)
view.showsFPS = true
view.presentScene(scene)
//#-end-hidden-code




