//
//  ImageAnnotation.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/28/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ImageOverlayRenderer: MKCircleRenderer {
    var image: UIImage?
    var placeholder: UIImage?
    
    func getImageAsynchronously(url: String) {
        
    }
    
    override func fillPath(_ path: CGPath, in context: CGContext) {
//        print("DRAW:", placeholder != nil, image != nil)
        
        context.setFillColor(UIColor.blue.cgColor)
        context.fillPath()
        
        let frame = rect(for: overlay.boundingMapRect)
        UIGraphicsPushContext(context)
        if let img = image {
            img.draw(in: frame)
        } else if let img = placeholder {
            img.draw(in: frame)
        }
        UIGraphicsPopContext()
    }
    
    override func canDraw(_ mapRect: MKMapRect, zoomScale: MKZoomScale) -> Bool {
        return placeholder != nil || image != nil
    }
}

class ImageOverlay: MKCircle {
    var url: String?
}

class ImageAnnotation: MKPointAnnotation {
    var url: String?
    var borderColor: UIColor?
}

class ImageAnnotationView: MKAnnotationView {
    private(set) var imgView: AsyncImageView!
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        canShowCallout = true
        frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        
        imgView = AsyncImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 0.5 * frame.height
        imgView.layer.borderColor = (annotation as? ImageAnnotation)?.borderColor?.cgColor
        imgView.layer.borderWidth = 2
        imgView.clipsToBounds = true
        imgView.frame = bounds
        addSubview(imgView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

