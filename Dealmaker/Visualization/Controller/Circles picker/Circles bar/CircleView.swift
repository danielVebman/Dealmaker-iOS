//
//  CircleView.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class CircleView: UIView {
    var image: UIImage
    var title: String
    var font: UIFont
    
    private var imageView: UIImageView!
    private var textLabel: UILabel!
    
    init(frame: CGRect, image: UIImage, title: String, font: UIFont) {
        self.image = image
        self.title = title
        self.font = font
        super.init(frame: frame)
        
        clipsToBounds = true
        
        imageView = UIImageView(frame: bounds)
        imageView.frame = imageView.frame.insetBy(dx: 10, dy: 10)
        imageView.tintColor = ColorPalette.primaryComplement
        imageView.image = image.withRenderingMode(.alwaysTemplate)
        addSubview(imageView)
        
        textLabel = UILabel(frame: CGRect(x: frame.width, y: 0, width: title.width(withFont: font), height: frame.height))
        textLabel.font = font
        textLabel.textColor = ColorPalette.primaryComplement
        textLabel.text = title
        addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension String {
    func width(withFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

