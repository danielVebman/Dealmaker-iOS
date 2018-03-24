//
//  Colors.swift
//  DirecDem
//
//  Created by Daniel Vebman on 12/12/17.
//  Copyright © 2017 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

struct ColorPalette {
    static let primary = UIColor(rgb: 0x1E1E1E)
    static let primaryComplement = UIColor(rgb: 0xF2F2F2)
    static let error = UIColor(rgb: 0xFF857C)
}

struct FontNames {
    static let title = "Kiona-Regular"
    static let subtitle = "Avenir-Medium"
    static let body = "Avenir"
}

extension UIFont {
    static func titleFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.title, size: size)!
    }
    
    static func subtitleFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.subtitle, size: size)!
    }
    
    static func bodyFont(size: CGFloat) -> UIFont {
        return UIFont(name: FontNames.body, size: size)!
    }
}

func enumerateFonts() {
    for fontFamily in UIFont.familyNames {
        print("Font family name = \(fontFamily as String)");
        for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
            print("- Font name = \(fontName)");
        }
        print("\n");
    }
}
