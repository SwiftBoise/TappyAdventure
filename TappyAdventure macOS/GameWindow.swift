//
//  TappyAdventure
//
//  Copyright © 2018 DevFountain LLC. All rights reserved.
//

import Cocoa

class GameWindow: NSWindow {

    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

        let contentSize = NSSize(width: 1024, height: 768)
        let minContentSize = NSSize(width: 800, height: 600)
        let maxContentSize = NSSize(width: 1366, height: 1024)

        setFrame(NSRect(origin: .zero, size: contentSize), display: true)

        aspectRatio = NSSize(width: 4, height: 3)

        contentMinSize = minContentSize
        contentMaxSize = maxContentSize

        minFullScreenContentSize = minContentSize
        maxFullScreenContentSize = maxContentSize
    }

}
