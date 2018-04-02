//
//  Visualization helper.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

extension VisualizationViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.bar.frame.size.width = size.width
            self.geoVisualizationView?.frame.size = size
            self.wheelVisualizationView?.frame.size = size
            self.partVisualizationView?.frame.size = size
            for v in self.view.subviews {
                if v.tag > 500, let table = v as? UITableView, let visibleRows = table.indexPathsForVisibleRows {
                    table.frame.size.width = size.width
                    table.reloadRows(at: visibleRows, with: UITableViewRowAnimation.fade)
                }
            }
        }, completion: nil)
    }
}
