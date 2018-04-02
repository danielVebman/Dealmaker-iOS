//
//  ViewController.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/24/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var hideStatusBar = false
    
    var logoView: LogoAnimationView!
    var appNameLabel: UILabel!
    
    var taskLabel: UILabel!
    var geoVisButton: UIButton!
    var wheelVisButton: UIButton!
    var partisanshipVisButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = ColorPalette.primaryComplement
        
        logoView = LogoAnimationView(height: 80)
        logoView.frame.origin = CGPoint(x: (view.frame.width - logoView.frame.width) / 2, y: 50)
        view.addSubview(logoView)
        
        appNameLabel = UILabel(frame: CGRect(x: 0, y: logoView.frame.maxY, width: view.frame.width, height: 100))
        appNameLabel.textColor = ColorPalette.primary
        appNameLabel.font = UIFont.titleFont(size: 50)
        appNameLabel.textAlignment = .center
        appNameLabel.text = "Dealmaker"
        view.addSubview(appNameLabel)
        
        taskLabel = UILabel(frame: CGRect(x: 20, y: appNameLabel.frame.maxY + 20, width: view.frame.width - 40, height: 20))
        taskLabel.text = "Select a visualization"
        taskLabel.textAlignment = .center
        taskLabel.font = UIFont.titleFont(size: 20)
        view.addSubview(taskLabel)
        
        geoVisButton = UIButton(type: .system)
        geoVisButton.frame = CGRect(x: 0, y: taskLabel.frame.maxY, width: 150, height: 150)
        geoVisButton.center.x = view.frame.width * 2 / 7
        geoVisButton.setImage(#imageLiteral(resourceName: "usa_map"), for: .normal)
        geoVisButton.tintColor = ColorPalette.primary
        geoVisButton.set(subtitle: "Geographic", font: UIFont.titleFont(size: 15), color: ColorPalette.primary)
        geoVisButton.addTarget(self, action: #selector(showGeoVis), for: .touchUpInside)
        view.addSubview(geoVisButton)
        
        wheelVisButton = UIButton(type: .system)
        wheelVisButton.frame = CGRect(x: 0, y: taskLabel.frame.maxY, width: 150, height: 150)
        wheelVisButton.center.x = view.frame.width * 5 / 7
        wheelVisButton.setImage(#imageLiteral(resourceName: "wheel"), for: .normal)
        wheelVisButton.tintColor = ColorPalette.primary
        wheelVisButton.set(subtitle: "Wheel", font: UIFont.titleFont(size: 15), color: ColorPalette.primary)
        wheelVisButton.addTarget(self, action: #selector(showWheelVis), for: .touchUpInside)
        view.addSubview(wheelVisButton)
        
        partisanshipVisButton = UIButton(type: .system)
        partisanshipVisButton.frame = CGRect(x: 0, y: wheelVisButton.frame.maxY, width: 150, height: 150)
        partisanshipVisButton.center.x = view.frame.midX
        partisanshipVisButton.setImage(#imageLiteral(resourceName: "rank"), for: .normal)
        partisanshipVisButton.tintColor = ColorPalette.primary
        partisanshipVisButton.set(subtitle: "Partisanship", font: UIFont.titleFont(size: 15), color: ColorPalette.primary)
        partisanshipVisButton.addTarget(self, action: #selector(showPartisanshipVis), for: .touchUpInside)
        view.addSubview(partisanshipVisButton)
        
        setPositions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.25) {
            self.setPositions()
        }
        logoView.showFlagLines()
    }
    
    @objc func showGeoVis() {
        let controller = VisualizationViewController(visualization: .geo)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func showWheelVis() {
        let controller = VisualizationViewController(visualization: .wheel)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func showPartisanshipVis() {
        let controller = VisualizationViewController(visualization: .part)
        present(controller, animated: true, completion: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.logoView.center.x = size.width / 2
            self.appNameLabel.center.x = size.width / 2
            self.taskLabel.center.x = size.width / 2
            self.setPositions()
        }, completion: nil)
    }
    
    func setPositions() {
        let size = view.frame.size
        
        if UIDevice.current.model.contains("iPad") {
            logoView.frame.origin.y = 50
            appNameLabel.frame.origin.y = logoView.frame.maxY
            taskLabel.frame.origin.y = appNameLabel.frame.maxY + 20
            geoVisButton.center.x = size.width * 1 / 4
            wheelVisButton.center.x = size.width * 2 / 4
            partisanshipVisButton.center.x = size.width * 3 / 4
            geoVisButton.frame.origin.y = taskLabel.frame.maxY + 20
            wheelVisButton.frame.origin.y = taskLabel.frame.maxY + 20
            partisanshipVisButton.frame.origin.y = taskLabel.frame.maxY + 20
            
            return
        }
        
        if size.width < size.height { // portrait
            logoView.frame.origin.y = 50
            appNameLabel.frame.origin.y = logoView.frame.maxY
            taskLabel.frame.origin.y = appNameLabel.frame.maxY + 20
            geoVisButton.center.x = size.width * 2 / 7
            wheelVisButton.center.x = size.width * 5 / 7
            partisanshipVisButton.center.x = size.width / 2
            geoVisButton.frame.origin.y = taskLabel.frame.maxY
            wheelVisButton.frame.origin.y = taskLabel.frame.maxY
            partisanshipVisButton.frame.origin.y = geoVisButton.frame.maxY
            
            hideStatusBar = false
        } else { // landscape
            logoView.frame.origin.y = 10
            appNameLabel.frame.origin.y = logoView.frame.maxY - 20
            taskLabel.frame.origin.y = appNameLabel.frame.maxY
            geoVisButton.center.x = size.width * 1 / 4
            wheelVisButton.center.x = size.width * 2 / 4
            partisanshipVisButton.center.x = size.width * 3 / 4
            geoVisButton.frame.origin.y = taskLabel.frame.maxY
            wheelVisButton.frame.origin.y = taskLabel.frame.maxY
            partisanshipVisButton.frame.origin.y = taskLabel.frame.maxY
            
            hideStatusBar = true
        }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return hideStatusBar
    }
}
