//
//  InformationTableCell.swift
//  IntuitDemoProject
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit

class InformationTableCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}

extension InformationTableCell {
    
    func loaData(details: ResultDetails) {
        
        var attributedString = NSMutableAttributedString()

        attributedString = NSMutableAttributedString(string: "\(details.title)\n\n\(details.extract)\n\n\n\n\n\n\n\nCopyright © 2020 Vipul Kumar. All rights reserved")
        attributedString.setColorFontForText(textForAttribute: details.title, withColor: UIColor.black, fontSize: 24, weight: .bold, alignment: .center)
        attributedString.setColorFontForText(textForAttribute: details.extract, withColor: UIColor.darkGray, fontSize: 16, weight: .regular, alignment: .left)
        attributedString.setColorFontForText(textForAttribute: "Copyright © 2020 Vipul Kumar. All rights reserved", withColor: UIColor.lightGray, fontSize: 10, weight: .regular, alignment: .center)
        self.titleLabel.attributedText = attributedString
        
    }
}

