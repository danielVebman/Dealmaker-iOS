//
//  ViewController.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/24/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    var logoView: LogoAnimationView!
    var appNameLabel: UILabel!
    
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        logoView.showFlagLines()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.logoView.center.x = size.width / 2
            self.appNameLabel.center.x = size.width / 2
        }, completion: nil)
    }
    
}
