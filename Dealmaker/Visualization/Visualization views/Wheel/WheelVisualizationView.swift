//
//  FerrisWheelVisualizationView.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 3/31/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class WheelVisualizationView: UIScrollView, UIScrollViewDelegate {
    var selectedItems = [String: [CirclesTableItem]]()
    var container: UIView?
    var searchTextField: UITextField?
    var selectedCircle: Circle?
    var connectionsImageView: UIImageView?
    var contentDim: CGFloat?
    
    var people: [String: Congressperson]?
    var minWeight: Int?
    var maxWeight: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = ColorPalette.primaryComplement
        maximumZoomScale = 5
        delegate = self
        contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 0, right: 0)
        contentOffset = CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatedFilters(_ filters: [String: [CirclesTableItem]]) {
        self.selectedItems = filters
        fetchData()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return container
    }
}

class Circle: AsyncImageView {
    var originalCenter: CGPoint!
    var id: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        originalCenter = center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
