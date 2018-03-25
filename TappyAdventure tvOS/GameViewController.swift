//
//  TappyAdventure
//
//  Copyright © 2018 DevFountain LLC. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    var scene: SKScene? {
        return (view as! SKView).scene
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let scene = GameScene.newGameScene()

        let skView = self.view as! SKView
        skView.presentScene(scene)

        skView.ignoresSiblingOrder = true
        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard let press = presses.first else { return }

        if press.type == .menu {
            super.pressesBegan(presses, with: event)
        } else {
            scene?.pressesBegan(presses, with: event)
        }
    }

}
