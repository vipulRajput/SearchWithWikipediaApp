//
//  SearchResult.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SearchResult {
    
    var batchcomplete: Bool = false
    var pages = [Page]()

    init(result: JSON) {
     
        self.batchcomplete = result["batchcomplete"].boolValue
        
        if let pagesArr = result["query"]["pages"].array {
            self.pages = pagesArr.map({ (value) -> Page in
                return Page(result: value)
            })
        }
    }
}

struct Page {
    
    var title: String = ""
    var index: Int = 0
    var source: String = ""
    var termsDescription = [String]()
    var ranomColor = UIColor.randomColor
    var representedLetters: String
    
    init(result: JSON) {
     
        self.title = result["title"].stringValue
        self.index = result["index"].intValue
        self.source = result["thumbnail"]["source"].stringValue
        self.representedLetters = result["title"].stringValue.getFirstTwoLetters()
        
        if let descArr = result["terms"]["description"].array {
            self.termsDescription = descArr.map({ (value) -> String in
                return value.stringValue
            })
        }
    }
}
