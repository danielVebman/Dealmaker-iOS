//
//  GeoVisDelegate.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/28/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit
import SwiftSpinner
import SCLAlertView
import MapKit

extension GeographicVisualizationView: MKMapViewDelegate {
    @objc func longPressed(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let touchLoc = gesture.location(in: self)
            let touchCoord = convert(touchLoc, toCoordinateFrom: self)
            let location = CLLocation(latitude: touchCoord.latitude, longitude: touchCoord.longitude)
            
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemark, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                if placemark?.first?.isoCountryCode != "US" { return }
                
                // get images and show only their connections
                
                SwiftSpinner.show(progress: 0, title: "")
                SwiftSpinner.show("Getting data from server")
                
                var components = URLComponents(string: "http://104.254.244.86/congresspersons/info/")!
                
                var filtersParam = [String: Any]()
                guard let stateAbbrev = placemark?.first?.administrativeArea else { return }
                filtersParam["abbrev"] = stateAbbrev
                let chamber = self.selectedItems["Chamber"]!.filter { $0.checkState == .checked }.map { $0.title }.first!
                filtersParam["type"] = chamber == "Senate" ? "sen" : ["$in": ["rep", "del", "com"]]
                if let filtersData = try? JSONSerialization.data(withJSONObject: filtersParam, options: .prettyPrinted),
                    let filtersStr = String(data: filtersData, encoding: .utf8) {
                    components.queryItems = [URLQueryItem(name: "filters", value: filtersStr)]
                }
                
                components.queryItems!.append(URLQueryItem(name: "weightDecatile", value: String(Int(self.weightDecatileSliderDrawer.slider.value))))
                
                URLSession.shared.dataTask(with: components.url!) { (data, response, error) in
                    if error != nil {
                        DispatchQueue.main.sync {
                            SwiftSpinner.hide()
                            _ = SCLAlertView().showError("Could not download data", subTitle: "The data download took too long. Consider using more filters for quicker download.")
                        }
                        return
                    }
                    
                    guard let data = data else { return }

                    let previouslyPresentAnnotations = self.visibleAnnotations
                    var annotations = [ImageAnnotation]()
                    for datum in data.split(separator: 0x0a) {
                        if  let json = try? JSONSerialization.jsonObject(with: datum, options: .allowFragments) as? [String: Any],
                            let imageUrl = json?["image-url"] as? String,
                            let name = json?["name"] as? String,
                            let coordinate = json?["coordinate"] as? [String: Double],
                            let party = json?["party"] as? String,
                            let state = json? ["abbrev"] as? String,
                            let id = json?["id"] as? String {
                            
                            if self.visibleAnnotations.keys.contains(id) {
                                DispatchQueue.main.sync {
                                    self.removeAnnotation(self.visibleAnnotations[id]!)
                                    self.visibleAnnotations.removeValue(forKey: id)
                                }
                                continue
                            }
                            
                            let anno = ImageAnnotation()
                            anno.url = "http://" + imageUrl
                            anno.title = formatPerson(name: name, party: party, state: state)
                            anno.coordinate = CLLocationCoordinate2D(latitude: coordinate["lat"]!, longitude: coordinate["lng"]!)
                            anno.borderColor = color(for: party)
                            self.visibleAnnotations[id] = anno
                            annotations.append(anno)
                        }
                    }
                    
                    DispatchQueue.main.sync {
                        SwiftSpinner.hide()
                        self.addAnnotations(annotations)
                        
                        for (id, anno) in previouslyPresentAnnotations {
                            self.removeAnnotation(anno)
                            self.visibleAnnotations.removeValue(forKey: id)
                        }
                    }
                }.resume()
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let url = (annotation as? ImageAnnotation)?.url {
            let view = ImageAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.imgView.loadAsyncFrom(url: url, placeholder: #imageLiteral(resourceName: "person_filled"))
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is USMapOverlay {
            SwiftSpinner.hide()
            return USMapOverlayView(overlay: overlay, overlayImage: mapImage!)
        } else if overlay is ImageOverlay {
            let renderer = ImageOverlayRenderer(overlay: overlay)
            renderer.placeholder = #imageLiteral(resourceName: "person_filled")
            if let url = (overlay as? ImageOverlay)?.url {
                renderer.getImageAsynchronously(url: url)
            }
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
}
