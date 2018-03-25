//
//  TappyAdventure
//
//  Copyright © 2018 DevFountain LLC. All rights reserved.
//

#if os(iOS) || os(tvOS)
    import UIKit
    typealias Color = UIColor
#elseif os(macOS)
    import AppKit
    typealias Color = NSColor
#endif

extension Color {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }

    static let red = Color(red: 255, green: 59, blue: 48)
    static let orange = Color(red: 255, green: 149, blue: 0)
    static let yellow = Color(red: 255, green: 204, blue: 0)
    static let green = Color(red: 76, green: 217, blue: 100)
    static let tealBlue = Color(red: 90, green: 200, blue: 250)
    static let blue = Color(red: 0, green: 122, blue: 255)
    static let purple = Color(red: 88, green: 86, blue: 214)
    static let pink = Color(red: 255, green: 45, blue: 85)
    static let black = Color(red: 38, green: 38, blue: 38)
}
