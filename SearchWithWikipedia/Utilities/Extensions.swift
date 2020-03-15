//
//  Extensions.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

extension UIImageView {
    
    func cancelCurrentImageLoad() {
        sd_cancelCurrentImageLoad()
    }
    
    func setImage(with url: URL?, placeholderImage image: UIImage?) {
        sd_setImage(with: url, placeholderImage: image)
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

//MARK:- To generate ranom color
//******************************
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
    
    static var randomColor: UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension String {
    
    func getFirstTwoLetters() -> String {
        
        return self.components(separatedBy: " ")
            .prefix(2)
            .reduce("", { (firstValue, secondValue) -> String in
                if let firstStr = firstValue.first {
                    if let secondStr = secondValue.first {
                        return (String(firstStr) + " " + String(secondStr)).uppercased()
                    } else {
                        return String(firstValue).uppercased()
                    }
                } else {
                    if let firstChar = self.first {
                        return String(firstChar).uppercased()
                    } else {
                        return "#"
                    }
                }
            })
    }
}

extension NSMutableAttributedString {
    
    func setColorFontForText(textForAttribute: String, withColor color: UIColor, fontSize: CGFloat, weight: UIFont.Weight = .regular, alignment: NSTextAlignment = .left) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        self.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: fontSize, weight: weight), range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 0.3
        self.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
    }
}
