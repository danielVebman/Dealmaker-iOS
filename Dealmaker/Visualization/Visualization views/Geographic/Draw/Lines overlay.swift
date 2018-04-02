//
//  Lines overlay.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/27/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import MapKit

class USMapOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    init(overlay: MKOverlay, overlayImage: UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else { return }
        let rect = self.rect(for: overlay.boundingMapRect)
        context.draw(imageReference, in: rect)
    }
}

class USMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(boundingRect: MKMapRect, coord: CLLocationCoordinate2D) {
        boundingMapRect = boundingRect
        coordinate = coord
    }
}

