//
//  TappyAdventure
//
//  Copyright © 2018 DevFountain LLC. All rights reserved.
//

import SpriteKit

extension SKScene {

    func fromTop(_ y: CGFloat) -> CGFloat {
        return viewTop() - y
    }

    func viewTop() -> CGFloat {
        return convertPoint(fromView: .zero).y
    }

    func fromBottom(_ y: CGFloat) -> CGFloat {
        return y + viewBottom()
    }

    func viewBottom() -> CGFloat {
        guard let view = view else { return 0 }
        return convertPoint(fromView: CGPoint(x: 0, y: view.bounds.size.height)).y
    }

}
