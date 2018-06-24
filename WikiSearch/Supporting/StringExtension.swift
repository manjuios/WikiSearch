//
//  StringExtension.swift
//  Kwiz
//
//  Created by Manjunath Naragund on 17/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import Foundation
import UIKit.UIFont

extension String {
    
    func heightOfString(_ width: CGFloat) -> CGFloat {
        let text = self as NSString
        let constraintSize = CGSize(width: width, height: .greatestFiniteMagnitude)
        let rect = text.boundingRect(with: constraintSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 14.0)], context: nil)
        return rect.size.height
    }
}
