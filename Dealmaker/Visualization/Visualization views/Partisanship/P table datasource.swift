//
//  P table datasource.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

extension PartisanshipVisualizationView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PartisanshipCell
        cell.person = people[indexPath.row]
        return cell
    }
}
