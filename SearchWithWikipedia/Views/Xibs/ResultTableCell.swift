//
//  ResultTableCell.swift
//  PhotoListingApp
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var representedLetters: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialSetup()
    }
}

extension ResultTableCell {
    
    fileprivate func initialSetup() {
        
        self.photoImage.backgroundColor = UIColor.lightGray
        self.photoImage.clipsToBounds = true
        self.photoImage.layer.cornerRadius = self.photoImage.frame.height / 2
        self.representedLetters.clipsToBounds = true
        self.representedLetters.layer.cornerRadius = self.photoImage.frame.height / 2
    }
    
    func load(result: Page) {

        self.photoImage.setImage(with: URL(string: result.source), placeholderImage: nil)
        self.titleLabel.text = result.title
        self.descriptionLabel.text = result.termsDescription.first ?? ". . ."
        
        self.representedLetters.isHidden = !result.source.isEmpty
        self.representedLetters.text = result.representedLetters
        self.representedLetters.backgroundColor = result.ranomColor
    }
}
