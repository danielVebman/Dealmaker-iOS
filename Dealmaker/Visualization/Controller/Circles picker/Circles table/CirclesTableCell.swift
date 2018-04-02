//
//  CirclesTableCell.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import M13Checkbox

class CirclesTableCell: UITableViewCell {
    var checkbox: M13Checkbox?
    var titleLabel: UILabel?
    var item: CirclesTableItem? {
        didSet {
            if let i = item {
                checkbox?.markType = i.markType
                checkbox?.checkState = i.checkState
                titleLabel?.text = i.title
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            if checkbox == nil || titleLabel == nil {
                checkbox = M13Checkbox(frame: CGRect(x: 0, y: 10, width: frame.height - 20, height: frame.height - 20))
                checkbox!.center.x = 20 + 12.5
                checkbox!.stateChangeAnimation = .spiral
                checkbox!.tintColor = ColorPalette.primaryComplement
                addSubview(checkbox!)
                
                titleLabel = UILabel(frame: CGRect(x: checkbox!.frame.maxX + 10, y: 0, width: 0, height: frame.height))
                titleLabel!.font = UIFont.titleFont(size: 20)
                titleLabel!.textColor = ColorPalette.primaryComplement
                titleLabel!.adjustsFontSizeToFitWidth = true
                titleLabel!.minimumScaleFactor = 0.2
                addSubview(titleLabel!)
            }
            
            checkbox!.center.y = frame.height / 2
            titleLabel!.center.y = frame.height / 2
            
            titleLabel!.frame.size.width = min(titleLabel?.text?.width(withFont: UIFont.titleFont(size: 30)) ?? 0, frame.width - titleLabel!.frame.origin.x - 10)
            
            backgroundColor = UIColor.clear
        }
    }
}

