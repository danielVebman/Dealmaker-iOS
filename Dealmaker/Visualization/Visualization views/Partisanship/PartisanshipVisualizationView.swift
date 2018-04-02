//
//  PartisanshipVisualizationView.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class PartisanshipVisualizationView: UITableView {
    var selectedItems = [String: [CirclesTableItem]]()
    var people = [Congressperson]()
    
    init(frame: CGRect) {
        super.init(frame: frame, style: .plain)
        
        backgroundColor = ColorPalette.primary
        separatorStyle = .none
        rowHeight = 50
        dataSource = self
        delegate = self
        contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        
        register(PartisanshipCell.self, forCellReuseIdentifier: "cell")
    }
    
    func updatedFilters(_ filters: [String: [CirclesTableItem]]) {
        self.selectedItems = filters
        fetchData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
