//
//  CustomListner.swift
//  WikiSearch
//
//  Created by Manjunath Naragund on 23/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation

/**
 @breif: This is generic data binding class. Use this bind data from viewModel to ViewController.
**/
class CustomListener<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    
    func bind(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ v: T) {
        value = v
    }
}
