//
//  ViewModel.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation

class ViewModel {
    
    private let apiManager = SearchApiManager()
    private var batchcomplete: Bool!
    
    // usege of CustomLsitener of type pages.
    var pages: CustomListener<[Pages]?> = CustomListener(nil)
    var apiFailed: CustomListener<String?> = CustomListener(nil)
    /**
     @breif: This method do api request for getting results based on searched text.
     Parameter:
        searchText -> user searched text.
    **/
    func fetchSearch(text searchText: String) {
        self.pages.value = nil
        apiManager.fetchSearch(text: searchText) { (resultModel, errorMessage) in
            guard let result = resultModel else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            self.batchcomplete = result.batchcomplete
            guard let query = result.query else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            
            guard let pages = query.pages else {
                self.pages.value = nil
                self.apiFailed.value = "YES"
                return
            }
            
            self.apiFailed.value = "NO"
            self.pages.value = pages
            // Save result model in CoreData.
            // Need handle data for handling offline case.
            SearchResultDB.shared().saveResults(result)
        }
    }
    
    /**
     @brief: This returns number of itmes.
    **/
    func numberOfRows() -> Int {
        if self.pages.value == nil {
            return 0
        }
        return (self.pages.value?.count)!
    }
    
    /**
     @brief: This returns page object model based on index.
    **/
    func getPages(_ index: Int) -> Pages? {
        if let page = self.pages.value?[index] {
            return page
        }
        return nil
    }
    
    /**
     @brief: This returns page title based on index.
    **/
    func getTitle(_ index: Int) -> String? {
        if let page = self.pages.value?[index] {
            if let title = page.title {
                return title.replacingOccurrences(of: " ", with: "_")
            }
            return nil
        }
        return nil
    }
}
