//
//  PartisanshipCell.swift
//  Dealmaker
//
//  Created by Daniel Vebman on 4/1/18.
//  Copyright © 2018 Daniel Vebman. All rights reserved.
//

import Foundation
import UIKit

class PartisanshipCell: UITableViewCell {
    var faceImage: AsyncImageView?
    var titleLabel: UILabel?
    var partisanshipSlider: PartisanshipSlider?
    
    var person: Congressperson? {
        didSet {
            titleLabel?.text = person?.formattedName
            let dem = CGFloat(person?.partisanship["Democratic"] ?? 0)
            let rep = CGFloat(person?.partisanship["Republican"] ?? 0)
            let ind = CGFloat(person?.partisanship["Independent"] ?? 0)
            let total = dem + rep + ind
            partisanshipSlider?.fractions = (dem: dem / total, rep: rep / total, ind: ind / total)
            
            if  let url = person?.imageUrl,
                let party = person?.party {
                faceImage?.loadAsyncFrom(url: url.absoluteString, placeholder: #imageLiteral(resourceName: "person_filled"))
                faceImage?.layer.borderColor = color(for: party).cgColor
            }
        }
    }
    
    override var frame: CGRect {
        didSet {
            let height: CGFloat = 50
            selectionStyle = .none
            backgroundColor = UIColor.clear
            
            if faceImage == nil || titleLabel == nil || partisanshipSlider == nil {
                faceImage = AsyncImageView(frame: CGRect(x: 5, y: 5, width: height - 10, height: height - 10))
                faceImage!.contentMode = .scaleAspectFill
                faceImage!.layer.cornerRadius = 0.5 * faceImage!.frame.height
                faceImage!.layer.borderWidth = 2
                faceImage!.clipsToBounds = true
                addSubview(faceImage!)
                
                titleLabel = UILabel(frame: CGRect(x: faceImage!.frame.maxX + 10, y: 0, width: 0, height: height - 20))
                titleLabel!.font = UIFont.titleFont(size: 20)
                titleLabel!.textColor = ColorPalette.primaryComplement
                titleLabel!.adjustsFontSizeToFitWidth = true
                titleLabel!.minimumScaleFactor = 0.2
                addSubview(titleLabel!)
                
                partisanshipSlider = PartisanshipSlider(frame: CGRect(x: faceImage!.frame.maxX + 10, y: height - 10 - 2, width: 0, height: 4))
                partisanshipSlider?.backgroundColor = UIColor.orange
                addSubview(partisanshipSlider!)
            }
            
            titleLabel!.frame.size.width = min(titleLabel!.text?.width(withFont: UIFont.titleFont(size: 20)) ?? 0, frame.width - titleLabel!.frame.origin.x - 15)
            partisanshipSlider!.frame.origin.x = titleLabel!.frame.origin.x
            partisanshipSlider!.frame.size.width = frame.width - partisanshipSlider!.frame.origin.x - 15
            partisanshipSlider!.clipsToBounds = true
        }
    }
}
