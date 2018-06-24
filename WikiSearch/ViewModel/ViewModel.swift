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
    var pages: CustomListener<[Pages]?> = CustomListener(nil)
    
    func fetchSearch(text searchText: String) {
        self.pages.value = nil
        apiManager.fetchSearch(text: searchText) { (result, errorMessage) in
            guard let result = result else {
                self.pages.value = nil
                return
            }
            self.batchcomplete = result.batchcomplete
            guard let query = result.query else {
                self.pages.value = nil
                return
            }
            
            guard let pages = query.pages else {
                self.pages.value = nil
                return
            }
            
            self.pages.value = pages
        }
    }
    
    func numberOfRows() -> Int {
        if self.pages.value == nil {
            return 0
        }
        return (self.pages.value?.count)!
    }
    
    func getPages(_ index: Int) -> Pages? {
        if let page = self.pages.value?[index] {
            return page
        }
        return nil
    }
    
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
