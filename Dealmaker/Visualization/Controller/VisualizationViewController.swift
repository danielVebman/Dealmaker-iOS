//
//  VisualizationViewController.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/24/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class VisualizationViewController: UIViewController, UIViewControllerTransitioningDelegate {
    enum Visualization {
        case geo, wheel, part
    }
    
    var selectedItems = [String: [CirclesTableItem]]()
    
    var bar: CirclesMenuBar!
    var geoVisualizationView: GeographicVisualizationView?
    var wheelVisualizationView: WheelVisualizationView?
    var partVisualizationView: PartisanshipVisualizationView?
    
    private(set) var visualization: Visualization
    init(visualization: Visualization) {
        self.visualization = visualization
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = ColorPalette.primaryComplement
        
        switch visualization {
        case .geo:
            geoVisualizationView = GeographicVisualizationView(frame: view.bounds)
            view.addSubview(geoVisualizationView!)
        case .wheel:
            wheelVisualizationView = WheelVisualizationView(frame: view.bounds)
            view.addSubview(wheelVisualizationView!)
        case .part:
            partVisualizationView = PartisanshipVisualizationView(frame: view.bounds)
            view.addSubview(partVisualizationView!)
        }
        
        setupSelectedItems()
        setupBar()
    }
}

