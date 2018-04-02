//
//  Colors.swift
//  DirecDem
//
//  Created by Daniel Vebman on 2/18/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

func colorBetween(_ color0: UIColor, _ color1: UIColor, at position: Double) -> UIColor? {
    guard let rgb0 = color0.rgb else { return nil }
    guard let rgb1 = color1.rgb else { return nil }
    
    let pos = min(1, max(0, position))
    let r = Int(Double(rgb0.red) + pos * Double(rgb1.red - rgb0.red))
    let g = Int(Double(rgb0.green) + pos * Double(rgb1.green - rgb0.green))
    let b = Int(Double(rgb0.blue) + pos * Double(rgb1.blue - rgb0.blue))
    let a = Int(Double(rgb0.alpha) + pos * Double(rgb1.alpha - rgb0.alpha))
    print(r, g, b, a)
    
    return UIColor(red: r, green: g, blue: b, alpha: a)
}

extension UIColor {
    var rgb: (red: Int, green: Int, blue: Int, alpha: Int)? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)
            
            return (red: iRed, green: iGreen, blue: iBlue, alpha: iAlpha)
        } else {
            return nil
        }
    }

    /// r,g,b,a∈[0,255]
    convenience init(red: Int, green: Int, blue: Int, alpha: Int = 255) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    convenience init(hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat = 1)  {
        let offset = saturation * (lightness < 0.5 ? lightness : 1 - lightness)
        let brightness = lightness + offset
        let saturation = lightness > 0 ? 2 * offset / brightness : 0
        self.init(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }
    var lighter: UIColor? {
        return applying(lightness: 1.25)
    }
    func applying(lightness value: CGFloat) -> UIColor? {
        guard let hsl = hsl else { return nil }
        return UIColor(hue: hsl.hue, saturation: hsl.saturation, lightness: hsl.lightness * value, alpha: hsl.alpha)
    }
    var hsl: (hue: CGFloat, saturation: CGFloat, lightness: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0, hue: CGFloat = 0
        guard
            getRed(&red, green: &green, blue: &blue, alpha: &alpha),
            getHue(&hue, saturation: nil, brightness: nil, alpha: nil)
            else { return nil }
        let upper = max(red, green, blue)
        let lower = min(red, green, blue)
        let range = upper - lower
        let lightness = (upper + lower) / 2
        let saturation = range == 0 ? 0 : range / (lightness < 0.5 ? lightness * 2 : 2 - lightness * 2)
        return (hue, saturation, lightness, alpha)
    }
}
