//
//  Setup views.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
import SCLAlertView

extension VisualizationViewController: CirclesMenuBarDelegate, UITableViewDelegate {
    func setupBar() {
        bar = CirclesMenuBar(frame: CGRect(x: 0, y: 10, width: view.frame.width, height: 60))
        bar.delegate = self
        if visualization == .geo {
            bar.addCircle(image: #imageLiteral(resourceName: "tag"), title: "Show connections")
        }
        bar.addCircle(image: #imageLiteral(resourceName: "congress"), title: "Chamber")
        bar.addCircle(image: #imageLiteral(resourceName: "usa"), title: "States")
        bar.addCircle(image: #imageLiteral(resourceName: "topics"), title: "Topics")
        bar.addCircle(image: #imageLiteral(resourceName: "party"), title: "Parties")
        view.addSubview(bar)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.frame.origin.x = tableView.frame.width / 4
        cell.alpha = 0
        
        UIView.animate(withDuration: 0.8) {
            cell.frame.origin.x = 0
            cell.alpha = 1
        }
    }
    
    func circlesMenuBar(_ bar: CirclesMenuBar, selected circle: CircleView, at index: Int) {
        let items = selectedItems[circle.title]!
        let frame = CGRect(x: 0, y: bar.frame.maxY + 30, width: view.frame.width, height: view.frame.height - bar.frame.maxY - 30)
        let table = CirclesTable(frame: frame, items: items, name: circle.title)
        table.delegate = self
        table.tag = 500 + index
        view.addSubview(table)
        
        view.backgroundColor = ColorPalette.primary
    }
    
    func circlesMenuBar(_ bar: CirclesMenuBar, deselected circle: CircleView, at index: Int) {
        view.backgroundColor = ColorPalette.primaryComplement
        view.viewWithTag(500 + index)?.removeFromSuperview()
    }
    
    func circlesMenuBar(_ closedBar: CirclesMenuBar) {
        geoVisualizationView?.updatedFilters(selectedItems)
        wheelVisualizationView?.updatedFilters(selectedItems)
        partVisualizationView?.updatedFilters(selectedItems)
    }
    
    func circlesMenuBarRequestsBack(_ bar: CirclesMenuBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let table = tableView as! CirclesTable
        let cell = tableView.cellForRow(at: indexPath) as! CirclesTableCell
        guard let checkbox = cell.checkbox else { return }
        
        if checkbox.markType == .radio {
            for i in 0..<table.items.count {
                table.items[i].checkState = .unchecked
            }
            
            checkbox.setCheckState(.checked, animated: true)
            table.items[indexPath.row].checkState = .checked
            
            if table.items[indexPath.row].title == "House of Representatives" && visualization == .wheel {
                if UserDefaults.standard.value(forKey: "hideWheelHouseWarning") == nil {
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
                    let alert = SCLAlertView(appearance: appearance)
                    alert.addButton("Ok", action: {})
                    alert.addButton("Don't show again", action: {
                        UserDefaults.standard.set(true, forKey: "hideWheelHouseWarning")
                    })
                    alert.showWarning("Warning", subTitle: "Your device cannot show all the representatives because its memory limit is too low. Filter by state or party for more precise and manageable data. Sorry for any inconvenience.")
                }
            }
            
            for visibleCell in tableView.visibleCells {
                guard let otherCheckbox = (visibleCell as! CirclesTableCell).checkbox else { return }
                if otherCheckbox != checkbox {
                    otherCheckbox.setCheckState(.unchecked, animated: true)
                }
            }
        } else {
            checkbox.setCheckState(checkbox.checkState == .checked ? .unchecked : .checked, animated: true)
            table.items[indexPath.row].checkState = checkbox.checkState
        }
        
        selectedItems[table.name] = table.items
    }
}
