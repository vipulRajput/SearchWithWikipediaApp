//
//  ResultDetails.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 16/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ResultDetails {
    
    var title: String = ""
    var extract: String = ""
    var source: String = ""
    
    init(result: JSON) {
        
        self.title = result["title"].stringValue
        self.extract = result["extract"].stringValue
        self.source = result["thumbnail"]["source"].stringValue
    }
}
