//
//  PartisanshipSlider.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class PartisanshipSlider: UIView {
    var demView: UIView?
    var repView: UIView?
    var indView: UIView?
    
    var fractions: (dem: CGFloat, rep: CGFloat, ind: CGFloat)? {
        didSet {
            updateDimensions()
        }
    }
    
    override var frame: CGRect {
        didSet {
            if demView == nil || repView == nil || indView == nil {
                demView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
                demView?.backgroundColor = color(for: "Democratic")
                addSubview(demView!)
                repView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
                repView?.backgroundColor = color(for: "Republican")
                addSubview(repView!)
                indView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: frame.height))
                indView?.backgroundColor = color(for: "Independent")
                addSubview(indView!)
            }
            
            updateDimensions()
        }
    }
    
    func updateDimensions() {
        demView?.frame.size.width = (fractions?.dem ?? 0) * frame.width
        repView?.frame.size.width = (fractions?.dem ?? 0) * frame.width
        indView?.frame.size.width = (fractions?.dem ?? 0) * frame.width
        
        repView?.frame.origin.x = demView?.frame.maxX ?? 0
        indView?.frame.origin.x = repView?.frame.maxX ?? 0
    }
}
