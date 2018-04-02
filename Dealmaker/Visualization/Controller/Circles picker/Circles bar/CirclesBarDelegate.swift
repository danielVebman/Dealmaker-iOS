//
//  CirclesBarDelegate.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import SCLAlertView

extension CirclesMenuBar {
    @objc func circleTapped(_ gesture: UITapGestureRecognizer) {
        guard let circle = gesture.view as? CircleView else { return }
        
        if circle.title == "Back" {
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            alert.addButton("Nevermind", action: { })
            alert.addButton("Exit", action: {
                self.delegate?.circlesMenuBarRequestsBack(self)
            })
            alert.showWarning("Exit visualization", subTitle: "Are you sure you want to leave this visualization?")
            return
        }
        
        let newWidth = circle.frame.height < circle.frame.width ? circle.frame.height : circle.frame.width + circle.title.width(withFont: circle.font) + 10
        
        var circlesDeselected = [CircleView]()
        var circlesSelected = [CircleView]()
        
        UIView.animate(withDuration: 0.25) {
            for otherCircle in self.circles {
                if otherCircle.frame.width > otherCircle.frame.height {
                    circlesDeselected.append(otherCircle)
                    otherCircle.frame.size.width = otherCircle.frame.size.height
                }
                otherCircle.backgroundColor = ColorPalette.primary
            }
            
            circle.frame.size.width = newWidth
            
            for i in 1..<self.circles.count {
                self.circles[i].frame.origin.x = self.circles[i-1].frame.maxX + 10
            }
            
            if circle.frame.width > circle.frame.height {
                self.circlesContainer.setContentOffset(CGPoint(x: circle.frame.origin.x - 10, y: 0), animated: true)
                self.circlesContainer.contentSize.width = max(self.circles.last!.frame.maxX + 10, self.frame.width + circle.frame.origin.x - 10)
                circlesSelected.append(circle)
                circle.backgroundColor = UIColor.lightGray
            } else {
                self.circlesContainer.contentSize.width = self.circles.last!.frame.maxX + 10
            }
        }
        
        for c in circlesDeselected {
            self.delegate?.circlesMenuBar(self, deselected: c, at: c.tag)
        }
        
        for c in circlesSelected {
            self.delegate?.circlesMenuBar(self, selected: c, at: circle.tag)
        }
        
        if circlesSelected.count == 0 {
            delegate?.circlesMenuBar(self)
        }
    }   
}

protocol CirclesMenuBarDelegate {
    func circlesMenuBar(_ bar: CirclesMenuBar, selected circle: CircleView, at index: Int)
    func circlesMenuBar(_ bar: CirclesMenuBar, deselected circle: CircleView, at index: Int)
    func circlesMenuBar(_ closedBar: CirclesMenuBar)
    func circlesMenuBarRequestsBack(_ bar: CirclesMenuBar)
}
