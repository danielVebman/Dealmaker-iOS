//
//  VisualizationFilters.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/25/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import SwiftSpinner
import SCLAlertView

extension WheelVisualizationView {
    func fetchData() {
        SwiftSpinner.show(progress: 0, title: "")
        SwiftSpinner.show("Getting data from server")
        
        var components = URLComponents(string: "http://104.254.244.86/congresspersons/")!
        
        let chamber = selectedItems["Chamber"]!.filter { $0.checkState == .checked }.map { $0.title }.first!
        let states = selectedItems["States"]!.filter { $0.checkState == .checked }.map { $0.title }
        let parties = selectedItems["Parties"]!.filter { $0.checkState == .checked }.map { $0.title }
        let topics = selectedItems["Topics"]!.filter { $0.checkState == .checked }.map { $0.title }
        
        var filtersParam = [String: Any]()
        var topicsParam = [String]()
        
        if states.count > 0 { filtersParam["state"] = ["$in": states] }
        if chamber == "Senate" {
            filtersParam["type"] = "sen"
        } else {
            filtersParam["type"] = ["$in": ["rep", "del", "com"]]
        }
        if parties.count > 0 { filtersParam["party"] = ["$in": parties] }
        topicsParam = topics
        
        if filtersParam.count == 1 && filtersParam["type"] is [String: [String]] {
            SCLAlertView().showError("Cannot perform request", subTitle: "Your device cannot show all the representatives because its memory limit is too low. Filter by state or party for more precise and manageable data. Sorry for any inconvenience.")
            SwiftSpinner.hide()
            return
        }
        
        if let filtersData = try? JSONSerialization.data(withJSONObject: filtersParam, options: .prettyPrinted),
            let filtersStr = String(data: filtersData, encoding: .utf8),
            let topicsData = try? JSONSerialization.data(withJSONObject: topicsParam, options: .prettyPrinted),
            let topicsStr = String(data: topicsData, encoding: .utf8) {
            components.queryItems = [URLQueryItem(name: "filters", value: filtersStr)]
            if topics.count > 0 {
                components.queryItems!.append(URLQueryItem(name: "topics", value: topicsStr))
            }
        }
        
        let task = URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
            if error != nil {
                DispatchQueue.main.sync {
                    SwiftSpinner.hide()
                    _ = SCLAlertView().showError("Could not download data", subTitle: "The data download took too long. Consider using more filters for quicker download.")
                }
                return
            }
            guard let data = data else { return }
            self.parseData(data: data)
        }
        
        task.resume()
    }
}
