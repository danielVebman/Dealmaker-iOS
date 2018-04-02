//
//  Data parser.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/26/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
import MapKit
import SCLAlertView

extension GeographicVisualizationView {
    func parseData(data: Data) {
        DispatchQueue.main.sync {
            _ = SwiftSpinner.show("Parsing")
        }
        
        var metadata: [String: Int]?
        var coordinates: [String: CLLocationCoordinate2D]?
        var people = [String: Congressperson]()
        
        for datum in data.split(separator: 0x0a) {
            guard
                let serialization = try? JSONSerialization.jsonObject(with: datum, options: .allowFragments),
                let json = serialization as? [String: Any]
                else { continue }
            
            if json.keys.contains("metadata") {
                metadata = json["metadata"] as? [String: Int]
                continue
            }
            
            if json.keys.contains("coordinates"), let coords = json["coordinates"] as? [String: [String: Double]] {
                for (id, coord) in coords {
                    if coordinates == nil {
                        coordinates = [String: CLLocationCoordinate2D]()
                    }
                    coordinates![id] = CLLocationCoordinate2D(latitude: coord["lat"]!, longitude: coord["lng"]!)
                }
                continue
            }
            
            let id = json["id"] as! String
            let name = json["name"] as! String
            let imageUrl = URL(string: "http://" + (json["image-url"] as! String))!
            let stateAbbrev = json["abbrev"] as! String
            let district = json["district"] as? String
            let type = json["type"] as! String
            let party = json["party"] as! String
            let relationships = json["relationships"] as! [String: Int]
            let person = Congressperson(name: name, imageUrl: imageUrl, stateAbbrev: stateAbbrev, district: district, type: type, party: party, relationships: relationships)
            people[id] = person
        }
        
        if let coordinates = coordinates, let metadata = metadata {
            setData(people, coordinates: coordinates, metadata: metadata)
        } else {
            DispatchQueue.main.sync {
                SwiftSpinner.hide()
                SCLAlertView().showError("Oh jeez", subTitle: "Something has gone horribly wrong! The server may have gone down or data may have corrupted. Please email me to let me know.").setDismissBlock {
                }
            }
        }
    }
    
    func setData(_ people: [String: Congressperson], coordinates: [String: CLLocationCoordinate2D], metadata: [String: Int]) {
        removeOverlays(overlays)
        
        if let maxWeight = metadata["maxWeight"], let minWeight = metadata["minWeight"] {
            drawLines(of: people, coordinates: coordinates, minWeight: minWeight, maxWeight: maxWeight)
            DispatchQueue.main.sync {
                _ = SwiftSpinner.show("Calculating connections")
            }
        } else {
            DispatchQueue.main.sync {
                _ = SwiftSpinner.hide()
                _ = SCLAlertView().showError("No data to show", subTitle: "Your filters are too restrictive. Perhaps you picked to show only delegate territories under the senators filter. (Delegates serve in the House.)")
            }
        }
    }
}
