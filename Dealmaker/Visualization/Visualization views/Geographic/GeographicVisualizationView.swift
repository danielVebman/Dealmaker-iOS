//
//  GeographicVisualizationView.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/24/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftSpinner
import SCLAlertView

class GeographicVisualizationView: MKMapView, WeightDecatileSliderDrawerDelegate {
    private(set) var weightDecatileSliderDrawer: WeightDecatileSliderDrawer!
    var selectedItems = [String: [CirclesTableItem]]()
    var mapImage: UIImage?
    
    var visibleAnnotations = [String: ImageAnnotation]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        weightDecatileSliderDrawer = WeightDecatileSliderDrawer(frame: CGRect(x: 10, y: 20 + 80, width: 300, height: 50))
        weightDecatileSliderDrawer.delegate = self
        addSubview(weightDecatileSliderDrawer)
        
        mapType = .mutedStandard
        delegate = self
        
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatedFilters(_ filters: [String: [CirclesTableItem]]) {
        self.selectedItems = filters
        fetchData()
    }
    
    func weightDecatileSliderDrawer(_ drawer: WeightDecatileSliderDrawer, didSelect decatile: Int) {
        fetchData()
    }
}
