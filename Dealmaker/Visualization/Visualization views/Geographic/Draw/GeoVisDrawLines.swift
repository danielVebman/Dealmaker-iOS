//
//  GeoVisDrawLines.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/28/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import SwiftSpinner

extension GeographicVisualizationView {
    func drawLines(of people: [String: Congressperson], coordinates: [String: CLLocationCoordinate2D], minWeight: Int, maxWeight: Int) {
        let bottomLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: -15, longitude: -175))
        let topRight = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: 70, longitude: -67))
        DispatchQueue.main.sync {
            _ = SwiftSpinner.show(progress: 0, title: "Drawing")
        }
        
        let k: Double = 0.0001
        let size = CGSize(width: abs(topRight.x - bottomLeft.x) * k, height: abs(topRight.y - bottomLeft.y) * k)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        
        var addedConnectionIds = [String]()
        var i: Double = 0
        for (id, person) in people {
            for (otherId, weight) in person.relationships {
                if selectedItems["Show connections"]!.first!.checkState == .checked { // only from filtered
                    if !(coordinates.keys.contains(otherId)) {
                        continue
                    }
                } else { // only between filtered
                    if !(people.keys.contains(otherId)) {
                        continue
                    }
                }
                
                let connectionId = [id, otherId].sorted().joined(separator: "|")
                if addedConnectionIds.contains(connectionId) { continue }
                addedConnectionIds.append(connectionId)
                
//                let color = UIColor(hue: 120 / 360, saturation: 60 / 100, lightness: 1 - CGFloat(weight - minWeight) / CGFloat(maxWeight - minWeight))//.withAlphaComponent(CGFloat(weight - minWeight) / CGFloat(maxWeight - minWeight))
                let color = ColorPalette.primary.withAlphaComponent(CGFloat(weight - minWeight) / CGFloat(maxWeight - minWeight))
                
                let loc = MKMapPointForCoordinate(coordinates[id]!)
                context.move(to: CGPoint(x: abs(loc.x - bottomLeft.x) * k, y: abs(loc.y - bottomLeft.y) * k))
                context.setStrokeColor(color.cgColor)
                context.setLineWidth(1)
                let otherLoc = MKMapPointForCoordinate(coordinates[otherId]!)
                context.addLine(to: CGPoint(x: abs(otherLoc.x - bottomLeft.x) * k, y: abs(otherLoc.y - bottomLeft.y) * k))
                context.strokePath()
            }
            
            i+=1
            DispatchQueue.main.sync {
                _ = SwiftSpinner.show(progress: i / Double(people.count), title: "Drawing")
            }
        }
        
        mapImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var overlayBoundingMapRect: MKMapRect {
            get {
                let topLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: 70, longitude: -175))
                let topRight = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: 70, longitude: -67))
                let bottomLeft = MKMapPointForCoordinate(CLLocationCoordinate2D(latitude: -15, longitude: -175))
                return MKMapRectMake(topLeft.x, topLeft.y, fabs(topLeft.x - topRight.x), fabs(topLeft.y - bottomLeft.y))
            }
        }
        
        let center = CLLocationCoordinate2D(latitude: 27.5, longitude: -121)
        DispatchQueue.main.sync {
            add(USMapOverlay(boundingRect: overlayBoundingMapRect, coord: center))
        }
    }
}
