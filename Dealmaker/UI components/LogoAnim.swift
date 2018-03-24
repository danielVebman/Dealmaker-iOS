//
//  LogoAnim.swift
//  DirecDem
//
//  Created by Daniel Vebman on 12/23/17.
//  Copyright © 2017 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class LogoAnimationView: UIView {
    private var scale: CGFloat
    
    private var square: UIView!
    
    private var line0: UIView!
    private var line1: UIView!
    private var line2: UIView!
    private var line3: UIView!
    private var line4: UIView!
    private var line5: UIView!
    
    convenience init(width: CGFloat) {
        self.init(width: 2145 * width / 4076)
    }
    
    init(height: CGFloat) {
        scale = height / 2145
        let margin = 198 * scale
        let lineHeight = 190 * scale
        super.init(frame: CGRect(x: 0, y: 0, width: 4076 * scale, height: height))

        square = UIView(frame: CGRect(x: 0, y: 0, width: 1624 * scale, height: 978 * scale))
        square.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 30 / 255, blue: 106 / 255, alpha: 1)
        addSubview(square)
        line0 = UIView(frame: CGRect(x: square.frame.width + margin, y: 0, width: 0, height: lineHeight))
        line0.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line0)
        line1 = UIView(frame: CGRect(x: square.frame.width + margin, y: (lineHeight + margin) * 1, width: 0, height: lineHeight))
        line1.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line1)
        line2 = UIView(frame: CGRect(x: square.frame.width + margin, y: (lineHeight + margin) * 2, width: 0, height: lineHeight))
        line2.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line2)
        line3 = UIView(frame: CGRect(x: 0, y: (lineHeight + margin) * 3, width: 0, height: lineHeight))
        line3.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line3)
        line4 = UIView(frame: CGRect(x: 0, y: (lineHeight + margin) * 4, width: 0, height: lineHeight))
        line4.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line4)
        line5 = UIView(frame: CGRect(x: 0, y: (lineHeight + margin) * 5, width: 0, height: lineHeight))
        line5.backgroundColor = UIColor(displayP3Red: 210 / 255, green: 0, blue: 22 / 255, alpha: 1)
        addSubview(line5)
    }
    
    func showFlagLines(_ animated: Bool = true) {
        UIView.animate(withDuration: animated ? 1 : 0, delay: 0, options: .curveEaseOut, animations: {
            self.line0.frame.size.width = 2045 * self.scale
            self.line1.frame.size.width = 1596 * self.scale
            self.line2.frame.size.width = 1928 * self.scale
            self.line3.frame.size.width = 3995 * self.scale
            self.line4.frame.size.width = 3295 * self.scale
            self.line5.frame.size.width = 3708 * self.scale
        }, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
