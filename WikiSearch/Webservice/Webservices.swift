//
//  Webservices.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation

/**
 @brief: RequestType is String enum. It is to handle the api request type. Like GET,POST etc.
**/
enum ResuestType: String {
    case get = "GET"
    case post = "POST"
}

struct Webservice {
    static let shared = Webservice()
    
    /**
     @brief: This method is to make server request. It will return data and error in completion block.
     Parameters :
        path -> endpoint and query path.
        type -> Request Type. POST,GET etc.
    **/
    func apiRequest(_ path: String, requestType type: ResuestType, completionBlock block: @escaping(_ data: Data?, _ error: Error?)-> Void) {
        guard let request = prepareRequest(path, .get) else {return}
        let urlSession = URLSession.shared
        let dataTask =  urlSession.dataTask(with: request) { (data, responseHeader, error) in
            guard let header = responseHeader else {
                block(nil, nil)
                return
            }
            
            let httpResponse = header as! HTTPURLResponse
            print(httpResponse.statusCode)
            if httpResponse.statusCode ==  200 {
                guard let d = data else {
                    block(nil, nil)
                    return
                }
                print(d)
                block(d, nil)
            } else {
                block(nil, error)
            }
        }
        dataTask.resume()
    }
    
    /**
     @brief: This method prepares UrlRequest.
     Parameters : path -> endpoint and query path
            type -> Request Type. POST,GET etc
     returns urlRequest.
    **/
    private func prepareRequest(_ path: String, _ type: ResuestType) -> URLRequest? {
        
        guard let urlPath = path.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) else {return nil}
        guard let url = URL(string: urlPath) else { return nil }
        var urlRequest = URLRequest(url: url)
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        urlRequest.timeoutInterval = 60
        urlRequest.setValue("Application/Json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = type.rawValue
        print(type.rawValue)
        return urlRequest
    }
}


/**
 This struct contains required endpoints.
**/
struct UrlExtension {
    static let queryPath = "https://en.wikipedia.org//w/api.php?action=query&format=json&prop=pageimages|pageterms&generator=prefixsearch&redirects=1&formatversion=2&piprop=thumbnail&pithumbsize= 200&pilimit=20&wbptterms=description&gpslimit=20&gpssearch="
}
