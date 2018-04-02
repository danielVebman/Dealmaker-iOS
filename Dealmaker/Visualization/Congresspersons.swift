//
//  Congresspersons.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/31/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

struct Congressperson {
    var name: String
    var imageUrl: URL
    var stateAbbrev: String
    var district: String?
    var type: String
    var party: String
    var relationships: [String: Int]
    var partisanship: [String: Int]
    
    var formattedName: String {
        return formatPerson(name: name, party: party, state: stateAbbrev)
    }
    
    var partisanshipScore: CGFloat? {
        if let weight = partisanship[party], let total = partisanship["weightTotal"] {
            return CGFloat(weight) / CGFloat(total)
        }
        return nil
    }
    
    init(name: String, imageUrl: URL, stateAbbrev: String, district: String?, type: String, party: String, relationships: [String: Int]) {
        partisanship = [String: Int]()
        self.name = name
        self.imageUrl = imageUrl
        self.stateAbbrev = stateAbbrev
        self.district = district
        self.type = type
        self.party = party
        self.relationships = relationships
    }
    
    init(name: String, imageUrl: URL, stateAbbrev: String, type: String, party: String, partisanship: [String: Int]) {
        self.init(name: name, imageUrl: imageUrl, stateAbbrev: stateAbbrev, district: "", type: type, party: party, relationships: [:])
        self.partisanship = partisanship
    }
}

func formatPerson(name: String, party: String, state: String) -> String {
    let nameParts = name.split(separator: ",")
    var fullname = String(nameParts[1] + " " + nameParts[0] + nameParts[2..<nameParts.count].joined(separator: ", "))
    while fullname.first == " " {
        fullname.remove(at: fullname.startIndex)
    }
    let info = abbreviateParty(party) + " " + state
    return fullname + " (" + info + ")"
}

func abbreviateParty(_ party: String) -> String {
    switch party {
    case "Democratic": return "Dem."
    case "Republican": return "Rep."
    default: return "Ind."
    }
}

func color(for party: String) -> UIColor {
    switch party {
    case "Democratic": return UIColor(rgb: 0x3A85FF)
    case "Republican": return UIColor(rgb: 0xF73640)
    default: return UIColor(rgb: 0xB2B2B2)
    }
}
