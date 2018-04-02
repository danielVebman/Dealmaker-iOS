//
//  ButtonHelper.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/24/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func set(subtitle: String, font: UIFont, color: UIColor) {
        let label = UILabel()
        label.text = subtitle
        label.font = font
        label.sizeToFit()
        label.textColor = color
        label.frame.size.width = frame.width
        label.frame.origin.y = frame.height - label.frame.height
        label.textAlignment = .center
        addSubview(label)
    }
}
