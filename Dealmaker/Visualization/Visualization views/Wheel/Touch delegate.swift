//
//  Touch delegate.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/31/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import Toast_Swift

extension WheelVisualizationView: UIGestureRecognizerDelegate {
    @objc func pressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            guard let circle = gesture.view as? Circle,
                let id = circle.id,
                let person = people?[id]
                else { return }
            
            toastInfo(of: person)
        }
    }
    
    func toastInfo(of person: Congressperson) {
        superview!.hideAllToasts()
        superview!.makeToast(person.formattedName)
    }
    
    @objc func tapped(_ gesture: UITapGestureRecognizer) {
        guard let circle = gesture.view as? Circle,
            let id = circle.id,
            let person = people?[id],
            let container = container,
            let minWeight = minWeight,
            let maxWeight = maxWeight
            else { return }
        
        if let selectedCircle = selectedCircle {
            if selectedCircle == circle {
                returnCircle(selectedCircle)
                connectionsImageView?.image = nil
                return
            } else {
                returnCircle(selectedCircle)
                centerCircle(circle)
                toastInfo(of: person)
            }
        } else {
            centerCircle(circle)
            toastInfo(of: person)
        }
        
        UIGraphicsBeginImageContext(CGSize(width: contentDim!, height: contentDim!))
        let context = UIGraphicsGetCurrentContext()
        
        for otherCircle in container.subviews {
            if otherCircle.tag == 404 { continue }
            guard let id = (otherCircle as! Circle).id,
                let weight = person.relationships[id]
                else { continue }
            if let otherPerson = people?[id] {
                let lineColor = color(for: otherPerson.party).withAlphaComponent(CGFloat(weight - minWeight) / CGFloat(maxWeight - minWeight))
                context?.setStrokeColor(lineColor.cgColor)
            } else {
                let lineColor = ColorPalette.primary.withAlphaComponent(CGFloat(weight - minWeight) / CGFloat(maxWeight - minWeight))
                context?.setStrokeColor(lineColor.cgColor)
            }
            context?.setLineWidth(pow(3, 4 * CGFloat(weight) / CGFloat(maxWeight)))
            context?.move(to: circle.center)
            context?.addLine(to: otherCircle.center)
            context?.strokePath()
        }
        
        connectionsImageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func returnCircle(_ circle: Circle) {
        selectedCircle = nil
        UIView.animate(withDuration: 0.25) {
            circle.center = circle.originalCenter
            circle.transform = CGAffineTransform.identity
        }
    }
    
    func centerCircle(_ circle: Circle) {
        selectedCircle = circle
        UIView.animate(withDuration: 0.25) {
            let scale = self.contentDim! / 4 / circle.frame.width
            circle.transform = CGAffineTransform(scaleX: scale, y: scale)
            circle.center = CGPoint(x: self.contentDim! / 2, y: self.contentDim! / 2)
        }
    }
}
