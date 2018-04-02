//
//  Setup selected .swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

extension VisualizationViewController {
    func setupSelectedItems() {
        if let statesUrl = Bundle.main.url(forResource: "states", withExtension: "txt"), let string = try? String(contentsOf: statesUrl) {
            let states = string.split(separator: "\n").map { CirclesTableItem(title: String($0), markType: .checkmark, checkState: .unchecked) }
            selectedItems["States"] = states
        }
        
        if let topicsUrl = Bundle.main.url(forResource: "topics", withExtension: "txt"), let string = try? String(contentsOf: topicsUrl) {
            let topics = string.split(separator: "\n").map { CirclesTableItem(title: String($0), markType: .checkmark, checkState: .unchecked) }
            selectedItems["Topics"] = topics
        }
        
        selectedItems["Chamber"] = [
            CirclesTableItem(title: "Senate", markType: .radio, checkState: .checked),
            CirclesTableItem(title: "House of Representatives", markType: .radio, checkState: .unchecked)
        ]
        
        selectedItems["Parties"] = [
            CirclesTableItem(title: "Democratic", markType: .checkmark, checkState: .unchecked),
            CirclesTableItem(title: "Republican", markType: .checkmark, checkState: .unchecked),
            CirclesTableItem(title: "Independent", markType: .checkmark, checkState: .unchecked)
        ]
        
        if visualization == .geo {
            selectedItems["Show connections"] = [
                CirclesTableItem(title: "Only from filtered", markType: .radio, checkState: .checked),
                CirclesTableItem(title: "Only between filtered", markType: .radio, checkState: .unchecked)
            ]
        }
        
        geoVisualizationView?.updatedFilters(selectedItems)
        wheelVisualizationView?.updatedFilters(selectedItems)
        partVisualizationView?.updatedFilters(selectedItems)
    }
}
