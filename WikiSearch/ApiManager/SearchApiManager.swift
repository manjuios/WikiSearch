//
//  ApiManager.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation

struct SearchApiManager {
    
    func fetchSearch(text searchText: String, completionBlock block: @escaping(_ resultModel: ResultModel?, _ error: String?)-> Void) {
        let path = UrlExtension.queryPath + searchText
        Webservice.shared.apiRequest(path, requestType: .get) { (data, error) in
            if error == nil {
                guard let data = data  else {
                    block(nil, "No Data")
                    return
                }
                do {
                    let searchResult = try JSONDecoder().decode(ResultModel.self, from: data)
                    block(searchResult, nil)
                } catch let exception {
                    print(exception.localizedDescription)
                    block(nil, "No Data")
                }
            }
        }
    }
}
