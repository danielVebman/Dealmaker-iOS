//
//  CircleBar.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class CirclesMenuBar: UIView {
    private(set) var circlesContainer: UIScrollView
    private(set) var circles = [CircleView]()
    
    var delegate: CirclesMenuBarDelegate?
    
    override var frame: CGRect {
        didSet {
            circlesContainer.frame = frame
        }
    }
    
    override init(frame: CGRect) {
        circlesContainer = UIScrollView(frame: frame)
        circlesContainer.backgroundColor = UIColor.clear
        circlesContainer.indicatorStyle = .white
        
        super.init(frame: frame)
        addSubview(circlesContainer)
        
        addCircle(image: #imageLiteral(resourceName: "back"), title: "Back")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCircle(image: UIImage, title: String) {
        let circle = CircleView(frame: CGRect(x: 0, y: 5, width: frame.height - 10, height: frame.height - 10), image: image, title: title, font: UIFont.titleFont(size: (frame.height - 20) / 2))
        circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(circleTapped(_:))))
        circles.append(circle)
        circle.backgroundColor = ColorPalette.primary
        circle.layer.cornerRadius = 0.5 * circle.frame.width
        let x = 10 + (circle.frame.width + 10) * CGFloat(circles.count - 1)
        circle.frame.origin.x = x
        circle.tag = circles.count - 1
        circlesContainer.contentSize = CGSize(width: 10 + x + circle.frame.width + 10, height: circlesContainer.frame.height)
        circlesContainer.addSubview(circle)
    }
}
