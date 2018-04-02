//
//  CirclesTable.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import M13Checkbox

class CirclesTable: UITableView {
    var items: [CirclesTableItem]
    var name: String
    
    init(frame: CGRect, items: [CirclesTableItem], name: String) {
        self.name = name
        self.items = items
        super.init(frame: frame, style: .plain)
        
        backgroundColor = ColorPalette.primary
        separatorStyle = .none
        rowHeight = 50
        
        dataSource = self
        register(CirclesTableCell.self, forCellReuseIdentifier: "cell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


