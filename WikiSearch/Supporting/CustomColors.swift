//
//  CustomColors.swift
//  Kwiz
//
//  Created by Manjunath Naragund on 17/06/18.
//  Copyright © 2018 Manjunath. All rights reserved.
//

import UIKit

extension UIColor {
    
    class func userSelectedClr() -> UIColor {
        return UIColor(red: 0, green: 191.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    }
    
    class func userSelectedBackgorundClr() -> UIColor {
        return UIColor(red: 0, green: 191.0/255.0, blue: 201.0/255.0, alpha: 0.1)
    }
    
    class func unselectedClr() -> UIColor {
       return UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 1.0)
    }
    
    class func unselectedBackgroundClr() -> UIColor {
        return UIColor(red: 151.0/255.0, green: 151.0/255.0, blue: 151.0/255.0, alpha: 0.1)
    }
    
    class func correctAnsClr() -> UIColor {
        return UIColor(red: 0, green: 193.0/255.0, blue: 30.0/255.0, alpha: 1.0)
    }
    
    class func correctAnsBackgroundClr() -> UIColor {
        return UIColor(red: 0, green: 193.0/255.0, blue: 30.0/255.0, alpha: 0.1)
    }
    
    class func wrongAnsClr() -> UIColor {
        return UIColor(red: 196.0/255.0, green: 0, blue: 0, alpha: 1.0)
    }
    
    class func wrongAnsBacgroundClr() -> UIColor {
        return UIColor(red: 196.0/255.0, green: 0, blue: 0, alpha: 0.1)
    }
    
    class func gernerateRandomColor() -> UIColor {
        let max = CGFloat(UInt32.max)
        let redColor = CGFloat.random(in: 20..<max - (max * 0.3)) / max
        let greenColor = CGFloat.random(in: 20..<max - (max * 0.4)) / max
        let bluecolor = CGFloat.random(in: 20..<max - (max * 0.5)) / max
        return UIColor(red: redColor, green: greenColor, blue: bluecolor, alpha: 1.0)
    }
}
