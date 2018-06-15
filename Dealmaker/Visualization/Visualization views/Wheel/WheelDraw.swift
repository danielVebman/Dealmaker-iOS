//
//  WheelDrawLines.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/31/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import SwiftSpinner
import UIKit

extension WheelVisualizationView {
    func drawLines(of people: [String: Congressperson]) {
        SwiftSpinner.show("Drawing")
        
        self.people = people
        selectedCircle = nil
        contentDim = 10 + (60 + 10) * CGFloat(people.count / 2)
        if people.count < 6 {
            contentDim = 10 + (60 + 10) * CGFloat(6 / 2)
        }
        
        contentSize = CGSize(width: contentDim!, height: contentDim!)
        minimumZoomScale = frame.width / contentSize.width
        container?.removeFromSuperview()
        container = UIView(frame: CGRect(origin: CGPoint.zero, size: contentSize))
        container?.backgroundColor = UIColor.clear
        addSubview(container!)
        
        searchTextField = UITextField(frame: CGRect(x: 0, y: 0, width: contentSize.width * 2 / 3, height: contentSize.width / 10))
        searchTextField!.font = UIFont.systemFont(ofSize: searchTextField!.frame.height * 4 / 5)
        searchTextField!.placeholder = "Search"
        searchTextField!.autocapitalizationType = .words
        searchTextField!.autocorrectionType = .no
        searchTextField!.center = CGPoint(x: contentSize.width / 2, y: contentSize.height / 2)
        searchTextField!.textAlignment = .center
        searchTextField!.returnKeyType = .done
        searchTextField!.delegate = self
        searchTextField!.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        container?.addSubview(searchTextField!)
        
        connectionsImageView?.removeFromSuperview()
        connectionsImageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: contentDim!, height: contentDim!)))
        connectionsImageView!.contentMode = .scaleToFill
        connectionsImageView?.tag = 404
        container?.addSubview(connectionsImageView!)
        
        contentOffset = CGPoint.zero
        zoomScale = minimumZoomScale
        
        let circleRadius: CGFloat = 30
        let radius = contentDim! / 2 - 10 - 30
        let step = 2 * CGFloat.pi / CGFloat(people.count)
        var theta: CGFloat = 0
        
        let center = CGPoint(x: contentDim! / 2, y: contentDim! / 2)
        
        for (id, person) in people {
            let circle = Circle(frame: CGRect(x: 0, y: 0, width: circleRadius * 2, height: circleRadius * 2))
            circle.loadAsyncFrom(url: person.imageUrl.absoluteString, placeholder: #imageLiteral(resourceName: "person_filled"))
            circle.tintColor = color(for: person.party)
            circle.contentMode = .scaleAspectFill
            circle.layer.cornerRadius = circleRadius
            circle.clipsToBounds = true
            circle.center = CGPoint(x: center.x + radius * cos(theta), y: center.y + radius * sin(theta))
            circle.originalCenter = circle.center
            circle.id = id
            circle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped(_:))))
            circle.layer.borderWidth = 2
            circle.layer.borderColor = color(for: person.party).cgColor
            let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressed(_:)))
            longGesture.minimumPressDuration = 0.5
            circle.addGestureRecognizer(longGesture)
            circle.isUserInteractionEnabled = true
            container?.addSubview(circle)
            
            theta += step
        }
        
        SwiftSpinner.hide()
    }
}
