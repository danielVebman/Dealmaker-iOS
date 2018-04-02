//
//  SliderDrawer.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/28/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class WeightDecatileSliderDrawer: UIView {
    var textButton: UIButton!
    var slider: UISlider!
    
    private(set) var open = false
    private(set) var maxWidth: CGFloat
    
    var delegate: WeightDecatileSliderDrawerDelegate?
    
    override init(frame: CGRect) {
        maxWidth = frame.width
        
        super.init(frame: frame)
        
        layer.cornerRadius = 0.5 * frame.height
        clipsToBounds = true
        backgroundColor = ColorPalette.primary
        
        textButton = UIButton(type: .system)
        textButton.frame = CGRect(x: 20, y: 0, width: 0, height: frame.height)
        textButton.titleLabel?.font = UIFont.titleFont(size: (frame.height - 20) / 2)
        textButton.setTitleColor(ColorPalette.primaryComplement, for: .normal)
        textButton.setTitle("Connection strength", for: .normal)
        textButton.addTarget(self, action: #selector(toggleOpen), for: .touchUpInside)
        textButton.frame.size.width = "Connection strength".width(withFont: UIFont.titleFont(size: (frame.height - 20) / 2))
        addSubview(textButton)
        
        self.frame.size.width = textButton.frame.size.width + 40
        
        slider = UISlider(frame: CGRect(x: frame.width, y: 0, width: 0, height: frame.height))
        slider.addTarget(self, action: #selector(sliderDidSlide(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderDidRelease(_:)), for: [.touchUpInside, .touchUpOutside])
        slider.minimumValue = 0
        slider.maximumValue = 9
        slider.value = 9
        slider.maximumTrackTintColor = ColorPalette.primaryComplement
        slider.minimumTrackTintColor = ColorPalette.primaryComplement
        slider.thumbTintColor = ColorPalette.primaryComplement
        slider.alpha = 0
        addSubview(slider)
    }
    
    @objc func sliderDidSlide(_ slider: UISlider) {
        slider.value = round(slider.value)
    }
    
    @objc func sliderDidRelease(_ slider: UISlider) {
        delegate?.weightDecatileSliderDrawer(self, didSelect: Int(slider.value))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func toggleOpen() {
        if open { // close
            UIView.animate(withDuration: 0.25, animations: {
                self.textButton.setTitle("Connection strength", for: .normal)
                self.textButton.frame.size.width = "Connection strength".width(withFont: UIFont.titleFont(size: (self.frame.height - 20) / 2))
                self.frame.size.width = self.textButton.frame.size.width + 40
                self.slider.frame.origin.x = self.frame.width
                self.slider.alpha = 0
            })
        } else { // open
            UIView.animate(withDuration: 0.25, animations: {
                self.frame.size.width = self.maxWidth
                self.textButton.setTitle("Strength", for: .normal)
                self.textButton.frame.size.width = "Strength".width(withFont: UIFont.titleFont(size: (self.frame.height - 20) / 2))
                self.slider.frame.size.width = self.frame.width - self.textButton.frame.maxX - 40
                self.slider.frame.origin.x = self.textButton.frame.maxX + 20
                self.slider.alpha = 1
            })
        }
        
        open = !open
    }
}

protocol WeightDecatileSliderDrawerDelegate {
    func weightDecatileSliderDrawer(_ drawer: WeightDecatileSliderDrawer, didSelect decatile: Int)
}
