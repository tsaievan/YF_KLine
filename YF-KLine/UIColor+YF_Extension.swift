//
//  UIColor+YF_Extension.swift
//  YF-KLine
//
//  Created by tsaievan on 27/2/18.
//  Copyright © 2018年 tsaievan. All rights reserved.
//

import UIKit

extension UIColor {
    class func color(RGBHex hex: UInt32) -> UIColor {
        let r = CGFloat((hex >> 16) & 0xFF)
        let g = CGFloat((hex >> 8) & 0xFF)
        let b = CGFloat((hex) & 0xFF)
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}
