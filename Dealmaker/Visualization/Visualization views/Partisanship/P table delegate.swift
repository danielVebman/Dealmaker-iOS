//
//  P Draw table.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

extension PartisanshipVisualizationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.frame.origin.x = tableView.frame.width / 4
        cell.alpha = 0
        (cell as? PartisanshipCell)?.partisanshipSlider?.frame.origin.x = tableView.frame.width / 4
        
        UIView.animate(withDuration: 0.8, delay: 0, options: .allowUserInteraction, animations: {
            cell.frame.origin.x = 0
            cell.alpha = 1
        }, completion: nil)
    }
}
