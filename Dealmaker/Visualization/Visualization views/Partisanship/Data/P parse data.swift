//
//  P parse data.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
import MapKit
import SCLAlertView

extension PartisanshipVisualizationView {
    func parseData(data: Data) {
        DispatchQueue.main.sync {
            _ = SwiftSpinner.show("Parsing")
        }
        
        people.removeAll()
        
        for datum in data.split(separator: 0x0a) {
            guard
                let serialization = try? JSONSerialization.jsonObject(with: datum, options: .allowFragments),
                let json = serialization as? [String: Any]
                else { continue }
            
            let name = json["name"] as! String
            let imageUrl = URL(string: "http://" + (json["image-url"] as! String))!
            let stateAbbrev = json["abbrev"] as! String
            let type = json["type"] as! String
            let party = json["party"] as! String
            let partisanship = json["partisanship"] as! [String: Int]
            
            let person = Congressperson(name: name, imageUrl: imageUrl, stateAbbrev: stateAbbrev, type: type, party: party, partisanship: partisanship)
            people.append(person)
            
            people.sort { $0.partisanshipScore ?? 0 < $1.partisanshipScore ?? 0 }
        }
        
        DispatchQueue.main.sync {
            SwiftSpinner.hide()
            reloadData()
        }
    }
}
