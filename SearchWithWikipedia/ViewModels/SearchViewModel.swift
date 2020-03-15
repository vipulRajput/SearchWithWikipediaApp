//
//  SearchViewModel.swift
//  SearchWithWikipedia
//
//  Created by Vipul Kumar on 15/03/20.
//  Copyright © 2020 Vipul Kumar. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ObserveViewModelChanges: class {
    func viewModelUpdated()
}

class SearchViewModel {
    
    var searchResult : SearchResult?
    var resultDetails : ResultDetails?
    var currentPage: Page?
    weak var observeViewModelChanges: ObserveViewModelChanges?
    var timer: Timer? = nil
    
    func getResultsOf(text: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AppNetworking.get(endPoint: "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages%7Cpageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize=100&pilimit=10&wbptterms=description&gpssearch=\(text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? text)&gpslimit=10", parameters: [:], headers: [:], loader: false, success: { (response) in
                            
                self.searchResult = SearchResult(result: response)
                DispatchQueue.global(qos: .userInitiated).async {
                    self.observeViewModelChanges?.viewModelUpdated()
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func getResultDetialsOf(text: String) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            AppNetworking.get(endPoint: "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&prop=extracts%7Cpageimages%7Crevisions&titles=\(self.currentPage!.title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? text)&redirects=&exintro=true&exsentences=2&explaintext=true&piprop=thumbnail&pithumbsize=300&rvprop=timestamp", parameters: [:], headers: [:], httpMethod: .get, loader: false, success: { (response) in
                            
                if let pages = response["query"]["pages"].array, let firstpage = pages.first {
                    self.resultDetails = ResultDetails(result: firstpage)
                    DispatchQueue.global(qos: .userInteractive).async {
                        self.observeViewModelChanges?.viewModelUpdated()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func debounce(seconds: TimeInterval, function: @escaping () -> Void ) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false, block: { _ in
            function()
        })
    }
}
